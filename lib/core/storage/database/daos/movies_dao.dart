part of '../app_database.dart';

@DriftAccessor(tables: [MoviesTable])
class MoviesDao extends DatabaseAccessor<AppDatabase> with _$MoviesDaoMixin {
  MoviesDao(super.db);

  Future<int> upsertMovie(MoviesTableCompanion movie) async {
    // insertOnConflictUpdate conflicts on primary key (id), not tmdb_id.
    // Manually check tmdb_id first to handle the unique constraint correctly.
    final existing = await getMovieByTmdbId(movie.tmdbId.value);
    if (existing != null) {
      await (update(moviesTable)..where((m) => m.tmdbId.equals(movie.tmdbId.value)))
          .write(movie);
      return existing.id;
    }
    return into(moviesTable).insert(movie);
  }

  Future<MoviesTableData?> getMovieByTmdbId(int tmdbId) =>
      (select(moviesTable)..where((m) => m.tmdbId.equals(tmdbId)))
          .getSingleOrNull();

  Future<List<MoviesTableData>> getMoviesByIds(List<int> ids) =>
      (select(moviesTable)..where((m) => m.id.isIn(ids))).get();
}
