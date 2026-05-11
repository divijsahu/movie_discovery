class ApiConstants {
  static const reqresBase = 'https://reqres.in/api';
  static const reqresApiKey = 'free_user_3DX5WtZgAM0j2EtH7YRbDHXMRoF';

  static const tmdbBase = 'https://api.themoviedb.org/3';
  static const tmdbApiKey = '2f72fc8ecb8781ca5b0daf124601ec90';
  static const tmdbImageSmall = 'https://image.tmdb.org/t/p/w185';
  static const tmdbImageLarge = 'https://image.tmdb.org/t/p/w500';

  static const omdbBase = 'https://www.omdbapi.com';
  static const omdbApiKey = 'e6f47c9';

  static const users = '/users';
  static const trendingMovies = '/trending/movie/day';
  static String movieDetail(int id) => '/movie/$id';

  ApiConstants._();
}
