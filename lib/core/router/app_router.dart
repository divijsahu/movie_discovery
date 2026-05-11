import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_discovery/core/router/route_names.dart';
import 'package:movie_discovery/features/add_user/ui/add_user_page.dart';
import 'package:movie_discovery/features/matches/ui/matches_page.dart';
import 'package:movie_discovery/features/movie_detail/ui/movie_detail_page.dart';
import 'package:movie_discovery/features/movies/ui/movies_page.dart';
import 'package:movie_discovery/features/saved_movies/ui/saved_movies_page.dart';
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
      GoRoute(
        path: RouteNames.matches,
        builder: (_, __) => const MatchesPage(),
      ),
      GoRoute(
        path: '/users/:userId/movies',
        builder: (_, state) {
          final userId = int.parse(state.pathParameters['userId']!);
          return MoviesPage(userId: userId);
        },
      ),
      GoRoute(
        path: '/users/:userId/saved',
        builder: (_, state) {
          final userId = int.parse(state.pathParameters['userId']!);
          return SavedMoviesPage(userId: userId);
        },
      ),
      GoRoute(
        path: '/movies/:tmdbId',
        builder: (_, state) {
          final tmdbId = int.parse(state.pathParameters['tmdbId']!);
          final userId = int.parse(state.uri.queryParameters['userId'] ?? '0');
          return MovieDetailPage(tmdbId: tmdbId, activeUserId: userId);
        },
      ),
    ],
  );
});
