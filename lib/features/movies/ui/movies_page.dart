import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_discovery/design_system/widgets/empty_state.dart';
import 'package:movie_discovery/design_system/widgets/reconnecting_bar.dart';
import 'package:movie_discovery/design_system/widgets/shimmer/movie_list_shimmer.dart';
import 'package:movie_discovery/features/movies/logic/movies_provider.dart';
import 'package:movie_discovery/features/movies/ui/widgets/movie_card.dart';

class MoviesPage extends ConsumerWidget {
  final int userId;
  const MoviesPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetchState = ref.watch(moviesNotifierProvider);
    final movies = ref.watch(moviesListProvider);
    final isFetching = fetchState.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Trending Movies')),
      body: Column(
        children: [
          const ReconnectingBar(),
          Expanded(
            child: () {
              if (isFetching && movies.isEmpty) return const MovieListShimmer();
              if (movies.isEmpty) {
                return const EmptyState(
                  icon: Icons.movie_outlined,
                  title: 'No movies yet',
                  subtitle: 'Check your internet connection.',
                );
              }
              return NotificationListener<ScrollNotification>(
                onNotification: (n) {
                  if (n.metrics.pixels >= n.metrics.maxScrollExtent - 300) {
                    ref.read(moviesNotifierProvider.notifier).loadMore();
                  }
                  return false;
                },
                child: RefreshIndicator(
                  onRefresh: () =>
                      ref.read(moviesNotifierProvider.notifier).refresh(),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      return MovieCard(
                        key: ValueKey(movies[index].id),
                        movie: movies[index],
                        activeUserId: userId,
                      )
                          .animate(
                            key: ValueKey('anim_${movies[index].id}'),
                            delay: Duration(milliseconds: (index % 20) * 40),
                          )
                          .fadeIn(duration: 300.ms)
                          .slideX(begin: 0.04);
                    },
                  ),
                ),
              );
            }(),
          ),
        ],
      ),
    );
  }
}
