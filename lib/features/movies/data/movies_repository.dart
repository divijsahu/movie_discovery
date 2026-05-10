import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_discovery/core/error/failures.dart';
import 'package:movie_discovery/core/error/result.dart';
import 'package:movie_discovery/core/storage/database/app_database.dart';
import 'package:movie_discovery/features/movies/data/models/movie_model.dart';
import 'package:movie_discovery/features/movies/data/movies_api.dart';

// ignore_for_file: avoid_print

class MoviesRepository {
  final MoviesApi _api;
  final AppDatabase _db;
  MoviesRepository(this._api, this._db);

  Future<Result<MoviesPageResponse>> fetchTrending(int page) async {
    if (kDebugMode) print('🎬 [Movies] fetching page $page from TMDB...');
    try {
      final response = await _api.fetchTrending(page);
      for (final movie in response.results) {
        await _db.moviesDao.upsertMovie(MoviesTableCompanion.insert(
          tmdbId: movie.id,
          title: movie.title,
          overview: Value(movie.overview),
          posterPath: Value(movie.posterPath),
          releaseDate: Value(movie.releaseDate),
          popularity: Value(movie.popularity),
        ));
      }
      if (kDebugMode) {
        print('💾 [Movies] cached ${response.results.length} movies to DB  (page ${response.page}/${response.totalPages})');
      }
      return Success(response);
    } on DioException catch (e) {
      if (kDebugMode) print('⚠️  [Movies] fetch failed: ${e.type.name}');
      return Failure(AppFailure.fromDio(e));
    }
  }

  Future<Result<MovieModel>> fetchDetail(int tmdbId) async {
    try {
      final movie = await _api.fetchDetail(tmdbId);
      return Success(movie);
    } on DioException catch (e) {
      return Failure(AppFailure.fromDio(e));
    }
  }

  Future<void> toggleSave(int userId, int tmdbId) async {
    final movie = await _db.moviesDao.getMovieByTmdbId(tmdbId);
    if (movie == null) return;
    final isSaved = await _db.savedMoviesDao.isMovieSavedByUser(userId, movie.id);
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
    ref.watch(appDatabaseProvider),
  ),
);
