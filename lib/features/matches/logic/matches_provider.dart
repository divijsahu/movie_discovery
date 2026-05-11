import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_discovery/core/storage/database/app_database.dart';

final matchesProvider = StreamProvider<List<MovieWithSavers>>((ref) {
  return ref.watch(appDatabaseProvider).savedMoviesDao.watchMatches();
});

final totalUsersCountProvider = StreamProvider<int>((ref) {
  return ref
      .watch(appDatabaseProvider)
      .usersDao
      .watchAllUsersWithCount()
      .map((users) => users.length);
});
