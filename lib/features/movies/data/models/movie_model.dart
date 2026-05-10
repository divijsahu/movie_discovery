import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_model.freezed.dart';
part 'movie_model.g.dart';

// ignore_for_file: invalid_annotation_target

@freezed
class MovieModel with _$MovieModel {
  const factory MovieModel({
    required int id,
    required String title,
    String? overview,
    @JsonKey(name: 'poster_path') String? posterPath,
    @JsonKey(name: 'release_date') String? releaseDate,
    double? popularity,
  }) = _MovieModel;

  factory MovieModel.fromJson(Map<String, dynamic> json) =>
      _$MovieModelFromJson(json);
}

@freezed
class MoviesPageResponse with _$MoviesPageResponse {
  const factory MoviesPageResponse({
    required int page,
    @JsonKey(name: 'total_pages') required int totalPages,
    required List<MovieModel> results,
  }) = _MoviesPageResponse;

  factory MoviesPageResponse.fromJson(Map<String, dynamic> json) =>
      _$MoviesPageResponseFromJson(json);
}
