import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_discovery/core/router/route_names.dart';
import 'package:movie_discovery/features/add_user/ui/add_user_page.dart';
import 'package:movie_discovery/features/users/ui/users_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteNames.home,
    routes: [
      GoRoute(
        path: RouteNames.home,
        builder: (_, __) => const UsersPage(),
      ),
      GoRoute(
        path: RouteNames.addUser,
        builder: (_, __) => const AddUserPage(),
      ),
    ],
  );
});
