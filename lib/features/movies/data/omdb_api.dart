import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_discovery/core/network/dio_client.dart';
import 'package:movie_discovery/features/movies/data/models/movie_model.dart';

// ignore_for_file: avoid_print, curly_braces_in_flow_control_structures

// Curated search terms rotated by page to simulate a trending list.
// OMDB returns up to 10 results per search; we pick one term per page.
const _searchTerms = [
  'avengers',
  'batman',
  'spider',
  'star wars',
  'jurassic',
  'mission impossible',
  'fast furious',
  'inception',
  'interstellar',
  'dark knight',
  'iron man',
  'thor',
  'captain america',
  'guardians',
  'matrix',
  'john wick',
  'mad max',
  'alien',
  'terminator',
  'predator',
];

class OmdbApi {
  final Dio _dio;
  OmdbApi(this._dio);

  /// Fetches a page of movies by cycling through search terms.
  /// Returns up to 10 results mapped to [MovieModel].
  Future<List<MovieModel>> fetchPopular(int page) async {
    final term = _searchTerms[(page - 1) % _searchTerms.length];
    final response = await _dio.get('/', queryParameters: {
      's': term,
      'type': 'movie',
      'page': 1,
    });

    final data = response.data as Map<String, dynamic>;
    if (data['Response'] == 'False') return [];

    final results = (data['Search'] as List).cast<Map<String, dynamic>>();

    // OMDB search only returns imdbID + poster — we need a detail call for each
    // to get overview. Fetch details for first 5 to keep it fast.
    final movies = <MovieModel>[];
    for (final item in results.take(5)) {
      try {
        final detail = await _fetchDetail(item['imdbID'] as String);
        if (detail != null) movies.add(detail);
      } catch (e) {
        if (kDebugMode)
          print('⚠️  [OMDB] detail fetch failed for ${item['imdbID']}: $e');
      }
    }
    return movies;
  }

  Future<MovieModel?> _fetchDetail(String imdbId) async {
    final response = await _dio.get('/', queryParameters: {
      'i': imdbId,
      'plot': 'short',
    });
    final data = response.data as Map<String, dynamic>;
    if (data['Response'] == 'False') return null;
    return _mapToMovieModel(data);
  }

  Future<MovieModel?> fetchDetailByImdbId(String imdbId) =>
      _fetchDetail(imdbId);

  static MovieModel _mapToMovieModel(Map<String, dynamic> data) {
    final imdbId = data['imdbID'] as String? ?? '';
    // Use hashCode of the full imdbID string as a stable, collision-free int
    // Avoids overlap with TMDB numeric IDs which can be small integers
    final id = imdbId.isNotEmpty ? imdbId.hashCode.abs() : data.hashCode.abs();
    final poster = data['Poster'] as String?;

    return MovieModel(
      id: id,
      title: data['Title'] as String? ?? '',
      overview: data['Plot'] as String?,
      posterPath: (poster != null && poster != 'N/A') ? poster : null,
      releaseDate: data['Year'] as String?,
      popularity: double.tryParse(
            (data['imdbRating'] as String?)?.replaceAll('N/A', '') ?? '',
          ) ??
          0.0,
    );
  }
}

final omdbApiProvider = Provider<OmdbApi>(
  (ref) => OmdbApi(ref.watch(omdbDioProvider)),
);
