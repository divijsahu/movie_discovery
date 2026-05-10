import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_discovery/core/error/result.dart';
import 'package:movie_discovery/features/users/data/users_repository.dart';

class UsersNotifier extends AsyncNotifier<void> {
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isFetchingMore = false;

  @override
  Future<void> build() async {
    await _loadPage(1);
  }

  Future<void> _loadPage(int page) async {
    final result =
        await ref.read(usersRepositoryProvider).fetchAndCachePage(page);
    result.when(
      success: (response) {
        _totalPages = response.totalPages;
        _currentPage = response.page;
      },
      failure: (_) {},
    );
  }

  Future<void> loadMore() async {
    if (_isFetchingMore || _currentPage >= _totalPages) return;
    _isFetchingMore = true;
    await _loadPage(_currentPage + 1);
    _isFetchingMore = false;
  }

  Future<void> refresh() async {
    _currentPage = 1;
    ref.invalidateSelf();
  }
}

final usersNotifierProvider =
    AsyncNotifierProvider<UsersNotifier, void>(UsersNotifier.new);

final usersStreamProvider = StreamProvider(
  (ref) => ref.watch(usersRepositoryProvider).watchUsers(),
);
