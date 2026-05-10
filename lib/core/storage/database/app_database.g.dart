// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTableTable extends UsersTable
    with TableInfo<$UsersTableTable, UsersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _serverIdMeta =
      const VerificationMeta('serverId');
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
      'server_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _movieTasteMeta =
      const VerificationMeta('movieTaste');
  @override
  late final GeneratedColumn<String> movieTaste = GeneratedColumn<String>(
      'movie_taste', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _avatarUrlMeta =
      const VerificationMeta('avatarUrl');
  @override
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>(
      'avatar_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pendingSyncMeta =
      const VerificationMeta('pendingSync');
  @override
  late final GeneratedColumn<bool> pendingSync = GeneratedColumn<bool>(
      'pending_sync', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("pending_sync" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        serverId,
        name,
        movieTaste,
        email,
        avatarUrl,
        pendingSync,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users_table';
  @override
  VerificationContext validateIntegrity(Insertable<UsersTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('server_id')) {
      context.handle(_serverIdMeta,
          serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('movie_taste')) {
      context.handle(
          _movieTasteMeta,
          movieTaste.isAcceptableOrUnknown(
              data['movie_taste']!, _movieTasteMeta));
    } else if (isInserting) {
      context.missing(_movieTasteMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('avatar_url')) {
      context.handle(_avatarUrlMeta,
          avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta));
    }
    if (data.containsKey('pending_sync')) {
      context.handle(
          _pendingSyncMeta,
          pendingSync.isAcceptableOrUnknown(
              data['pending_sync']!, _pendingSyncMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UsersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsersTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      serverId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}server_id']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      movieTaste: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}movie_taste'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      avatarUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar_url']),
      pendingSync: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}pending_sync'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $UsersTableTable createAlias(String alias) {
    return $UsersTableTable(attachedDatabase, alias);
  }
}

class UsersTableData extends DataClass implements Insertable<UsersTableData> {
  final int id;
  final String? serverId;
  final String name;
  final String movieTaste;
  final String? email;
  final String? avatarUrl;
  final bool pendingSync;
  final DateTime createdAt;
  const UsersTableData(
      {required this.id,
      this.serverId,
      required this.name,
      required this.movieTaste,
      this.email,
      this.avatarUrl,
      required this.pendingSync,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    map['name'] = Variable<String>(name);
    map['movie_taste'] = Variable<String>(movieTaste);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(avatarUrl);
    }
    map['pending_sync'] = Variable<bool>(pendingSync);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UsersTableCompanion toCompanion(bool nullToAbsent) {
    return UsersTableCompanion(
      id: Value(id),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      name: Value(name),
      movieTaste: Value(movieTaste),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      avatarUrl: avatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarUrl),
      pendingSync: Value(pendingSync),
      createdAt: Value(createdAt),
    );
  }

  factory UsersTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsersTableData(
      id: serializer.fromJson<int>(json['id']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      name: serializer.fromJson<String>(json['name']),
      movieTaste: serializer.fromJson<String>(json['movieTaste']),
      email: serializer.fromJson<String?>(json['email']),
      avatarUrl: serializer.fromJson<String?>(json['avatarUrl']),
      pendingSync: serializer.fromJson<bool>(json['pendingSync']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'serverId': serializer.toJson<String?>(serverId),
      'name': serializer.toJson<String>(name),
      'movieTaste': serializer.toJson<String>(movieTaste),
      'email': serializer.toJson<String?>(email),
      'avatarUrl': serializer.toJson<String?>(avatarUrl),
      'pendingSync': serializer.toJson<bool>(pendingSync),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  UsersTableData copyWith(
          {int? id,
          Value<String?> serverId = const Value.absent(),
          String? name,
          String? movieTaste,
          Value<String?> email = const Value.absent(),
          Value<String?> avatarUrl = const Value.absent(),
          bool? pendingSync,
          DateTime? createdAt}) =>
      UsersTableData(
        id: id ?? this.id,
        serverId: serverId.present ? serverId.value : this.serverId,
        name: name ?? this.name,
        movieTaste: movieTaste ?? this.movieTaste,
        email: email.present ? email.value : this.email,
        avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
        pendingSync: pendingSync ?? this.pendingSync,
        createdAt: createdAt ?? this.createdAt,
      );
  UsersTableData copyWithCompanion(UsersTableCompanion data) {
    return UsersTableData(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      name: data.name.present ? data.name.value : this.name,
      movieTaste:
          data.movieTaste.present ? data.movieTaste.value : this.movieTaste,
      email: data.email.present ? data.email.value : this.email,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      pendingSync:
          data.pendingSync.present ? data.pendingSync.value : this.pendingSync,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsersTableData(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('name: $name, ')
          ..write('movieTaste: $movieTaste, ')
          ..write('email: $email, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('pendingSync: $pendingSync, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, serverId, name, movieTaste, email, avatarUrl, pendingSync, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsersTableData &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.name == this.name &&
          other.movieTaste == this.movieTaste &&
          other.email == this.email &&
          other.avatarUrl == this.avatarUrl &&
          other.pendingSync == this.pendingSync &&
          other.createdAt == this.createdAt);
}

class UsersTableCompanion extends UpdateCompanion<UsersTableData> {
  final Value<int> id;
  final Value<String?> serverId;
  final Value<String> name;
  final Value<String> movieTaste;
  final Value<String?> email;
  final Value<String?> avatarUrl;
  final Value<bool> pendingSync;
  final Value<DateTime> createdAt;
  const UsersTableCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.name = const Value.absent(),
    this.movieTaste = const Value.absent(),
    this.email = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.pendingSync = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  UsersTableCompanion.insert({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    required String name,
    required String movieTaste,
    this.email = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.pendingSync = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : name = Value(name),
        movieTaste = Value(movieTaste);
  static Insertable<UsersTableData> custom({
    Expression<int>? id,
    Expression<String>? serverId,
    Expression<String>? name,
    Expression<String>? movieTaste,
    Expression<String>? email,
    Expression<String>? avatarUrl,
    Expression<bool>? pendingSync,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (name != null) 'name': name,
      if (movieTaste != null) 'movie_taste': movieTaste,
      if (email != null) 'email': email,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (pendingSync != null) 'pending_sync': pendingSync,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  UsersTableCompanion copyWith(
      {Value<int>? id,
      Value<String?>? serverId,
      Value<String>? name,
      Value<String>? movieTaste,
      Value<String?>? email,
      Value<String?>? avatarUrl,
      Value<bool>? pendingSync,
      Value<DateTime>? createdAt}) {
    return UsersTableCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      name: name ?? this.name,
      movieTaste: movieTaste ?? this.movieTaste,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      pendingSync: pendingSync ?? this.pendingSync,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (movieTaste.present) {
      map['movie_taste'] = Variable<String>(movieTaste.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (pendingSync.present) {
      map['pending_sync'] = Variable<bool>(pendingSync.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersTableCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('name: $name, ')
          ..write('movieTaste: $movieTaste, ')
          ..write('email: $email, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('pendingSync: $pendingSync, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $MoviesTableTable extends MoviesTable
    with TableInfo<$MoviesTableTable, MoviesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MoviesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _tmdbIdMeta = const VerificationMeta('tmdbId');
  @override
  late final GeneratedColumn<int> tmdbId = GeneratedColumn<int>(
      'tmdb_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _overviewMeta =
      const VerificationMeta('overview');
  @override
  late final GeneratedColumn<String> overview = GeneratedColumn<String>(
      'overview', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _posterPathMeta =
      const VerificationMeta('posterPath');
  @override
  late final GeneratedColumn<String> posterPath = GeneratedColumn<String>(
      'poster_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _releaseDateMeta =
      const VerificationMeta('releaseDate');
  @override
  late final GeneratedColumn<String> releaseDate = GeneratedColumn<String>(
      'release_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _popularityMeta =
      const VerificationMeta('popularity');
  @override
  late final GeneratedColumn<double> popularity = GeneratedColumn<double>(
      'popularity', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, tmdbId, title, overview, posterPath, releaseDate, popularity];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'movies_table';
  @override
  VerificationContext validateIntegrity(Insertable<MoviesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tmdb_id')) {
      context.handle(_tmdbIdMeta,
          tmdbId.isAcceptableOrUnknown(data['tmdb_id']!, _tmdbIdMeta));
    } else if (isInserting) {
      context.missing(_tmdbIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('overview')) {
      context.handle(_overviewMeta,
          overview.isAcceptableOrUnknown(data['overview']!, _overviewMeta));
    }
    if (data.containsKey('poster_path')) {
      context.handle(
          _posterPathMeta,
          posterPath.isAcceptableOrUnknown(
              data['poster_path']!, _posterPathMeta));
    }
    if (data.containsKey('release_date')) {
      context.handle(
          _releaseDateMeta,
          releaseDate.isAcceptableOrUnknown(
              data['release_date']!, _releaseDateMeta));
    }
    if (data.containsKey('popularity')) {
      context.handle(
          _popularityMeta,
          popularity.isAcceptableOrUnknown(
              data['popularity']!, _popularityMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MoviesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MoviesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      tmdbId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tmdb_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      overview: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}overview']),
      posterPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}poster_path']),
      releaseDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}release_date']),
      popularity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}popularity']),
    );
  }

  @override
  $MoviesTableTable createAlias(String alias) {
    return $MoviesTableTable(attachedDatabase, alias);
  }
}

class MoviesTableData extends DataClass implements Insertable<MoviesTableData> {
  final int id;
  final int tmdbId;
  final String title;
  final String? overview;
  final String? posterPath;
  final String? releaseDate;
  final double? popularity;
  const MoviesTableData(
      {required this.id,
      required this.tmdbId,
      required this.title,
      this.overview,
      this.posterPath,
      this.releaseDate,
      this.popularity});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tmdb_id'] = Variable<int>(tmdbId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || overview != null) {
      map['overview'] = Variable<String>(overview);
    }
    if (!nullToAbsent || posterPath != null) {
      map['poster_path'] = Variable<String>(posterPath);
    }
    if (!nullToAbsent || releaseDate != null) {
      map['release_date'] = Variable<String>(releaseDate);
    }
    if (!nullToAbsent || popularity != null) {
      map['popularity'] = Variable<double>(popularity);
    }
    return map;
  }

  MoviesTableCompanion toCompanion(bool nullToAbsent) {
    return MoviesTableCompanion(
      id: Value(id),
      tmdbId: Value(tmdbId),
      title: Value(title),
      overview: overview == null && nullToAbsent
          ? const Value.absent()
          : Value(overview),
      posterPath: posterPath == null && nullToAbsent
          ? const Value.absent()
          : Value(posterPath),
      releaseDate: releaseDate == null && nullToAbsent
          ? const Value.absent()
          : Value(releaseDate),
      popularity: popularity == null && nullToAbsent
          ? const Value.absent()
          : Value(popularity),
    );
  }

  factory MoviesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MoviesTableData(
      id: serializer.fromJson<int>(json['id']),
      tmdbId: serializer.fromJson<int>(json['tmdbId']),
      title: serializer.fromJson<String>(json['title']),
      overview: serializer.fromJson<String?>(json['overview']),
      posterPath: serializer.fromJson<String?>(json['posterPath']),
      releaseDate: serializer.fromJson<String?>(json['releaseDate']),
      popularity: serializer.fromJson<double?>(json['popularity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tmdbId': serializer.toJson<int>(tmdbId),
      'title': serializer.toJson<String>(title),
      'overview': serializer.toJson<String?>(overview),
      'posterPath': serializer.toJson<String?>(posterPath),
      'releaseDate': serializer.toJson<String?>(releaseDate),
      'popularity': serializer.toJson<double?>(popularity),
    };
  }

  MoviesTableData copyWith(
          {int? id,
          int? tmdbId,
          String? title,
          Value<String?> overview = const Value.absent(),
          Value<String?> posterPath = const Value.absent(),
          Value<String?> releaseDate = const Value.absent(),
          Value<double?> popularity = const Value.absent()}) =>
      MoviesTableData(
        id: id ?? this.id,
        tmdbId: tmdbId ?? this.tmdbId,
        title: title ?? this.title,
        overview: overview.present ? overview.value : this.overview,
        posterPath: posterPath.present ? posterPath.value : this.posterPath,
        releaseDate: releaseDate.present ? releaseDate.value : this.releaseDate,
        popularity: popularity.present ? popularity.value : this.popularity,
      );
  MoviesTableData copyWithCompanion(MoviesTableCompanion data) {
    return MoviesTableData(
      id: data.id.present ? data.id.value : this.id,
      tmdbId: data.tmdbId.present ? data.tmdbId.value : this.tmdbId,
      title: data.title.present ? data.title.value : this.title,
      overview: data.overview.present ? data.overview.value : this.overview,
      posterPath:
          data.posterPath.present ? data.posterPath.value : this.posterPath,
      releaseDate:
          data.releaseDate.present ? data.releaseDate.value : this.releaseDate,
      popularity:
          data.popularity.present ? data.popularity.value : this.popularity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MoviesTableData(')
          ..write('id: $id, ')
          ..write('tmdbId: $tmdbId, ')
          ..write('title: $title, ')
          ..write('overview: $overview, ')
          ..write('posterPath: $posterPath, ')
          ..write('releaseDate: $releaseDate, ')
          ..write('popularity: $popularity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, tmdbId, title, overview, posterPath, releaseDate, popularity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MoviesTableData &&
          other.id == this.id &&
          other.tmdbId == this.tmdbId &&
          other.title == this.title &&
          other.overview == this.overview &&
          other.posterPath == this.posterPath &&
          other.releaseDate == this.releaseDate &&
          other.popularity == this.popularity);
}

class MoviesTableCompanion extends UpdateCompanion<MoviesTableData> {
  final Value<int> id;
  final Value<int> tmdbId;
  final Value<String> title;
  final Value<String?> overview;
  final Value<String?> posterPath;
  final Value<String?> releaseDate;
  final Value<double?> popularity;
  const MoviesTableCompanion({
    this.id = const Value.absent(),
    this.tmdbId = const Value.absent(),
    this.title = const Value.absent(),
    this.overview = const Value.absent(),
    this.posterPath = const Value.absent(),
    this.releaseDate = const Value.absent(),
    this.popularity = const Value.absent(),
  });
  MoviesTableCompanion.insert({
    this.id = const Value.absent(),
    required int tmdbId,
    required String title,
    this.overview = const Value.absent(),
    this.posterPath = const Value.absent(),
    this.releaseDate = const Value.absent(),
    this.popularity = const Value.absent(),
  })  : tmdbId = Value(tmdbId),
        title = Value(title);
  static Insertable<MoviesTableData> custom({
    Expression<int>? id,
    Expression<int>? tmdbId,
    Expression<String>? title,
    Expression<String>? overview,
    Expression<String>? posterPath,
    Expression<String>? releaseDate,
    Expression<double>? popularity,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tmdbId != null) 'tmdb_id': tmdbId,
      if (title != null) 'title': title,
      if (overview != null) 'overview': overview,
      if (posterPath != null) 'poster_path': posterPath,
      if (releaseDate != null) 'release_date': releaseDate,
      if (popularity != null) 'popularity': popularity,
    });
  }

  MoviesTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? tmdbId,
      Value<String>? title,
      Value<String?>? overview,
      Value<String?>? posterPath,
      Value<String?>? releaseDate,
      Value<double?>? popularity}) {
    return MoviesTableCompanion(
      id: id ?? this.id,
      tmdbId: tmdbId ?? this.tmdbId,
      title: title ?? this.title,
      overview: overview ?? this.overview,
      posterPath: posterPath ?? this.posterPath,
      releaseDate: releaseDate ?? this.releaseDate,
      popularity: popularity ?? this.popularity,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tmdbId.present) {
      map['tmdb_id'] = Variable<int>(tmdbId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (overview.present) {
      map['overview'] = Variable<String>(overview.value);
    }
    if (posterPath.present) {
      map['poster_path'] = Variable<String>(posterPath.value);
    }
    if (releaseDate.present) {
      map['release_date'] = Variable<String>(releaseDate.value);
    }
    if (popularity.present) {
      map['popularity'] = Variable<double>(popularity.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MoviesTableCompanion(')
          ..write('id: $id, ')
          ..write('tmdbId: $tmdbId, ')
          ..write('title: $title, ')
          ..write('overview: $overview, ')
          ..write('posterPath: $posterPath, ')
          ..write('releaseDate: $releaseDate, ')
          ..write('popularity: $popularity')
          ..write(')'))
        .toString();
  }
}

class $SavedMoviesTableTable extends SavedMoviesTable
    with TableInfo<$SavedMoviesTableTable, SavedMoviesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavedMoviesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users_table (id)'));
  static const VerificationMeta _movieIdMeta =
      const VerificationMeta('movieId');
  @override
  late final GeneratedColumn<int> movieId = GeneratedColumn<int>(
      'movie_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES movies_table (id)'));
  static const VerificationMeta _savedAtMeta =
      const VerificationMeta('savedAt');
  @override
  late final GeneratedColumn<DateTime> savedAt = GeneratedColumn<DateTime>(
      'saved_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, userId, movieId, savedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saved_movies_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<SavedMoviesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('movie_id')) {
      context.handle(_movieIdMeta,
          movieId.isAcceptableOrUnknown(data['movie_id']!, _movieIdMeta));
    } else if (isInserting) {
      context.missing(_movieIdMeta);
    }
    if (data.containsKey('saved_at')) {
      context.handle(_savedAtMeta,
          savedAt.isAcceptableOrUnknown(data['saved_at']!, _savedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {userId, movieId},
      ];
  @override
  SavedMoviesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavedMoviesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      movieId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}movie_id'])!,
      savedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}saved_at'])!,
    );
  }

  @override
  $SavedMoviesTableTable createAlias(String alias) {
    return $SavedMoviesTableTable(attachedDatabase, alias);
  }
}

class SavedMoviesTableData extends DataClass
    implements Insertable<SavedMoviesTableData> {
  final int id;
  final int userId;
  final int movieId;
  final DateTime savedAt;
  const SavedMoviesTableData(
      {required this.id,
      required this.userId,
      required this.movieId,
      required this.savedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['movie_id'] = Variable<int>(movieId);
    map['saved_at'] = Variable<DateTime>(savedAt);
    return map;
  }

  SavedMoviesTableCompanion toCompanion(bool nullToAbsent) {
    return SavedMoviesTableCompanion(
      id: Value(id),
      userId: Value(userId),
      movieId: Value(movieId),
      savedAt: Value(savedAt),
    );
  }

  factory SavedMoviesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavedMoviesTableData(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      movieId: serializer.fromJson<int>(json['movieId']),
      savedAt: serializer.fromJson<DateTime>(json['savedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'movieId': serializer.toJson<int>(movieId),
      'savedAt': serializer.toJson<DateTime>(savedAt),
    };
  }

  SavedMoviesTableData copyWith(
          {int? id, int? userId, int? movieId, DateTime? savedAt}) =>
      SavedMoviesTableData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        movieId: movieId ?? this.movieId,
        savedAt: savedAt ?? this.savedAt,
      );
  SavedMoviesTableData copyWithCompanion(SavedMoviesTableCompanion data) {
    return SavedMoviesTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      movieId: data.movieId.present ? data.movieId.value : this.movieId,
      savedAt: data.savedAt.present ? data.savedAt.value : this.savedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavedMoviesTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('movieId: $movieId, ')
          ..write('savedAt: $savedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, movieId, savedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavedMoviesTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.movieId == this.movieId &&
          other.savedAt == this.savedAt);
}

class SavedMoviesTableCompanion extends UpdateCompanion<SavedMoviesTableData> {
  final Value<int> id;
  final Value<int> userId;
  final Value<int> movieId;
  final Value<DateTime> savedAt;
  const SavedMoviesTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.movieId = const Value.absent(),
    this.savedAt = const Value.absent(),
  });
  SavedMoviesTableCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required int movieId,
    this.savedAt = const Value.absent(),
  })  : userId = Value(userId),
        movieId = Value(movieId);
  static Insertable<SavedMoviesTableData> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<int>? movieId,
    Expression<DateTime>? savedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (movieId != null) 'movie_id': movieId,
      if (savedAt != null) 'saved_at': savedAt,
    });
  }

  SavedMoviesTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? userId,
      Value<int>? movieId,
      Value<DateTime>? savedAt}) {
    return SavedMoviesTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      movieId: movieId ?? this.movieId,
      savedAt: savedAt ?? this.savedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (movieId.present) {
      map['movie_id'] = Variable<int>(movieId.value);
    }
    if (savedAt.present) {
      map['saved_at'] = Variable<DateTime>(savedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedMoviesTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('movieId: $movieId, ')
          ..write('savedAt: $savedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTableTable usersTable = $UsersTableTable(this);
  late final $MoviesTableTable moviesTable = $MoviesTableTable(this);
  late final $SavedMoviesTableTable savedMoviesTable =
      $SavedMoviesTableTable(this);
  late final UsersDao usersDao = UsersDao(this as AppDatabase);
  late final MoviesDao moviesDao = MoviesDao(this as AppDatabase);
  late final SavedMoviesDao savedMoviesDao =
      SavedMoviesDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [usersTable, moviesTable, savedMoviesTable];
}

typedef $$UsersTableTableCreateCompanionBuilder = UsersTableCompanion Function({
  Value<int> id,
  Value<String?> serverId,
  required String name,
  required String movieTaste,
  Value<String?> email,
  Value<String?> avatarUrl,
  Value<bool> pendingSync,
  Value<DateTime> createdAt,
});
typedef $$UsersTableTableUpdateCompanionBuilder = UsersTableCompanion Function({
  Value<int> id,
  Value<String?> serverId,
  Value<String> name,
  Value<String> movieTaste,
  Value<String?> email,
  Value<String?> avatarUrl,
  Value<bool> pendingSync,
  Value<DateTime> createdAt,
});

final class $$UsersTableTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTableTable, UsersTableData> {
  $$UsersTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SavedMoviesTableTable, List<SavedMoviesTableData>>
      _savedMoviesTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.savedMoviesTable,
              aliasName: $_aliasNameGenerator(
                  db.usersTable.id, db.savedMoviesTable.userId));

  $$SavedMoviesTableTableProcessedTableManager get savedMoviesTableRefs {
    final manager =
        $$SavedMoviesTableTableTableManager($_db, $_db.savedMoviesTable)
            .filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_savedMoviesTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$UsersTableTableFilterComposer
    extends Composer<_$AppDatabase, $UsersTableTable> {
  $$UsersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get serverId => $composableBuilder(
      column: $table.serverId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get movieTaste => $composableBuilder(
      column: $table.movieTaste, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avatarUrl => $composableBuilder(
      column: $table.avatarUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get pendingSync => $composableBuilder(
      column: $table.pendingSync, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> savedMoviesTableRefs(
      Expression<bool> Function($$SavedMoviesTableTableFilterComposer f) f) {
    final $$SavedMoviesTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.savedMoviesTable,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SavedMoviesTableTableFilterComposer(
              $db: $db,
              $table: $db.savedMoviesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UsersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTableTable> {
  $$UsersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get serverId => $composableBuilder(
      column: $table.serverId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get movieTaste => $composableBuilder(
      column: $table.movieTaste, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
      column: $table.avatarUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get pendingSync => $composableBuilder(
      column: $table.pendingSync, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$UsersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTableTable> {
  $$UsersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get movieTaste => $composableBuilder(
      column: $table.movieTaste, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);

  GeneratedColumn<bool> get pendingSync => $composableBuilder(
      column: $table.pendingSync, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> savedMoviesTableRefs<T extends Object>(
      Expression<T> Function($$SavedMoviesTableTableAnnotationComposer a) f) {
    final $$SavedMoviesTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.savedMoviesTable,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SavedMoviesTableTableAnnotationComposer(
              $db: $db,
              $table: $db.savedMoviesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UsersTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTableTable,
    UsersTableData,
    $$UsersTableTableFilterComposer,
    $$UsersTableTableOrderingComposer,
    $$UsersTableTableAnnotationComposer,
    $$UsersTableTableCreateCompanionBuilder,
    $$UsersTableTableUpdateCompanionBuilder,
    (UsersTableData, $$UsersTableTableReferences),
    UsersTableData,
    PrefetchHooks Function({bool savedMoviesTableRefs})> {
  $$UsersTableTableTableManager(_$AppDatabase db, $UsersTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> serverId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> movieTaste = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> avatarUrl = const Value.absent(),
            Value<bool> pendingSync = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              UsersTableCompanion(
            id: id,
            serverId: serverId,
            name: name,
            movieTaste: movieTaste,
            email: email,
            avatarUrl: avatarUrl,
            pendingSync: pendingSync,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> serverId = const Value.absent(),
            required String name,
            required String movieTaste,
            Value<String?> email = const Value.absent(),
            Value<String?> avatarUrl = const Value.absent(),
            Value<bool> pendingSync = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              UsersTableCompanion.insert(
            id: id,
            serverId: serverId,
            name: name,
            movieTaste: movieTaste,
            email: email,
            avatarUrl: avatarUrl,
            pendingSync: pendingSync,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$UsersTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({savedMoviesTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (savedMoviesTableRefs) db.savedMoviesTable
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (savedMoviesTableRefs)
                    await $_getPrefetchedData<UsersTableData, $UsersTableTable,
                            SavedMoviesTableData>(
                        currentTable: table,
                        referencedTable: $$UsersTableTableReferences
                            ._savedMoviesTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableTableReferences(db, table, p0)
                                .savedMoviesTableRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$UsersTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTableTable,
    UsersTableData,
    $$UsersTableTableFilterComposer,
    $$UsersTableTableOrderingComposer,
    $$UsersTableTableAnnotationComposer,
    $$UsersTableTableCreateCompanionBuilder,
    $$UsersTableTableUpdateCompanionBuilder,
    (UsersTableData, $$UsersTableTableReferences),
    UsersTableData,
    PrefetchHooks Function({bool savedMoviesTableRefs})>;
typedef $$MoviesTableTableCreateCompanionBuilder = MoviesTableCompanion
    Function({
  Value<int> id,
  required int tmdbId,
  required String title,
  Value<String?> overview,
  Value<String?> posterPath,
  Value<String?> releaseDate,
  Value<double?> popularity,
});
typedef $$MoviesTableTableUpdateCompanionBuilder = MoviesTableCompanion
    Function({
  Value<int> id,
  Value<int> tmdbId,
  Value<String> title,
  Value<String?> overview,
  Value<String?> posterPath,
  Value<String?> releaseDate,
  Value<double?> popularity,
});

final class $$MoviesTableTableReferences
    extends BaseReferences<_$AppDatabase, $MoviesTableTable, MoviesTableData> {
  $$MoviesTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SavedMoviesTableTable, List<SavedMoviesTableData>>
      _savedMoviesTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.savedMoviesTable,
              aliasName: $_aliasNameGenerator(
                  db.moviesTable.id, db.savedMoviesTable.movieId));

  $$SavedMoviesTableTableProcessedTableManager get savedMoviesTableRefs {
    final manager =
        $$SavedMoviesTableTableTableManager($_db, $_db.savedMoviesTable)
            .filter((f) => f.movieId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_savedMoviesTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MoviesTableTableFilterComposer
    extends Composer<_$AppDatabase, $MoviesTableTable> {
  $$MoviesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tmdbId => $composableBuilder(
      column: $table.tmdbId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get overview => $composableBuilder(
      column: $table.overview, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get posterPath => $composableBuilder(
      column: $table.posterPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get releaseDate => $composableBuilder(
      column: $table.releaseDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get popularity => $composableBuilder(
      column: $table.popularity, builder: (column) => ColumnFilters(column));

  Expression<bool> savedMoviesTableRefs(
      Expression<bool> Function($$SavedMoviesTableTableFilterComposer f) f) {
    final $$SavedMoviesTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.savedMoviesTable,
        getReferencedColumn: (t) => t.movieId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SavedMoviesTableTableFilterComposer(
              $db: $db,
              $table: $db.savedMoviesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MoviesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MoviesTableTable> {
  $$MoviesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tmdbId => $composableBuilder(
      column: $table.tmdbId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get overview => $composableBuilder(
      column: $table.overview, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get posterPath => $composableBuilder(
      column: $table.posterPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get releaseDate => $composableBuilder(
      column: $table.releaseDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get popularity => $composableBuilder(
      column: $table.popularity, builder: (column) => ColumnOrderings(column));
}

class $$MoviesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MoviesTableTable> {
  $$MoviesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get tmdbId =>
      $composableBuilder(column: $table.tmdbId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get overview =>
      $composableBuilder(column: $table.overview, builder: (column) => column);

  GeneratedColumn<String> get posterPath => $composableBuilder(
      column: $table.posterPath, builder: (column) => column);

  GeneratedColumn<String> get releaseDate => $composableBuilder(
      column: $table.releaseDate, builder: (column) => column);

  GeneratedColumn<double> get popularity => $composableBuilder(
      column: $table.popularity, builder: (column) => column);

  Expression<T> savedMoviesTableRefs<T extends Object>(
      Expression<T> Function($$SavedMoviesTableTableAnnotationComposer a) f) {
    final $$SavedMoviesTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.savedMoviesTable,
        getReferencedColumn: (t) => t.movieId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SavedMoviesTableTableAnnotationComposer(
              $db: $db,
              $table: $db.savedMoviesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MoviesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MoviesTableTable,
    MoviesTableData,
    $$MoviesTableTableFilterComposer,
    $$MoviesTableTableOrderingComposer,
    $$MoviesTableTableAnnotationComposer,
    $$MoviesTableTableCreateCompanionBuilder,
    $$MoviesTableTableUpdateCompanionBuilder,
    (MoviesTableData, $$MoviesTableTableReferences),
    MoviesTableData,
    PrefetchHooks Function({bool savedMoviesTableRefs})> {
  $$MoviesTableTableTableManager(_$AppDatabase db, $MoviesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MoviesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MoviesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MoviesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> tmdbId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> overview = const Value.absent(),
            Value<String?> posterPath = const Value.absent(),
            Value<String?> releaseDate = const Value.absent(),
            Value<double?> popularity = const Value.absent(),
          }) =>
              MoviesTableCompanion(
            id: id,
            tmdbId: tmdbId,
            title: title,
            overview: overview,
            posterPath: posterPath,
            releaseDate: releaseDate,
            popularity: popularity,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int tmdbId,
            required String title,
            Value<String?> overview = const Value.absent(),
            Value<String?> posterPath = const Value.absent(),
            Value<String?> releaseDate = const Value.absent(),
            Value<double?> popularity = const Value.absent(),
          }) =>
              MoviesTableCompanion.insert(
            id: id,
            tmdbId: tmdbId,
            title: title,
            overview: overview,
            posterPath: posterPath,
            releaseDate: releaseDate,
            popularity: popularity,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MoviesTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({savedMoviesTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (savedMoviesTableRefs) db.savedMoviesTable
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (savedMoviesTableRefs)
                    await $_getPrefetchedData<MoviesTableData,
                            $MoviesTableTable, SavedMoviesTableData>(
                        currentTable: table,
                        referencedTable: $$MoviesTableTableReferences
                            ._savedMoviesTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MoviesTableTableReferences(db, table, p0)
                                .savedMoviesTableRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.movieId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$MoviesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MoviesTableTable,
    MoviesTableData,
    $$MoviesTableTableFilterComposer,
    $$MoviesTableTableOrderingComposer,
    $$MoviesTableTableAnnotationComposer,
    $$MoviesTableTableCreateCompanionBuilder,
    $$MoviesTableTableUpdateCompanionBuilder,
    (MoviesTableData, $$MoviesTableTableReferences),
    MoviesTableData,
    PrefetchHooks Function({bool savedMoviesTableRefs})>;
typedef $$SavedMoviesTableTableCreateCompanionBuilder
    = SavedMoviesTableCompanion Function({
  Value<int> id,
  required int userId,
  required int movieId,
  Value<DateTime> savedAt,
});
typedef $$SavedMoviesTableTableUpdateCompanionBuilder
    = SavedMoviesTableCompanion Function({
  Value<int> id,
  Value<int> userId,
  Value<int> movieId,
  Value<DateTime> savedAt,
});

final class $$SavedMoviesTableTableReferences extends BaseReferences<
    _$AppDatabase, $SavedMoviesTableTable, SavedMoviesTableData> {
  $$SavedMoviesTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $UsersTableTable _userIdTable(_$AppDatabase db) =>
      db.usersTable.createAlias(
          $_aliasNameGenerator(db.savedMoviesTable.userId, db.usersTable.id));

  $$UsersTableTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableTableManager($_db, $_db.usersTable)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $MoviesTableTable _movieIdTable(_$AppDatabase db) =>
      db.moviesTable.createAlias(
          $_aliasNameGenerator(db.savedMoviesTable.movieId, db.moviesTable.id));

  $$MoviesTableTableProcessedTableManager get movieId {
    final $_column = $_itemColumn<int>('movie_id')!;

    final manager = $$MoviesTableTableTableManager($_db, $_db.moviesTable)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_movieIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SavedMoviesTableTableFilterComposer
    extends Composer<_$AppDatabase, $SavedMoviesTableTable> {
  $$SavedMoviesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get savedAt => $composableBuilder(
      column: $table.savedAt, builder: (column) => ColumnFilters(column));

  $$UsersTableTableFilterComposer get userId {
    final $$UsersTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.usersTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableTableFilterComposer(
              $db: $db,
              $table: $db.usersTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MoviesTableTableFilterComposer get movieId {
    final $$MoviesTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.movieId,
        referencedTable: $db.moviesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MoviesTableTableFilterComposer(
              $db: $db,
              $table: $db.moviesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SavedMoviesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SavedMoviesTableTable> {
  $$SavedMoviesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get savedAt => $composableBuilder(
      column: $table.savedAt, builder: (column) => ColumnOrderings(column));

  $$UsersTableTableOrderingComposer get userId {
    final $$UsersTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.usersTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableTableOrderingComposer(
              $db: $db,
              $table: $db.usersTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MoviesTableTableOrderingComposer get movieId {
    final $$MoviesTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.movieId,
        referencedTable: $db.moviesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MoviesTableTableOrderingComposer(
              $db: $db,
              $table: $db.moviesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SavedMoviesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavedMoviesTableTable> {
  $$SavedMoviesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get savedAt =>
      $composableBuilder(column: $table.savedAt, builder: (column) => column);

  $$UsersTableTableAnnotationComposer get userId {
    final $$UsersTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.usersTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableTableAnnotationComposer(
              $db: $db,
              $table: $db.usersTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MoviesTableTableAnnotationComposer get movieId {
    final $$MoviesTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.movieId,
        referencedTable: $db.moviesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MoviesTableTableAnnotationComposer(
              $db: $db,
              $table: $db.moviesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SavedMoviesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SavedMoviesTableTable,
    SavedMoviesTableData,
    $$SavedMoviesTableTableFilterComposer,
    $$SavedMoviesTableTableOrderingComposer,
    $$SavedMoviesTableTableAnnotationComposer,
    $$SavedMoviesTableTableCreateCompanionBuilder,
    $$SavedMoviesTableTableUpdateCompanionBuilder,
    (SavedMoviesTableData, $$SavedMoviesTableTableReferences),
    SavedMoviesTableData,
    PrefetchHooks Function({bool userId, bool movieId})> {
  $$SavedMoviesTableTableTableManager(
      _$AppDatabase db, $SavedMoviesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavedMoviesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavedMoviesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavedMoviesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<int> movieId = const Value.absent(),
            Value<DateTime> savedAt = const Value.absent(),
          }) =>
              SavedMoviesTableCompanion(
            id: id,
            userId: userId,
            movieId: movieId,
            savedAt: savedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int userId,
            required int movieId,
            Value<DateTime> savedAt = const Value.absent(),
          }) =>
              SavedMoviesTableCompanion.insert(
            id: id,
            userId: userId,
            movieId: movieId,
            savedAt: savedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SavedMoviesTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({userId = false, movieId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$SavedMoviesTableTableReferences._userIdTable(db),
                    referencedColumn:
                        $$SavedMoviesTableTableReferences._userIdTable(db).id,
                  ) as T;
                }
                if (movieId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.movieId,
                    referencedTable:
                        $$SavedMoviesTableTableReferences._movieIdTable(db),
                    referencedColumn:
                        $$SavedMoviesTableTableReferences._movieIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SavedMoviesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SavedMoviesTableTable,
    SavedMoviesTableData,
    $$SavedMoviesTableTableFilterComposer,
    $$SavedMoviesTableTableOrderingComposer,
    $$SavedMoviesTableTableAnnotationComposer,
    $$SavedMoviesTableTableCreateCompanionBuilder,
    $$SavedMoviesTableTableUpdateCompanionBuilder,
    (SavedMoviesTableData, $$SavedMoviesTableTableReferences),
    SavedMoviesTableData,
    PrefetchHooks Function({bool userId, bool movieId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableTableManager get usersTable =>
      $$UsersTableTableTableManager(_db, _db.usersTable);
  $$MoviesTableTableTableManager get moviesTable =>
      $$MoviesTableTableTableManager(_db, _db.moviesTable);
  $$SavedMoviesTableTableTableManager get savedMoviesTable =>
      $$SavedMoviesTableTableTableManager(_db, _db.savedMoviesTable);
}

mixin _$UsersDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTableTable get usersTable => attachedDatabase.usersTable;
  $MoviesTableTable get moviesTable => attachedDatabase.moviesTable;
  $SavedMoviesTableTable get savedMoviesTable =>
      attachedDatabase.savedMoviesTable;
}
mixin _$MoviesDaoMixin on DatabaseAccessor<AppDatabase> {
  $MoviesTableTable get moviesTable => attachedDatabase.moviesTable;
}
mixin _$SavedMoviesDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTableTable get usersTable => attachedDatabase.usersTable;
  $MoviesTableTable get moviesTable => attachedDatabase.moviesTable;
  $SavedMoviesTableTable get savedMoviesTable =>
      attachedDatabase.savedMoviesTable;
}
