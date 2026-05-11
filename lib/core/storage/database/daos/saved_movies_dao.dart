part of '../app_database.dart';

class MovieWithSavers {
  final MoviesTableData movie;
  final int saverCount;
  MovieWithSavers({required this.movie, required this.saverCount});
}

@DriftAccessor(tables: [SavedMoviesTable, MoviesTable, UsersTable])
class SavedMoviesDao extends DatabaseAccessor<AppDatabase>
    with _$SavedMoviesDaoMixin {
  SavedMoviesDao(super.db);

  Stream<List<MoviesTableData>> watchSavedMoviesForUser(int userId) {
    final query = select(moviesTable).join([
      innerJoin(
        savedMoviesTable,
        savedMoviesTable.movieId.equalsExp(moviesTable.id) &
            savedMoviesTable.userId.equals(userId),
      )
    ]);
    return query
        .watch()
        .map((rows) => rows.map((r) => r.readTable(moviesTable)).toList());
  }

  Stream<int> watchSaveCountForMovie(int movieLocalId) {
    final count = savedMoviesTable.id.count();
    final query = selectOnly(savedMoviesTable)
      ..addColumns([count])
      ..where(savedMoviesTable.movieId.equals(movieLocalId));
    return query.watchSingle().map((row) => row.read(count) ?? 0);
  }

  Stream<List<MovieWithSavers>> watchMatches() {
    final saverCount = savedMoviesTable.userId.count();
    final movieId = moviesTable.id;
    final movieTitle = moviesTable.title;
    final movieOverview = moviesTable.overview;
    final moviePosterPath = moviesTable.posterPath;
    final movieReleaseDate = moviesTable.releaseDate;
    final moviePopularity = moviesTable.popularity;
    final movieTmdbId = moviesTable.tmdbId;

    final query = selectOnly(moviesTable).join([
      innerJoin(
        savedMoviesTable,
        savedMoviesTable.movieId.equalsExp(moviesTable.id),
      )
    ])
      ..addColumns([
        movieId,
        movieTmdbId,
        movieTitle,
        movieOverview,
        moviePosterPath,
        movieReleaseDate,
        moviePopularity,
        saverCount,
      ])
      ..groupBy([moviesTable.id], having: saverCount.isBiggerThanValue(1))
      ..orderBy([OrderingTerm.desc(saverCount)]);

    return query.watch().map((rows) => rows
        .map((row) => MovieWithSavers(
              movie: MoviesTableData(
                id: row.read(movieId)!,
                tmdbId: row.read(movieTmdbId)!,
                title: row.read(movieTitle)!,
                overview: row.read(movieOverview),
                posterPath: row.read(moviePosterPath),
                releaseDate: row.read(movieReleaseDate),
                popularity: row.read(moviePopularity),
              ),
              saverCount: row.read(saverCount) ?? 0,
            ))
        .toList());
  }

  Future<List<UsersTableData>> getUsersWhoSavedMovie(int movieLocalId) {
    final query = select(usersTable).join([
      innerJoin(
        savedMoviesTable,
        savedMoviesTable.userId.equalsExp(usersTable.id) &
            savedMoviesTable.movieId.equals(movieLocalId),
      )
    ]);
    return query.map((row) => row.readTable(usersTable)).get();
  }

  Future<bool> isMovieSavedByUser(int userId, int movieLocalId) async {
    final result = await (select(savedMoviesTable)
          ..where(
              (s) => s.userId.equals(userId) & s.movieId.equals(movieLocalId)))
        .getSingleOrNull();
    return result != null;
  }

  Future<void> saveMovie(int userId, int movieLocalId) =>
      into(savedMoviesTable).insert(
        SavedMoviesTableCompanion.insert(userId: userId, movieId: movieLocalId),
        mode: InsertMode.insertOrIgnore,
      );

  Future<void> unsaveMovie(int userId, int movieLocalId) =>
      (delete(savedMoviesTable)
            ..where((s) =>
                s.userId.equals(userId) & s.movieId.equals(movieLocalId)))
          .go();
}
