class ApiConstants {
  static const reqresBase     = 'https://reqres.in/api';
  static const reqresApiKey   = 'YOUR_REQRES_KEY';

  static const tmdbBase       = 'https://api.themoviedb.org/3';
  static const tmdbApiKey     = 'YOUR_TMDB_KEY';
  static const tmdbImageSmall = 'https://image.tmdb.org/t/p/w185';
  static const tmdbImageLarge = 'https://image.tmdb.org/t/p/w500';

  static const users          = '/users';
  static const trendingMovies = '/trending/movie/day';
  static String movieDetail(int id) => '/movie/$id';

  ApiConstants._();
}
