import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_discovery/core/network/api_constants.dart';
import 'package:movie_discovery/core/router/route_names.dart';
import 'package:movie_discovery/core/utils/extensions/context_ext.dart';
import 'package:movie_discovery/design_system/app_colors.dart';
import 'package:movie_discovery/design_system/app_radius.dart';
import 'package:movie_discovery/design_system/app_text_styles.dart';
import 'package:movie_discovery/design_system/widgets/app_card.dart';
import 'package:movie_discovery/design_system/widgets/app_network_image.dart';
import 'package:movie_discovery/design_system/widgets/empty_state.dart';
import 'package:movie_discovery/design_system/widgets/shimmer/movie_list_shimmer.dart';
import 'package:movie_discovery/design_system/widgets/reconnecting_bar.dart';
import 'package:movie_discovery/features/movies/data/movies_repository.dart';
import 'package:movie_discovery/features/saved_movies/logic/saved_movies_provider.dart';

String _posterUrl(String? path) {
  if (path == null || path.isEmpty) return '';
  if (path.startsWith('http')) return path;
  return '${ApiConstants.tmdbImageSmall}$path';
}

class SavedMoviesPage extends ConsumerWidget {
  final int userId;
  const SavedMoviesPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedAsync = ref.watch(savedMoviesProvider(userId));

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Movies')),
      body: Column(
        children: [
          const ReconnectingBar(),
          Expanded(
            child: savedAsync.when(
              loading: () => const MovieListShimmer(),
              error: (e, _) => EmptyState(message: e.toString()),
              data: (movies) {
                if (movies.isEmpty) {
                  return EmptyState(
                    icon: Icons.bookmark_border_rounded,
                    title: 'No saved movies yet',
                    subtitle: 'Browse trending movies and bookmark the ones you want to watch.',
                    action: TextButton.icon(
                      onPressed: () => context.push(RouteNames.movies(userId)),
                      icon: const Icon(Icons.movie_outlined),
                      label: const Text('Browse Movies'),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
                  physics: const BouncingScrollPhysics(),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return AppCard(
                      key: ValueKey(movie.id),
                      onTap: () => context.push(
                        RouteNames.movieDetail(movie.tmdbId, userId: userId),
                      ),
                      child: Row(
                        children: [
                          AppNetworkImage(
                            url: _posterUrl(movie.posterPath),
                            width: 60,
                            height: 88,
                            borderRadius: AppRadius.smAll,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(movie.title,
                                    style: AppTextStyles.h3,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                                if (movie.releaseDate != null &&
                                    movie.releaseDate!.length >= 4) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    movie.releaseDate!.substring(0, 4),
                                    style: AppTextStyles.caption
                                        .copyWith(color: AppColors.grey500),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.bookmark_rounded,
                                color: AppColors.primary),
                            onPressed: () => ref
                                .read(moviesRepositoryProvider)
                                .toggleSave(userId, movie.tmdbId),
                          ),
                        ],
                      ),
                    )
                        .animate(
                          key: ValueKey('anim_saved_${movie.id}'),
                          delay: Duration(milliseconds: (index % 20) * 40),
                        )
                        .fadeIn(duration: 300.ms)
                        .slideX(begin: 0.04);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
