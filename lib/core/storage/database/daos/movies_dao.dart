part of '../app_database.dart';

@DriftAccessor(tables: [MoviesTable])
class MoviesDao extends DatabaseAccessor<AppDatabase> with _$MoviesDaoMixin {
  MoviesDao(super.db);

  Future<int> upsertMovie(MoviesTableCompanion movie) =>
      into(moviesTable).insertOnConflictUpdate(movie);

  Future<MoviesTableData?> getMovieByTmdbId(int tmdbId) =>
      (select(moviesTable)..where((m) => m.tmdbId.equals(tmdbId)))
          .getSingleOrNull();

  Future<List<MoviesTableData>> getMoviesByIds(List<int> ids) =>
      (select(moviesTable)..where((m) => m.id.isIn(ids))).get();
}
