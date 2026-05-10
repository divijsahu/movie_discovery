import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_discovery/core/error/failures.dart';
import 'package:movie_discovery/core/error/result.dart';
import 'package:movie_discovery/core/storage/database/app_database.dart';
import 'package:movie_discovery/features/users/data/models/user_model.dart';
import 'package:movie_discovery/features/users/data/users_api.dart';

class UsersRepository {
  final UsersApi _api;
  final AppDatabase _db;
  UsersRepository(this._api, this._db);

  Stream<List<UserWithSaveCount>> watchUsers() =>
      _db.usersDao.watchAllUsersWithCount();

  Future<Result<UsersResponse>> fetchAndCachePage(int page) async {
    try {
      final response = await _api.fetchUsers(page);
      for (final user in response.data) {
        await _db.usersDao.upsertRemoteUser(UsersTableCompanion.insert(
          serverId: Value(user.id.toString()),
          name: '${user.firstName} ${user.lastName}',
          movieTaste: '',
          email: Value(user.email),
          avatarUrl: Value(user.avatar),
        ));
      }
      return Success(response);
    } on DioException catch (e) {
      return Failure(AppFailure.fromDio(e));
    }
  }
}

final usersRepositoryProvider = Provider<UsersRepository>(
  (ref) => UsersRepository(
    ref.watch(usersApiProvider),
    ref.watch(appDatabaseProvider),
  ),
);
