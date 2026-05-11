import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_discovery/core/error/failures.dart';
import 'package:movie_discovery/core/error/result.dart';
import 'package:movie_discovery/core/storage/database/app_database.dart';
import 'package:movie_discovery/features/movies/data/models/movie_model.dart';
import 'package:movie_discovery/features/movies/data/movies_api.dart';
import 'package:movie_discovery/features/movies/data/omdb_api.dart';

// ignore_for_file: avoid_print

// Matches the number of search terms in OmdbApi so pagination stops correctly
const _searchTermsCount = 20;

class MoviesRepository {
  final MoviesApi _tmdb;
  final OmdbApi _omdb;
  final AppDatabase _db;
  MoviesRepository(this._tmdb, this._omdb, this._db);

  Future<Result<MoviesPageResponse>> fetchTrending(int page) async {
    // Try TMDB first
    if (kDebugMode) print('🎬 [Movies] fetching page $page from TMDB...');
    try {
      final response = await _tmdb.fetchTrending(page);
      await _cacheMovies(response.results);
      if (kDebugMode) print('💾 [Movies] cached ${response.results.length} movies to DB  (page ${response.page}/${response.totalPages})');
      return Success(response);
    } on DioException catch (e) {
      if (kDebugMode) print('⚠️  [Movies] TMDB failed (${e.type.name}) — trying OMDB fallback...');
    }

    // OMDB fallback
    try {
      final movies = await _omdb.fetchPopular(page);
      if (kDebugMode) print('📊 [Movies] OMDB returned ${movies.length} movies for page $page');
      if (movies.isEmpty) return const Failure(NetworkFailure());
      await _cacheMovies(movies);
      if (kDebugMode) print('💾 [Movies] OMDB fallback: cached ${movies.length} movies to DB');
      return Success(MoviesPageResponse(
        page: page,
        totalPages: _searchTermsCount,
        results: movies,
      ));
    } on DioException catch (e) {
      if (kDebugMode) print('❌ [Movies] OMDB also failed: ${e.type.name}');
      return Failure(AppFailure.fromDio(e));
    }
  }

  Future<void> _cacheMovies(List<MovieModel> movies) async {
    for (final movie in movies) {
      try {
        await _db.moviesDao.upsertMovie(MoviesTableCompanion.insert(
          tmdbId: movie.id,
          title: movie.title,
          overview: Value(movie.overview),
          posterPath: Value(movie.posterPath),
          releaseDate: Value(movie.releaseDate),
          popularity: Value(movie.popularity),
        ));
      } catch (e) {
        if (kDebugMode) print('⚠️  [Movies] cache failed for "${movie.title}" (id=${movie.id}): $e');
      }
    }
  }

  Future<Result<MovieModel>> fetchDetail(int tmdbId) async {
    // Check DB cache first — if we have it, serve immediately
    final cached = await _db.moviesDao.getMovieByTmdbId(tmdbId);

    // Try TMDB detail (only makes sense for real TMDB IDs, i.e. < 10 million)
    if (tmdbId < 10000000) {
      try {
        final movie = await _tmdb.fetchDetail(tmdbId);
        return Success(movie);
      } on DioException catch (_) {}
    }

    // Try OMDB by constructing imdbID (best effort for real TMDB IDs)
    if (tmdbId < 10000000) {
      try {
        final imdbId = 'tt${tmdbId.toString().padLeft(7, '0')}';
        final movie = await _omdb.fetchDetailByImdbId(imdbId);
        if (movie != null) return Success(movie);
      } catch (_) {}
    }

    // Fall back to DB cache (covers OMDB-sourced movies whose id is a hashCode)
    if (cached != null) {
      return Success(MovieModel(
        id: cached.tmdbId,
        title: cached.title,
        overview: cached.overview,
        posterPath: cached.posterPath,
        releaseDate: cached.releaseDate,
        popularity: cached.popularity,
      ));
    }

    return const Failure(NetworkFailure());
  }

  Future<void> toggleSave(int userId, int tmdbId) async {
    final movie = await _db.moviesDao.getMovieByTmdbId(tmdbId);
    if (movie == null) return;
    final isSaved =
        await _db.savedMoviesDao.isMovieSavedByUser(userId, movie.id);
    if (isSaved) {
      await _db.savedMoviesDao.unsaveMovie(userId, movie.id);
      if (kDebugMode) print('🔖 [Movies] unsaved tmdbId=$tmdbId for userId=$userId');
    } else {
      await _db.savedMoviesDao.saveMovie(userId, movie.id);
      if (kDebugMode) print('🔖 [Movies] saved tmdbId=$tmdbId for userId=$userId');
    }
  }

  Stream<int> watchSaveCount(int tmdbId) async* {
    final movie = await _db.moviesDao.getMovieByTmdbId(tmdbId);
    if (movie == null) { yield 0; return; }
    yield* _db.savedMoviesDao.watchSaveCountForMovie(movie.id);
  }

  Future<bool> isSaved(int userId, int tmdbId) async {
    final movie = await _db.moviesDao.getMovieByTmdbId(tmdbId);
    if (movie == null) return false;
    return _db.savedMoviesDao.isMovieSavedByUser(userId, movie.id);
  }

  Future<List<UsersTableData>> getUsersWhoSaved(int tmdbId) async {
    final movie = await _db.moviesDao.getMovieByTmdbId(tmdbId);
    if (movie == null) return [];
    return _db.savedMoviesDao.getUsersWhoSavedMovie(movie.id);
  }
}

final moviesRepositoryProvider = Provider<MoviesRepository>(
  (ref) => MoviesRepository(
    ref.watch(moviesApiProvider),
    ref.watch(omdbApiProvider),
    ref.watch(appDatabaseProvider),
  ),
);
