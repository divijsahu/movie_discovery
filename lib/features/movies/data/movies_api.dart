import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_discovery/core/network/api_constants.dart';
import 'package:movie_discovery/core/network/dio_client.dart';
import 'package:movie_discovery/features/movies/data/models/movie_model.dart';

class MoviesApi {
  final Dio _dio;
  MoviesApi(this._dio);

  Future<MoviesPageResponse> fetchTrending(int page) async {
    final response = await _dio.get(
      ApiConstants.trendingMovies,
      queryParameters: {'language': 'en-US', 'page': page},
    );
    return MoviesPageResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<MovieModel> fetchDetail(int tmdbId) async {
    final response = await _dio.get(ApiConstants.movieDetail(tmdbId));
    return MovieModel.fromJson(response.data as Map<String, dynamic>);
  }
}

final moviesApiProvider = Provider<MoviesApi>(
  (ref) => MoviesApi(ref.watch(tmdbDioProvider)),
);
