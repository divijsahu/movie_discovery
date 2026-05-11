import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_discovery/core/error/result.dart';
import 'package:movie_discovery/features/users/data/users_repository.dart';

// ignore_for_file: avoid_print, curly_braces_in_flow_control_structures

class UsersNotifier extends AsyncNotifier<void> {
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isFetchingMore = false;

  @override
  Future<void> build() async {
    if (kDebugMode) print('\n🚀 [App] starting up — loading users page 1');
    await _loadPage(1);
  }

  Future<void> _loadPage(int page) async {
    final result =
        await ref.read(usersRepositoryProvider).fetchAndCachePage(page);
    result.when(
      success: (response) {
        _totalPages = response.totalPages;
        _currentPage = response.page;
        if (kDebugMode)
          print(
              '📊 [Users] page $_currentPage/$_totalPages loaded — ${response.data.length} users');
      },
      failure: (f) {
        if (kDebugMode) print('⚠️  [Users] page $page failed: ${f.message}');
      },
    );
  }

  Future<void> loadMore() async {
    if (_isFetchingMore || _currentPage >= _totalPages) return;
    _isFetchingMore = true;
    if (kDebugMode)
      print('🔽 [Users] loading more — page ${_currentPage + 1}/$_totalPages');
    await _loadPage(_currentPage + 1);
    _isFetchingMore = false;
  }

  Future<void> refresh() async {
    if (kDebugMode) print('🔄 [Users] pull-to-refresh triggered');
    _currentPage = 1;
    ref.invalidateSelf();
  }
}

final usersNotifierProvider =
    AsyncNotifierProvider<UsersNotifier, void>(UsersNotifier.new);

final usersStreamProvider = StreamProvider(
  (ref) => ref.watch(usersRepositoryProvider).watchUsers(),
);
