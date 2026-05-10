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

    // Kick off initial fetch
    ref.watch(usersNotifierProvider);

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
              loading: () => const UserListShimmer(),
              error: (e, _) => EmptyState(message: e.toString()),
              data: (users) {
                if (users.isEmpty) {
                  return const EmptyState(
                    icon: Icons.people_outline_rounded,
                    title: 'No users yet',
                    subtitle: 'Add a user to get started.',
                  );
                }
                return NotificationListener<ScrollNotification>(
                  onNotification: (n) {
                    if (n.metrics.pixels >= n.metrics.maxScrollExtent - 200) {
                      ref.read(usersNotifierProvider.notifier).loadMore();
                    }
                    return false;
                  },
                  child: RefreshIndicator(
                    onRefresh: () =>
                        ref.read(usersNotifierProvider.notifier).refresh(),
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100),
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final item = users[index];
                        return UserListTile(
                          item: item,
                          onTap: () => context.push(
                            RouteNames.movies(item.user.id),
                          ),
                        )
                            .animate(
                              delay: Duration(milliseconds: index * 50),
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
