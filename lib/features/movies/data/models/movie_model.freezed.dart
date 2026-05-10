// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movie_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MovieModel _$MovieModelFromJson(Map<String, dynamic> json) {
  return _MovieModel.fromJson(json);
}

/// @nodoc
mixin _$MovieModel {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get overview => throw _privateConstructorUsedError;
  @JsonKey(name: 'poster_path')
  String? get posterPath => throw _privateConstructorUsedError;
  @JsonKey(name: 'release_date')
  String? get releaseDate => throw _privateConstructorUsedError;
  double? get popularity => throw _privateConstructorUsedError;

  /// Serializes this MovieModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MovieModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MovieModelCopyWith<MovieModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MovieModelCopyWith<$Res> {
  factory $MovieModelCopyWith(
          MovieModel value, $Res Function(MovieModel) then) =
      _$MovieModelCopyWithImpl<$Res, MovieModel>;
  @useResult
  $Res call(
      {int id,
      String title,
      String? overview,
      @JsonKey(name: 'poster_path') String? posterPath,
      @JsonKey(name: 'release_date') String? releaseDate,
      double? popularity});
}

/// @nodoc
class _$MovieModelCopyWithImpl<$Res, $Val extends MovieModel>
    implements $MovieModelCopyWith<$Res> {
  _$MovieModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MovieModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? overview = freezed,
    Object? posterPath = freezed,
    Object? releaseDate = freezed,
    Object? popularity = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      overview: freezed == overview
          ? _value.overview
          : overview // ignore: cast_nullable_to_non_nullable
              as String?,
      posterPath: freezed == posterPath
          ? _value.posterPath
          : posterPath // ignore: cast_nullable_to_non_nullable
              as String?,
      releaseDate: freezed == releaseDate
          ? _value.releaseDate
          : releaseDate // ignore: cast_nullable_to_non_nullable
              as String?,
      popularity: freezed == popularity
          ? _value.popularity
          : popularity // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MovieModelImplCopyWith<$Res>
    implements $MovieModelCopyWith<$Res> {
  factory _$$MovieModelImplCopyWith(
          _$MovieModelImpl value, $Res Function(_$MovieModelImpl) then) =
      __$$MovieModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      String? overview,
      @JsonKey(name: 'poster_path') String? posterPath,
      @JsonKey(name: 'release_date') String? releaseDate,
      double? popularity});
}

