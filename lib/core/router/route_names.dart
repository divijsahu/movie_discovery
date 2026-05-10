class RouteNames {
  static const home = '/';
  static const addUser = '/add-user';
  static const matches = '/matches';
  static String movies(int userId) => '/users/$userId/movies';
  static String savedMovies(int userId) => '/users/$userId/saved';
  static String movieDetail(int tmdbId) => '/movies/$tmdbId';

  RouteNames._();
}
