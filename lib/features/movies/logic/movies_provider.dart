import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_discovery/core/error/result.dart';
import 'package:movie_discovery/features/movies/data/movies_repository.dart';
import 'package:movie_discovery/features/movies/data/models/movie_model.dart';

// ignore_for_file: avoid_print

typedef MoviesState = ({List<MovieModel> movies, String? error});

class MoviesNotifier extends AsyncNotifier<MoviesState> {
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isFetchingMore = false;

  @override
  Future<MoviesState> build() async {
    if (kDebugMode) print('\n🎬 [Movies] starting up — loading page 1');
    return _loadPage(1, current: []);
  }

  Future<MoviesState> _loadPage(int page, {required List<MovieModel> current}) async {
    final result = await ref.read(moviesRepositoryProvider).fetchTrending(page);
    return result.when(
      success: (response) {
        _totalPages = response.totalPages;
        _currentPage = response.page;
        final updated = page == 1
            ? response.results
            : [...current, ...response.results];
        if (kDebugMode) print('📊 [Movies] page $_currentPage/$_totalPages loaded — ${response.results.length} movies');
        return (movies: updated, error: null);
      },
      failure: (f) {
        if (kDebugMode) print('⚠️  [Movies] page $page failed: ${f.message}');
        // Keep existing list if we have one, only surface error when empty
        return (movies: current, error: current.isEmpty ? f.message : null);
      },
    );
  }

  Future<void> loadMore() async {
    if (_isFetchingMore || _currentPage >= _totalPages) return;
    _isFetchingMore = true;
    if (kDebugMode) print('🔽 [Movies] loading more — page ${_currentPage + 1}/$_totalPages');
    final current = state.valueOrNull?.movies ?? [];
    state = AsyncData(await _loadPage(_currentPage + 1, current: current));
    _isFetchingMore = false;
  }

  Future<void> refresh() async {
    if (kDebugMode) print('🔄 [Movies] refresh triggered');
    _currentPage = 1;
    state = const AsyncLoading();
    state = AsyncData(await _loadPage(1, current: []));
  }
}

final moviesNotifierProvider =
    AsyncNotifierProvider<MoviesNotifier, MoviesState>(MoviesNotifier.new);

final moviesListProvider = Provider<List<MovieModel>>(
  (ref) => ref.watch(moviesNotifierProvider).valueOrNull?.movies ?? [],
);

final moviesErrorProvider = Provider<String?>(
  (ref) => ref.watch(moviesNotifierProvider).valueOrNull?.error,
);

final saveCountProvider = StreamProvider.family<int, int>((ref, tmdbId) {
  return ref.watch(moviesRepositoryProvider).watchSaveCount(tmdbId);
});

final isSavedProvider = FutureProvider.family<bool, (int, int)>((ref, args) {
  final (userId, tmdbId) = args;
  return ref.watch(moviesRepositoryProvider).isSaved(userId, tmdbId);
});

final movieSaversProvider = FutureProvider.family((ref, int tmdbId) {
  return ref.watch(moviesRepositoryProvider).getUsersWhoSaved(tmdbId);
});

final movieDetailProvider = FutureProvider.family((ref, int tmdbId) async {
  final result =
      await ref.watch(moviesRepositoryProvider).fetchDetail(tmdbId);
  return result.when(
    success: (m) => m,
    failure: (f) => throw f.message,
  );
});
