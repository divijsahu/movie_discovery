import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_discovery/core/router/route_names.dart';
import 'package:movie_discovery/core/utils/extensions/context_ext.dart';
import 'package:movie_discovery/design_system/widgets/empty_state.dart';
import 'package:movie_discovery/design_system/widgets/reconnecting_bar.dart';
import 'package:movie_discovery/design_system/widgets/shimmer/user_list_shimmer.dart';
import 'package:movie_discovery/features/users/logic/users_provider.dart';
import 'package:movie_discovery/features/users/ui/widgets/user_list_tile.dart';

class UsersPage extends ConsumerWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersStreamProvider);
    // isLoading = true only on the very first fetch (notifier in AsyncLoading)
    final isFetching = ref.watch(
      usersNotifierProvider.select((s) => s.isLoading),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Night'),
        actions: [
          TextButton.icon(
            onPressed: () => context.push(RouteNames.matches),
            icon: const Icon(Icons.local_fire_department_rounded),
            label: const Text('Matches'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(RouteNames.addUser),
        icon: const Icon(Icons.person_add_rounded),
        label: const Text('Add User'),
      ),
      body: Column(
        children: [
          const ReconnectingBar(),
          Expanded(
            child: usersAsync.when(
              // DB stream hasn't emitted yet at all — extremely brief
              loading: () => const UserListShimmer(),
              error: (e, _) => EmptyState(message: e.toString()),
              data: (users) {
                // Show shimmer while first network fetch is in flight
                // and the DB is still empty (no cached data yet)
                if (isFetching && users.isEmpty) {
                  return const UserListShimmer();
                }
                if (users.isEmpty) {
                  return const EmptyState(
                    icon: Icons.people_outline_rounded,
                    title: 'No users yet',
                    subtitle: 'Add a user to get started.',
                  );
                }
                return NotificationListener<ScrollNotification>(
                  onNotification: (n) {
                    if (n.metrics.maxScrollExtent > 0 &&
                        n.metrics.pixels >=
                            n.metrics.maxScrollExtent - 200) {
                      ref.read(usersNotifierProvider.notifier).loadMore();
                    }
                    return false;
                  },
                  child: RefreshIndicator(
                    onRefresh: () =>
                        ref.read(usersNotifierProvider.notifier).refresh(),
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100),
                      physics: const BouncingScrollPhysics(),
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final item = users[index];
                        // animate only plays once per item key — no re-animation on scroll
                        return UserListTile(
                          key: ValueKey(item.user.id),
                          item: item,
                          onTap: () => context.push(
                            RouteNames.movies(item.user.id),
                          ),
                        )
                            .animate(
                              key: ValueKey('anim_${item.user.id}'),
                              delay: Duration(milliseconds: (index % 20) * 50),
                            )
                            .fadeIn(duration: 300.ms)
                            .slideX(begin: 0.05);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
