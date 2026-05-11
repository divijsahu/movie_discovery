import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'app_database.g.dart';
part 'daos/users_dao.dart';
part 'daos/movies_dao.dart';
part 'daos/saved_movies_dao.dart';

// ─── Tables ───────────────────────────────────────────────

class UsersTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get serverId => text().nullable()();
  TextColumn get name => text()();
  TextColumn get movieTaste => text()();
  TextColumn get email => text().nullable()();
  TextColumn get avatarUrl => text().nullable()();
  BoolColumn get pendingSync => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class MoviesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get tmdbId => integer().unique()();
  TextColumn get title => text()();
  TextColumn get overview => text().nullable()();
  TextColumn get posterPath => text().nullable()();
  TextColumn get releaseDate => text().nullable()();
  RealColumn get popularity => real().nullable()();
}

class SavedMoviesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(UsersTable, #id)();
  IntColumn get movieId => integer().references(MoviesTable, #id)();
  DateTimeColumn get savedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {userId, movieId}
      ];
}

// ─── Database ─────────────────────────────────────────────

@DriftDatabase(
  tables: [UsersTable, MoviesTable, SavedMoviesTable],
  daos: [UsersDao, MoviesDao, SavedMoviesDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // Remove duplicate remote users — keep only the row with the lowest id
            // for each serverId, delete the rest.
            await customStatement('''
          DELETE FROM users_table
          WHERE server_id IS NOT NULL
            AND id NOT IN (
              SELECT MIN(id) FROM users_table
              WHERE server_id IS NOT NULL
              GROUP BY server_id
            )
        ''');
          }
        },
      );

  static QueryExecutor _openConnection() =>
      driftDatabase(name: 'movie_discovery_db');
}

// ─── Provider ─────────────────────────────────────────────

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
