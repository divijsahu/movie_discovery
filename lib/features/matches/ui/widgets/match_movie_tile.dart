import 'package:flutter/material.dart';
import 'package:movie_discovery/core/network/api_constants.dart';
import 'package:movie_discovery/core/storage/database/app_database.dart';
import 'package:movie_discovery/design_system/app_colors.dart';
import 'package:movie_discovery/design_system/app_radius.dart';
import 'package:movie_discovery/design_system/app_text_styles.dart';
import 'package:movie_discovery/design_system/widgets/app_card.dart';
import 'package:movie_discovery/design_system/widgets/app_network_image.dart';

String _posterUrl(String? path) {
  if (path == null || path.isEmpty) return '';
  if (path.startsWith('http')) return path;
  return '${ApiConstants.tmdbImageSmall}$path';
}

class MatchMovieTile extends StatelessWidget {
  final MovieWithSavers match;
  final bool isTopPick;
  final VoidCallback? onTap;

  const MatchMovieTile({
    super.key,
    required this.match,
    this.isTopPick = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final movie = match.movie;
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Hero(
            tag: 'match_poster_${movie.tmdbId}',
            child: AppNetworkImage(
              url: _posterUrl(movie.posterPath),
              width: 60,
              height: 88,
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
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.people_rounded,
                        size: 14, color: AppColors.grey500),
                    const SizedBox(width: 4),
                    Text(
                      '${match.saverCount} ${match.saverCount == 1 ? "person" : "people"} want to watch',
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.grey500),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isTopPick)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.local_fire_department_rounded,
                      size: 12, color: AppColors.secondary),
                  const SizedBox(width: 3),
                  Text(
                    'Top Pick',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
