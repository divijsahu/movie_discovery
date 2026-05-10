import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_discovery/core/router/route_names.dart';
import 'package:movie_discovery/core/utils/extensions/context_ext.dart';
import 'package:movie_discovery/design_system/widgets/empty_state.dart';
import 'package:movie_discovery/design_system/widgets/shimmer/movie_list_shimmer.dart';
import 'package:movie_discovery/design_system/widgets/reconnecting_bar.dart';
import 'package:movie_discovery/features/matches/logic/matches_provider.dart';
import 'package:movie_discovery/features/matches/ui/widgets/match_movie_tile.dart';

class MatchesPage extends ConsumerWidget {
  const MatchesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchesAsync = ref.watch(matchesProvider);
    final totalUsersAsync = ref.watch(totalUsersCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Matches'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const ReconnectingBar(),
          Expanded(
            child: matchesAsync.when(
              loading: () => const MovieListShimmer(),
              error: (e, _) => EmptyState(message: e.toString()),
              data: (matches) {
                if (matches.isEmpty) {
                  return const EmptyState(
                    icon: Icons.group_rounded,
                    title: 'No matches yet',
                    subtitle:
                        'When 2 or more users save the same movie, it appears here.',
                  );
                }
                final totalUsers = totalUsersAsync.valueOrNull ?? 0;
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
                  physics: const BouncingScrollPhysics(),
                  itemCount: matches.length,
                  itemBuilder: (context, index) {
                    final match = matches[index];
                    final isTopPick =
                        totalUsers > 1 && match.saverCount >= totalUsers;
                    return MatchMovieTile(
                      key: ValueKey(match.movie.id),
                      match: match,
                      isTopPick: isTopPick,
                      onTap: () => context.push(
                        RouteNames.movieDetail(match.movie.tmdbId, userId: 0),
                      ),
                    )
                        .animate(
                          key: ValueKey('anim_match_${match.movie.id}'),
                          delay: Duration(milliseconds: (index % 20) * 50),
                        )
                        .fadeIn(duration: 300.ms)
                        .slideY(begin: 0.05);
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