/// @nodoc
class __$$MovieModelImplCopyWithImpl<$Res>
    extends _$MovieModelCopyWithImpl<$Res, _$MovieModelImpl>
    implements _$$MovieModelImplCopyWith<$Res> {
  __$$MovieModelImplCopyWithImpl(
      _$MovieModelImpl _value, $Res Function(_$MovieModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of MovieModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? overview = freezed,
    Object? posterPath = freezed,
    Object? releaseDate = freezed,
    Object? popularity = freezed,
  }) {
    return _then(_$MovieModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      overview: freezed == overview
          ? _value.overview
          : overview // ignore: cast_nullable_to_non_nullable
              as String?,
      posterPath: freezed == posterPath
          ? _value.posterPath
          : posterPath // ignore: cast_nullable_to_non_nullable
              as String?,
      releaseDate: freezed == releaseDate
          ? _value.releaseDate
          : releaseDate // ignore: cast_nullable_to_non_nullable
              as String?,
      popularity: freezed == popularity
          ? _value.popularity
          : popularity // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MovieModelImpl implements _MovieModel {
  const _$MovieModelImpl(
      {required this.id,
      required this.title,
      this.overview,
      @JsonKey(name: 'poster_path') this.posterPath,
      @JsonKey(name: 'release_date') this.releaseDate,
      this.popularity});

  factory _$MovieModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MovieModelImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String? overview;
  @override
  @JsonKey(name: 'poster_path')
  final String? posterPath;
  @override
  @JsonKey(name: 'release_date')
  final String? releaseDate;
  @override
  final double? popularity;

  @override
  String toString() {
    return 'MovieModel(id: $id, title: $title, overview: $overview, posterPath: $posterPath, releaseDate: $releaseDate, popularity: $popularity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MovieModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.overview, overview) ||
                other.overview == overview) &&
            (identical(other.posterPath, posterPath) ||
                other.posterPath == posterPath) &&
            (identical(other.releaseDate, releaseDate) ||
                other.releaseDate == releaseDate) &&
            (identical(other.popularity, popularity) ||
                other.popularity == popularity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, title, overview, posterPath, releaseDate, popularity);

  /// Create a copy of MovieModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MovieModelImplCopyWith<_$MovieModelImpl> get copyWith =>
      __$$MovieModelImplCopyWithImpl<_$MovieModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MovieModelImplToJson(
      this,
    );
  }
}

abstract class _MovieModel implements MovieModel {
  const factory _MovieModel(
      {required final int id,
      required final String title,
      final String? overview,
      @JsonKey(name: 'poster_path') final String? posterPath,
      @JsonKey(name: 'release_date') final String? releaseDate,
      final double? popularity}) = _$MovieModelImpl;

  factory _MovieModel.fromJson(Map<String, dynamic> json) =
      _$MovieModelImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String? get overview;
  @override
  @JsonKey(name: 'poster_path')
  String? get posterPath;
  @override
  @JsonKey(name: 'release_date')
  String? get releaseDate;
  @override
  double? get popularity;

  /// Create a copy of MovieModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MovieModelImplCopyWith<_$MovieModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MoviesPageResponse _$MoviesPageResponseFromJson(Map<String, dynamic> json) {
  return _MoviesPageResponse.fromJson(json);
}

/// @nodoc
mixin _$MoviesPageResponse {
  int get page => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_pages')
  int get totalPages => throw _privateConstructorUsedError;
  List<MovieModel> get results => throw _privateConstructorUsedError;

  /// Serializes this MoviesPageResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MoviesPageResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MoviesPageResponseCopyWith<MoviesPageResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MoviesPageResponseCopyWith<$Res> {
  factory $MoviesPageResponseCopyWith(
          MoviesPageResponse value, $Res Function(MoviesPageResponse) then) =
      _$MoviesPageResponseCopyWithImpl<$Res, MoviesPageResponse>;
  @useResult
  $Res call(
      {int page,
      @JsonKey(name: 'total_pages') int totalPages,
      List<MovieModel> results});
}

/// @nodoc
class _$MoviesPageResponseCopyWithImpl<$Res, $Val extends MoviesPageResponse>
    implements $MoviesPageResponseCopyWith<$Res> {
  _$MoviesPageResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MoviesPageResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? totalPages = null,
    Object? results = null,
  }) {
    return _then(_value.copyWith(
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      results: null == results
          ? _value.results
          : results // ignore: cast_nullable_to_non_nullable
              as List<MovieModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MoviesPageResponseImplCopyWith<$Res>
    implements $MoviesPageResponseCopyWith<$Res> {
  factory _$$MoviesPageResponseImplCopyWith(_$MoviesPageResponseImpl value,
          $Res Function(_$MoviesPageResponseImpl) then) =
      __$$MoviesPageResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int page,
      @JsonKey(name: 'total_pages') int totalPages,
      List<MovieModel> results});
}

/// @nodoc
class __$$MoviesPageResponseImplCopyWithImpl<$Res>
    extends _$MoviesPageResponseCopyWithImpl<$Res, _$MoviesPageResponseImpl>
    implements _$$MoviesPageResponseImplCopyWith<$Res> {
  __$$MoviesPageResponseImplCopyWithImpl(_$MoviesPageResponseImpl _value,
      $Res Function(_$MoviesPageResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of MoviesPageResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? totalPages = null,
    Object? results = null,
  }) {
    return _then(_$MoviesPageResponseImpl(
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      results: null == results
          ? _value._results
          : results // ignore: cast_nullable_to_non_nullable
              as List<MovieModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MoviesPageResponseImpl implements _MoviesPageResponse {
  const _$MoviesPageResponseImpl(
      {required this.page,
      @JsonKey(name: 'total_pages') required this.totalPages,
      required final List<MovieModel> results})
      : _results = results;

  factory _$MoviesPageResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$MoviesPageResponseImplFromJson(json);

  @override
  final int page;
  @override
  @JsonKey(name: 'total_pages')
  final int totalPages;
  final List<MovieModel> _results;
  @override
  List<MovieModel> get results {
    if (_results is EqualUnmodifiableListView) return _results;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_results);
  }

  @override
  String toString() {
    return 'MoviesPageResponse(page: $page, totalPages: $totalPages, results: $results)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MoviesPageResponseImpl &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            const DeepCollectionEquality().equals(other._results, _results));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, page, totalPages,
      const DeepCollectionEquality().hash(_results));

  /// Create a copy of MoviesPageResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MoviesPageResponseImplCopyWith<_$MoviesPageResponseImpl> get copyWith =>
      __$$MoviesPageResponseImplCopyWithImpl<_$MoviesPageResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MoviesPageResponseImplToJson(
      this,
    );
  }
}

abstract class _MoviesPageResponse implements MoviesPageResponse {
  const factory _MoviesPageResponse(
      {required final int page,
      @JsonKey(name: 'total_pages') required final int totalPages,
      required final List<MovieModel> results}) = _$MoviesPageResponseImpl;

  factory _MoviesPageResponse.fromJson(Map<String, dynamic> json) =
      _$MoviesPageResponseImpl.fromJson;

  @override
  int get page;
  @override
  @JsonKey(name: 'total_pages')
  int get totalPages;
  @override
  List<MovieModel> get results;

  /// Create a copy of MoviesPageResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MoviesPageResponseImplCopyWith<_$MoviesPageResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
