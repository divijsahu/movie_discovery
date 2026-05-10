import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_discovery/core/network/api_constants.dart';
import 'package:movie_discovery/core/router/route_names.dart';
import 'package:movie_discovery/core/utils/extensions/context_ext.dart';
import 'package:movie_discovery/design_system/app_colors.dart';
import 'package:movie_discovery/design_system/app_radius.dart';
import 'package:movie_discovery/design_system/app_text_styles.dart';
import 'package:movie_discovery/design_system/widgets/app_card.dart';
import 'package:movie_discovery/design_system/widgets/app_network_image.dart';
import 'package:movie_discovery/design_system/widgets/save_count_badge.dart';
import 'package:movie_discovery/features/movies/data/models/movie_model.dart';
import 'package:movie_discovery/features/movies/data/movies_repository.dart';
import 'package:movie_discovery/features/movies/logic/movies_provider.dart';

class MovieCard extends ConsumerWidget {
  final MovieModel movie;
  final int activeUserId;

  const MovieCard({
    super.key,
    required this.movie,
    required this.activeUserId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saveCount = ref.watch(saveCountProvider(movie.id));
    final isSavedAsync = ref.watch(isSavedProvider((activeUserId, movie.id)));

    return AppCard(
      onTap: () => context.push(RouteNames.movieDetail(movie.id, userId: activeUserId)),
      child: Row(
        children: [
          Hero(
            tag: 'movie_poster_${movie.id}',
            child: AppNetworkImage(
              url: '${ApiConstants.tmdbImageSmall}${movie.posterPath}',
              width: 70,
              height: 100,
              borderRadius: AppRadius.smAll,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: AppTextStyles.h3,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                if (movie.releaseDate != null && movie.releaseDate!.length >= 4)
                  Text(
                    movie.releaseDate!.substring(0, 4),
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.grey500),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              saveCount.when(
                data: (count) => SaveCountBadge(count: count),
                loading: () => const SizedBox(width: 28, height: 20),
                error: (_, __) => const SizedBox.shrink(),
              ),
              isSavedAsync.when(
                data: (saved) => IconButton(
                  onPressed: () => ref
                      .read(moviesRepositoryProvider)
                      .toggleSave(activeUserId, movie.id),
                  icon: Icon(
                    saved
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    color: saved ? AppColors.primary : AppColors.grey500,
                  ),
                ),
                loading: () => const SizedBox.square(
                  dimension: 40,
                  child: Center(
                    child: SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
