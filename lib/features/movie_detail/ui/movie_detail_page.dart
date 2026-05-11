import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_discovery/core/network/api_constants.dart';
import 'package:movie_discovery/design_system/app_colors.dart';
import 'package:movie_discovery/design_system/app_spacing.dart';
import 'package:movie_discovery/design_system/app_text_styles.dart';
import 'package:movie_discovery/design_system/widgets/app_network_image.dart';
import 'package:movie_discovery/design_system/widgets/empty_state.dart';
import 'package:movie_discovery/design_system/widgets/shimmer/shimmer_box.dart';
import 'package:movie_discovery/features/movies/data/movies_repository.dart';
import 'package:movie_discovery/features/movies/logic/movies_provider.dart';

String _detailPosterUrl(String? path) {
  if (path == null || path.isEmpty) return '';
  if (path.startsWith('http')) return path; // OMDB full URL
  return '${ApiConstants.tmdbImageLarge}$path'; // TMDB relative path
}

class MovieDetailPage extends ConsumerWidget {
  final int tmdbId;
  final int activeUserId;

  const MovieDetailPage({
    super.key,
    required this.tmdbId,
    required this.activeUserId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(movieDetailProvider(tmdbId));
    final isSavedAsync = ref.watch(isSavedProvider((activeUserId, tmdbId)));

    return Scaffold(
      body: detailAsync.when(
        loading: () => const _DetailShimmer(),
        error: (e, _) => const EmptyState(
          title: 'Could not load movie',
          subtitle: 'Check your connection and try again.',
        ),
        data: (movie) => CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 340,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  movie.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14),
                ),
                background: Hero(
                  tag: 'movie_poster_$tmdbId',
                  child: AppNetworkImage(
                    url: _detailPosterUrl(movie.posterPath),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              actions: [
                isSavedAsync.when(
                  data: (saved) => IconButton(
                    icon: Icon(
                      saved
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      await ref
                          .read(moviesRepositoryProvider)
                          .toggleSave(activeUserId, tmdbId);
                      ref.invalidate(isSavedProvider((activeUserId, tmdbId)));
                    },
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: AppSpacing.screen,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (movie.releaseDate != null)
                      Text(
                        movie.releaseDate!,
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.grey500),
                      ),
                    const SizedBox(height: AppSpacing.md),
                    if (movie.overview != null)
                      Text(movie.overview!, style: AppTextStyles.body),
                    const SizedBox(height: AppSpacing.lg),
                    _SaversRow(tmdbId: tmdbId),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SaversRow extends ConsumerWidget {
  final int tmdbId;
  const _SaversRow({required this.tmdbId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saversAsync = ref.watch(movieSaversProvider(tmdbId));
    return saversAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (savers) {
        if (savers.isEmpty) {
          return Text(
            'Be the first to save this.',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500),
          );
        }
        return Row(
          children: [
            ...savers.take(5).map(
                  (u) => Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: CircleAvatar(
                      radius: 14,
                      backgroundImage: u.avatarUrl != null
                          ? NetworkImage(u.avatarUrl!)
                          : null,
                      child: u.avatarUrl == null
                          ? Text(u.name[0].toUpperCase(),
                              style: const TextStyle(fontSize: 10))
                          : null,
                    ),
                  ),
                ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${savers.length} ${savers.length == 1 ? "user wants" : "users want"} to watch this',
                style: AppTextStyles.bodySmall,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DetailShimmer extends StatelessWidget {
  const _DetailShimmer();

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: [
        SliverAppBar(expandedHeight: 340, pinned: true),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: 80, height: 12),
                SizedBox(height: 16),
                ShimmerBox(width: double.infinity, height: 14),
                SizedBox(height: 6),
                ShimmerBox(width: double.infinity, height: 14),
                SizedBox(height: 6),
                ShimmerBox(width: 200, height: 14),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
