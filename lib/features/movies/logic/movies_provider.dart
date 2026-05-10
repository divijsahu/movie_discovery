import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_discovery/core/error/result.dart';
import 'package:movie_discovery/features/movies/data/movies_repository.dart';
import 'package:movie_discovery/features/movies/data/models/movie_model.dart';

// ignore_for_file: avoid_print

// Holds the fetched movie list in memory for the current session
final _moviesListProvider = StateProvider<List<MovieModel>>((ref) => []);

class MoviesNotifier extends AsyncNotifier<void> {
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isFetchingMore = false;

  @override
  Future<void> build() async {
    if (kDebugMode) print('\n🎬 [Movies] starting up — loading page 1');
    await _loadPage(1);
  }

  Future<void> _loadPage(int page) async {
    final result = await ref.read(moviesRepositoryProvider).fetchTrending(page);
    result.when(
      success: (response) {
        _totalPages = response.totalPages;
        _currentPage = response.page;
        final current = ref.read(_moviesListProvider);
        if (page == 1) {
          ref.read(_moviesListProvider.notifier).state = response.results;
        } else {
          ref.read(_moviesListProvider.notifier).state = [...current, ...response.results];
        }
        if (kDebugMode) print('📊 [Movies] page $_currentPage/$_totalPages loaded — ${response.results.length} movies');
      },
      failure: (f) {
        if (kDebugMode) print('⚠️  [Movies] page $page failed: ${f.message}');
      },
    );
  }

  Future<void> loadMore() async {
    if (_isFetchingMore || _currentPage >= _totalPages) return;
    _isFetchingMore = true;
    if (kDebugMode) print('🔽 [Movies] loading more — page ${_currentPage + 1}/$_totalPages');
    await _loadPage(_currentPage + 1);
    _isFetchingMore = false;
  }

  Future<void> refresh() async {
    if (kDebugMode) print('🔄 [Movies] refresh triggered');
    _currentPage = 1;
    ref.invalidateSelf();
  }
}

final moviesNotifierProvider =
    AsyncNotifierProvider<MoviesNotifier, void>(MoviesNotifier.new);

final moviesListProvider = Provider<List<MovieModel>>(
  (ref) => ref.watch(_moviesListProvider),
);

final saveCountProvider = StreamProvider.family<int, int>((ref, tmdbId) {
  return ref.watch(moviesRepositoryProvider).watchSaveCount(tmdbId);
});

final isSavedProvider = FutureProvider.family<bool, (int, int)>((ref, args) {
  final (userId, tmdbId) = args;
  return ref.watch(moviesRepositoryProvider).isSaved(userId, tmdbId);
});

final movieSaversProvider =
    FutureProvider.family((ref, int tmdbId) {
  return ref.watch(moviesRepositoryProvider).getUsersWhoSaved(tmdbId);
});
