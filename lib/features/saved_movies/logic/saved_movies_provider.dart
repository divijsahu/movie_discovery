import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_discovery/core/storage/database/app_database.dart';

final savedMoviesProvider =
    StreamProvider.family<List<MoviesTableData>, int>((ref, userId) {
  return ref
      .watch(appDatabaseProvider)
      .savedMoviesDao
      .watchSavedMoviesForUser(userId);
});
