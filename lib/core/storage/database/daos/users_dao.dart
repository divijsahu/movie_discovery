part of '../app_database.dart';

class UserWithSaveCount {
  final UsersTableData user;
  final int saveCount;
  UserWithSaveCount({required this.user, required this.saveCount});
}

@DriftAccessor(tables: [UsersTable, SavedMoviesTable])
class UsersDao extends DatabaseAccessor<AppDatabase> with _$UsersDaoMixin {
  UsersDao(super.db);

  Stream<List<UserWithSaveCount>> watchAllUsersWithCount() {
    final count = savedMoviesTable.id.count();
    final query = (select(usersTable)
          ..orderBy([(u) => OrderingTerm.desc(u.createdAt)]))
        .join([
          leftOuterJoin(
            savedMoviesTable,
            savedMoviesTable.userId.equalsExp(usersTable.id),
          )
        ])
      ..addColumns([count])
      ..groupBy([usersTable.id]);

    return query.watch().map((rows) => rows
        .map((row) => UserWithSaveCount(
              user: row.readTable(usersTable),
              saveCount: row.read(count) ?? 0,
            ))
        .toList());
  }

  Future<int> insertUser(UsersTableCompanion user) =>
      into(usersTable).insert(user);

  Future<void> updateServerId(int localId, String serverId) =>
      (update(usersTable)..where((u) => u.id.equals(localId)))
          .write(UsersTableCompanion(serverId: Value(serverId)));

  Future<void> markSynced(int localId) =>
      (update(usersTable)..where((u) => u.id.equals(localId)))
          .write(const UsersTableCompanion(pendingSync: Value(false)));

  Future<List<UsersTableData>> getPendingSyncUsers() =>
      (select(usersTable)..where((u) => u.pendingSync.equals(true))).get();

  Future<void> upsertRemoteUser(UsersTableCompanion user) =>
      into(usersTable).insertOnConflictUpdate(user);
}
