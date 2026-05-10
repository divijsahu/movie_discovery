# 🎬 Movie Discovery App — Complete Build Guide
### Platform Commons Engineering Assignment · 2026

> A phase-by-phase execution plan to build, polish, and submit a production-quality Flutter app that scores in the top tier across all rubric areas.

---

## 📋 Assignment Scoring Reminder

| Area | Weight | Your Target |
|---|---|---|
| All pages working correctly | 30% | ✅ Every page + full offline flow |
| UI quality | 20% | ✅ Animations, shimmer, smooth scroll |
| Code quality | 20% | ✅ Clean architecture, readable, named |
| Offline sync | 15% | ✅ Zero data loss, no duplicates |
| Bad connection handling | 10% | ✅ Silent retries, reconnect bar |
| AI prompting (if used) | 5% | ✅ This document = your prompt log |

---

## 🗺️ Build Phases Overview

| Phase | Focus | Est. Time |
|---|---|---|
| **Phase 1** | Project setup, architecture, folder structure | 1–2 hrs |
| **Phase 2** | Database schema + local repositories | 1.5 hrs |
| **Phase 3** | Networking layer (Dio, interceptors, retry) | 1 hr |
| **Phase 4** | Users Page + Add User form | 1.5 hrs |
| **Phase 5** | Movies Page + Movie Detail Page | 2 hrs |
| **Phase 6** | Saved Movies Page + Matches Page | 1.5 hrs |
| **Phase 7** | Offline sync with WorkManager | 1.5 hrs |
| **Phase 8** | UI polish — animations, shimmer, design system | 2 hrs |
| **Phase 9** | Bad connection simulation + retry bar | 1 hr |
| **Phase 10** | README, APK build, final review | 0.5 hr |

**Total: ~14 hours**

---

## Phase 1 — Project Setup & Architecture

### 1.1 Create the Project

```bash
flutter create --org com.platformcommons movie_discovery
cd movie_discovery
```

### 1.2 Folder Structure

Apply the **Medium App Architecture** to this project:

```
lib/
│
├── core/
│   ├── network/
│   │   ├── dio_client.dart
│   │   ├── api_constants.dart
│   │   └── interceptors/
│   │       ├── auth_interceptor.dart       # Adds API keys to headers
│   │       ├── retry_interceptor.dart      # Handles bad connection retries
│   │       └── logging_interceptor.dart
│   │
│   ├── storage/
│   │   ├── database/
│   │   │   ├── app_database.dart           # Drift DB definition
│   │   │   ├── app_database.g.dart         # Generated
│   │   │   └── daos/
│   │   │       ├── users_dao.dart
│   │   │       ├── movies_dao.dart
│   │   │       └── saved_movies_dao.dart
│   │   └── secure_storage.dart
│   │
│   ├── router/
│   │   ├── app_router.dart
│   │   └── route_names.dart
│   │
│   ├── error/
│   │   ├── failures.dart
│   │   └── result.dart
│   │
│   ├── sync/
│   │   └── sync_worker.dart                # WorkManager task
│   │
│   └── utils/
│       ├── validators.dart
│       ├── connectivity_service.dart
│       └── extensions/
│           ├── context_ext.dart
│           └── datetime_ext.dart
│
├── design_system/
│   ├── app_colors.dart
│   ├── app_text_styles.dart
│   ├── app_spacing.dart
│   ├── app_radius.dart
│   ├── app_theme.dart
│   └── widgets/
│       ├── buttons/
│       │   └── primary_button.dart
│       ├── shimmer/
│       │   ├── shimmer_box.dart
│       │   ├── user_card_shimmer.dart
│       │   └── movie_card_shimmer.dart
│       ├── app_card.dart
│       ├── app_network_image.dart          # CachedNetworkImage wrapper
│       ├── empty_state.dart
│       ├── reconnecting_bar.dart           # Slim top/bottom retry bar
│       └── save_count_badge.dart          # Animated badge
│
├── features/
│   ├── users/
│   │   ├── data/
│   │   │   ├── users_api.dart
│   │   │   ├── users_repository.dart
│   │   │   └── models/
│   │   │       └── user_model.dart
│   │   ├── logic/
│   │   │   ├── users_provider.dart
│   │   │   └── users_state.dart
│   │   └── ui/
│   │       ├── users_page.dart
│   │       └── widgets/
│   │           └── user_list_tile.dart
│   │
│   ├── add_user/
│   │   ├── data/
│   │   │   └── add_user_repository.dart
│   │   ├── logic/
│   │   │   ├── add_user_provider.dart
│   │   │   └── add_user_state.dart
│   │   └── ui/
│   │       └── add_user_page.dart
│   │
│   ├── movies/
│   │   ├── data/
│   │   │   ├── movies_api.dart
│   │   │   ├── movies_repository.dart
│   │   │   └── models/
│   │   │       └── movie_model.dart
│   │   ├── logic/
│   │   │   ├── movies_provider.dart
│   │   │   └── movies_state.dart
│   │   └── ui/
│   │       ├── movies_page.dart
│   │       └── widgets/
│   │           └── movie_card.dart
│   │
│   ├── movie_detail/
│   │   ├── data/
│   │   │   └── movie_detail_repository.dart
│   │   ├── logic/
│   │   │   ├── movie_detail_provider.dart
│   │   │   └── movie_detail_state.dart
│   │   └── ui/
│   │       └── movie_detail_page.dart
│   │
│   ├── saved_movies/
│   │   ├── logic/
│   │   │   └── saved_movies_provider.dart
│   │   └── ui/
│   │       └── saved_movies_page.dart
│   │
│   └── matches/
│       ├── logic/
│       │   └── matches_provider.dart
│       └── ui/
│           ├── matches_page.dart
│           └── widgets/
│               └── match_movie_tile.dart
│
├── shared/
│   └── widgets/
│       └── async_widget.dart
│
├── app.dart
└── main.dart
```

### 1.3 Install All Dependencies

```yaml
# pubspec.yaml

dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_riverpod: ^2.6.1
  riverpod_annotation: ^2.3.5

  # Routing
  go_router: ^14.2.7

  # Networking
  dio: ^5.7.0

  # Local Database
  drift: ^2.20.3
  drift_flutter: ^0.2.1
  sqlite3_flutter_libs: ^0.5.24

  # Background Sync
  workmanager: ^0.5.2

  # Connectivity
  connectivity_plus: ^6.0.3

  # Models
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0

  # Storage
  flutter_secure_storage: ^9.2.2

  # UI
  cached_network_image: ^3.4.1
  shimmer: ^3.0.0
  flutter_animate: ^4.5.0       # Easy staggered animations

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
  build_runner: ^2.4.13
  freezed: ^2.5.7
  json_serializable: ^6.8.0
  riverpod_generator: ^2.4.3
  go_router_builder: ^2.7.1
  drift_dev: ^2.20.3
  mocktail: ^1.0.4
```

### 1.4 API Constants

```dart
// core/network/api_constants.dart
class ApiConstants {
  // Reqres
  static const reqresBase      = 'https://reqres.in/api';
  static const reqresApiKey    = 'YOUR_REQRES_KEY';  // from reqres.in

  // TMDB
  static const tmdbBase        = 'https://api.themoviedb.org/3';
  static const tmdbApiKey      = 'YOUR_TMDB_KEY';
  static const tmdbImageSmall  = 'https://image.tmdb.org/t/p/w185';
  static const tmdbImageLarge  = 'https://image.tmdb.org/t/p/w500';

  // Endpoints
  static const users           = '/users';
  static const trendingMovies  = '/trending/movie/day';
  static String movieDetail(int id) => '/movie/$id';
}
```

---

## Phase 2 — Database Schema (Drift)

This is the foundation of everything — get it right before writing any UI.

### 2.1 Table Definitions

```dart
// core/storage/database/app_database.dart
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

// ─── Tables ───────────────────────────────────────────────

class UsersTable extends Table {
  IntColumn    get id          => integer().autoIncrement()();
  TextColumn   get serverId    => text().nullable()();   // null until synced
  TextColumn   get name        => text()();
  TextColumn   get movieTaste  => text()();              // "job" field
  TextColumn   get email       => text().nullable()();
  TextColumn   get avatarUrl   => text().nullable()();
  BoolColumn   get pendingSync => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class MoviesTable extends Table {
  IntColumn  get id          => integer().autoIncrement()();
  IntColumn  get tmdbId      => integer().unique()();
  TextColumn get title       => text()();
  TextColumn get overview    => text().nullable()();
  TextColumn get posterPath  => text().nullable()();
  TextColumn get releaseDate => text().nullable()();
  RealColumn get popularity  => real().nullable()();
}

class SavedMoviesTable extends Table {
  IntColumn    get id        => integer().autoIncrement()();
  IntColumn    get userId    => integer().references(UsersTable, #id)();
  IntColumn    get movieId   => integer().references(MoviesTable, #id)();
  DateTimeColumn get savedAt => dateTime().withDefault(currentDateAndTime)();

  // Unique constraint — no duplicate saves
  @override
  List<Set<Column>> get uniqueKeys => [
    {userId, movieId}
  ];
}

// ─── Database ─────────────────────────────────────────────

@DriftDatabase(
  tables: [UsersTable, MoviesTable, SavedMoviesTable],
  daos: [UsersDao, MoviesDao, SavedMoviesDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'movie_discovery_db');
  }
}
```

### 2.2 Users DAO

```dart
// core/storage/database/daos/users_dao.dart
part of '../app_database.dart';

@DriftAccessor(tables: [UsersTable, SavedMoviesTable])
class UsersDao extends DatabaseAccessor<AppDatabase> with _$UsersDaoMixin {
  UsersDao(super.db);

  // All users with their saved movie count
  Stream<List<UserWithSaveCount>> watchAllUsersWithCount() {
    final count = savedMoviesTable.id.count();
    final query = (select(usersTable)
          ..orderBy([(u) => OrderingTerm.desc(u.createdAt)]))
        .join([
          leftOuterJoin(
            savedMoviesTable,
            savedMoviesTable.userId.equalsExp(usersTable.id),
          )
        ])
      ..addColumns([count])
      ..groupBy([usersTable.id]);

    return query.watch().map((rows) => rows.map((row) {
          return UserWithSaveCount(
            user: row.readTable(usersTable),
            saveCount: row.read(count) ?? 0,
          );
        }).toList());
  }

  Future<int> insertUser(UsersTableCompanion user) =>
      into(usersTable).insert(user);

  Future<void> updateServerId(int localId, String serverId) =>
      (update(usersTable)..where((u) => u.id.equals(localId)))
          .write(UsersTableCompanion(serverId: Value(serverId)));

  Future<void> markSynced(int localId) =>
      (update(usersTable)..where((u) => u.id.equals(localId)))
          .write(const UsersTableCompanion(pendingSync: Value(false)));

  Future<List<UsersTableData>> getPendingSyncUsers() =>
      (select(usersTable)..where((u) => u.pendingSync.equals(true))).get();

  // Insert remote users (from Reqres API) — skip if serverId already exists
  Future<void> upsertRemoteUser(UsersTableCompanion user) =>
      into(usersTable).insertOnConflictUpdate(user);
}

class UserWithSaveCount {
  final UsersTableData user;
  final int saveCount;
  UserWithSaveCount({required this.user, required this.saveCount});
}
```

### 2.3 Movies DAO

```dart
// core/storage/database/daos/movies_dao.dart
part of '../app_database.dart';

@DriftAccessor(tables: [MoviesTable])
class MoviesDao extends DatabaseAccessor<AppDatabase> with _$MoviesDaoMixin {
  MoviesDao(super.db);

  Future<int> upsertMovie(MoviesTableCompanion movie) =>
      into(moviesTable).insertOnConflictUpdate(movie);

  Future<MoviesTableData?> getMovieByTmdbId(int tmdbId) =>
      (select(moviesTable)..where((m) => m.tmdbId.equals(tmdbId)))
          .getSingleOrNull();

  Future<List<MoviesTableData>> getMoviesByIds(List<int> ids) =>
      (select(moviesTable)..where((m) => m.id.isIn(ids))).get();
}
```

### 2.4 Saved Movies DAO

```dart
// core/storage/database/daos/saved_movies_dao.dart
part of '../app_database.dart';

@DriftAccessor(tables: [SavedMoviesTable, MoviesTable, UsersTable])
class SavedMoviesDao extends DatabaseAccessor<AppDatabase>
    with _$SavedMoviesDaoMixin {
  SavedMoviesDao(super.db);

  // Watch movies saved by a specific user
  Stream<List<MoviesTableData>> watchSavedMoviesForUser(int userId) {
    final query = select(moviesTable).join([
      innerJoin(
        savedMoviesTable,
        savedMoviesTable.movieId.equalsExp(moviesTable.id) &
            savedMoviesTable.userId.equals(userId),
      )
    ]);
    return query.watch().map((rows) => rows.map((r) => r.readTable(moviesTable)).toList());
  }

  // Watch save count for a movie (for badge)
  Stream<int> watchSaveCountForMovie(int movieLocalId) {
    final count = savedMoviesTable.id.count();
    final query = selectOnly(savedMoviesTable)
      ..addColumns([count])
      ..where(savedMoviesTable.movieId.equals(movieLocalId));
    return query.watchSingle().map((row) => row.read(count) ?? 0);
  }

  // Watch all movies saved by 2+ users (Matches page)
  Stream<List<MovieWithSavers>> watchMatches() {
    final saverCount = savedMoviesTable.userId.count();
    final query = select(moviesTable).join([
      innerJoin(
        savedMoviesTable,
        savedMoviesTable.movieId.equalsExp(moviesTable.id),
      )
    ])
      ..addColumns([saverCount])
      ..groupBy([moviesTable.id])
      ..having(saverCount.isBiggerThanValue(1))
      ..orderBy([OrderingTerm.desc(saverCount)]);

    return query.watch().map((rows) => rows.map((row) {
          return MovieWithSavers(
            movie: row.readTable(moviesTable),
            saverCount: row.read(saverCount) ?? 0,
          );
        }).toList());
  }

  // Who saved this movie? (for detail page profile pics)
  Future<List<UsersTableData>> getUsersWhoSavedMovie(int movieLocalId) {
    final query = select(usersTable).join([
      innerJoin(
        savedMoviesTable,
        savedMoviesTable.userId.equalsExp(usersTable.id) &
            savedMoviesTable.movieId.equals(movieLocalId),
      )
    ]);
    return query.map((row) => row.readTable(usersTable)).get();
  }

  Future<bool> isMovieSavedByUser(int userId, int movieLocalId) async {
    final result = await (select(savedMoviesTable)
          ..where(
            (s) =>
                s.userId.equals(userId) & s.movieId.equals(movieLocalId),
          ))
        .getSingleOrNull();
    return result != null;
  }

  Future<void> saveMovie(int userId, int movieLocalId) =>
      into(savedMoviesTable).insert(
        SavedMoviesTableCompanion.insert(userId: userId, movieId: movieLocalId),
        mode: InsertMode.insertOrIgnore, // prevents duplicate saves
      );

  Future<void> unsaveMovie(int userId, int movieLocalId) =>
      (delete(savedMoviesTable)
            ..where(
              (s) =>
                  s.userId.equals(userId) & s.movieId.equals(movieLocalId),
            ))
          .go();
}

class MovieWithSavers {
  final MoviesTableData movie;
  final int saverCount;
  MovieWithSavers({required this.movie, required this.saverCount});
}
```

### 2.5 Run Code Generation

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## Phase 3 — Networking Layer

### 3.1 Retry Interceptor (Bad Connection Handler)

```dart
// core/network/interceptors/retry_interceptor.dart
class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final List<Duration> retryDelays;

  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.retryDelays = const [
      Duration(seconds: 1),
      Duration(seconds: 3),
      Duration(seconds: 6),
    ],
  });

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final attempt = err.requestOptions.extra['retryAttempt'] as int? ?? 0;

    final shouldRetry = _isRetryable(err) && attempt < maxRetries;

    if (!shouldRetry) {
      handler.next(err);
      return;
    }

    final delay = attempt < retryDelays.length
        ? retryDelays[attempt]
        : retryDelays.last;

    await Future.delayed(delay);

    final options = err.requestOptions;
    options.extra['retryAttempt'] = attempt + 1;

    try {
      final response = await dio.fetch(options);
      handler.resolve(response);
    } catch (e) {
      handler.next(err);
    }
  }

  bool _isRetryable(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.response?.statusCode != null &&
            err.response!.statusCode! >= 500);
  }
}
```

### 3.2 Reqres Auth Interceptor

```dart
// core/network/interceptors/auth_interceptor.dart
class ReqresAuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['x-api-key'] = ApiConstants.reqresApiKey;
    handler.next(options);
  }
}
```

### 3.3 Dio Clients (Two Instances — Reqres + TMDB)

```dart
// core/network/dio_client.dart

@Riverpod(keepAlive: true)
Dio reqresDio(Ref ref) {
  final dio = Dio(BaseOptions(
    baseUrl: ApiConstants.reqresBase,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
  ));
  final retryDio = Dio(BaseOptions(baseUrl: ApiConstants.reqresBase));
  dio.interceptors.addAll([
    ReqresAuthInterceptor(),
    RetryInterceptor(dio: retryDio),
    if (kDebugMode) LogInterceptor(responseBody: true),
  ]);
  return dio;
}

@Riverpod(keepAlive: true)
Dio tmdbDio(Ref ref) {
  final dio = Dio(BaseOptions(
    baseUrl: ApiConstants.tmdbBase,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
    queryParameters: {'api_key': ApiConstants.tmdbApiKey},
  ));
  final retryDio = Dio(BaseOptions(baseUrl: ApiConstants.tmdbBase));
  dio.interceptors.addAll([
    RetryInterceptor(dio: retryDio),
    if (kDebugMode) LogInterceptor(responseBody: true),
  ]);
  return dio;
}
```

### 3.4 Connectivity Service

```dart
// core/utils/connectivity_service.dart
@Riverpod(keepAlive: true)
Stream<bool> connectivityStream(Ref ref) {
  return Connectivity()
      .onConnectivityChanged
      .map((results) => results.any((r) => r != ConnectivityResult.none));
}

@riverpod
Future<bool> isOnline(Ref ref) async {
  final results = await Connectivity().checkConnectivity();
  return results.any((r) => r != ConnectivityResult.none);
}
```

---

## Phase 4 — Users Page & Add User

### 4.1 User Model

```dart
// features/users/data/models/user_model.dart
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required int id,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    required String email,
    required String avatar,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

@freezed
class UsersResponse with _$UsersResponse {
  const factory UsersResponse({
    required int page,
    @JsonKey(name: 'total_pages') required int totalPages,
    required List<UserModel> data,
  }) = _UsersResponse;

  factory UsersResponse.fromJson(Map<String, dynamic> json) =>
      _$UsersResponseFromJson(json);
}
```

### 4.2 Users API

```dart
// features/users/data/users_api.dart
class UsersApi {
  final Dio _dio;
  UsersApi(this._dio);

  Future<UsersResponse> fetchUsers(int page) async {
    final response = await _dio.get(
      ApiConstants.users,
      queryParameters: {'page': page},
    );
    return UsersResponse.fromJson(response.data);
  }

  Future<Map<String, dynamic>> createUser(String name, String job) async {
    final response = await _dio.post(
      ApiConstants.users,
      data: {'name': name, 'job': job},
    );
    return response.data as Map<String, dynamic>;
  }
}
```

### 4.3 Users Repository

```dart
// features/users/data/users_repository.dart
class UsersRepository {
  final UsersApi _api;
  final AppDatabase _db;
  UsersRepository(this._api, this._db);

  // Stream from DB — always up to date
  Stream<List<UserWithSaveCount>> watchUsers() =>
      _db.usersDao.watchAllUsersWithCount();

  // Fetch page from API and upsert to local DB
  Future<Result<UsersResponse>> fetchAndCachePage(int page) async {
    try {
      final response = await _api.fetchUsers(page);
      for (final user in response.data) {
        await _db.usersDao.upsertRemoteUser(UsersTableCompanion.insert(
          serverId: Value(user.id.toString()),
          name: '${user.firstName} ${user.lastName}',
          movieTaste: Value(null),
          email: Value(user.email),
          avatarUrl: Value(user.avatar),
        ));
      }
      return Success(response);
    } on DioException catch (e) {
      return Failure(AppFailure.fromDio(e));
    }
  }
}
```

### 4.4 Users Provider (Infinite Scroll)

```dart
// features/users/logic/users_provider.dart
@riverpod
class UsersNotifier extends _$UsersNotifier {
  static const _firstPage = 1;
  int _currentPage = _firstPage;
  int _totalPages = 1;
  bool _isFetchingMore = false;

  @override
  FutureOr<void> build() async {
    await _loadPage(_firstPage);
  }

  // Watch local DB for real-time user list
  Stream<List<UserWithSaveCount>> get usersStream =>
      ref.watch(userRepositoryProvider).watchUsers();

  Future<void> _loadPage(int page) async {
    await ref.read(userRepositoryProvider).fetchAndCachePage(page);
  }

  Future<void> loadMore() async {
    if (_isFetchingMore || _currentPage >= _totalPages) return;
    _isFetchingMore = true;
    _currentPage++;
    await _loadPage(_currentPage);
    _isFetchingMore = false;
  }

  Future<void> refresh() async {
    _currentPage = _firstPage;
    ref.invalidateSelf();
  }
}
```

### 4.5 Users Page UI

```dart
// features/users/ui/users_page.dart
class UsersPage extends ConsumerWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetchState = ref.watch(usersNotifierProvider);
    final usersAsync = ref.watch(
      StreamProvider((ref) => ref.watch(userRepositoryProvider).watchUsers()),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Night'),
        actions: [
          TextButton.icon(
            onPressed: () => context.push(RouteNames.matches),
            icon: const Icon(Icons.local_fire_department_rounded),
            label: const Text('Matches'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(RouteNames.addUser),
        icon: const Icon(Icons.person_add_rounded),
        label: const Text('Add User'),
      ),
      body: Column(
        children: [
          // Reconnecting bar (shown during retry)
          const ReconnectingBar(),

          Expanded(
            child: usersAsync.when(
              loading: () => const UserListShimmer(),
              error: (e, _) => EmptyState(message: e.toString()),
              data: (users) => NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification.metrics.pixels >=
                      notification.metrics.maxScrollExtent - 200) {
                    ref.read(usersNotifierProvider.notifier).loadMore();
                  }
                  return false;
                },
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: users.length,
                  itemBuilder: (context, index) => UserListTile(
                    item: users[index],
                    // Staggered fade in
                  ).animate(delay: Duration(milliseconds: index * 50))
                      .fadeIn(duration: 300.ms)
                      .slideX(begin: 0.05),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

### 4.6 Add User Form

```dart
// features/add_user/ui/add_user_page.dart
class AddUserPage extends ConsumerStatefulWidget {
  const AddUserPage({super.key});

  @override
  ConsumerState<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends ConsumerState<AddUserPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _tasteCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _tasteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addUserNotifierProvider);

    ref.listen(addUserNotifierProvider, (_, next) {
      next.whenOrNull(
        data: (_) {
          context.showSnackbar('User added!');
          context.pop();
        },
        error: (e, _) => context.showSnackbar(e.toString(), isError: true),
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text('New User')),
      body: Padding(
        padding: AppSpacing.screen,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                label: 'Name',
                hint: 'Alex',
                controller: _nameCtrl,
                validator: (v) => Validators.required(v, 'Name'),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Movie Taste',
                hint: 'loves horror, no sad endings...',
                controller: _tasteCtrl,
                validator: (v) => Validators.required(v, 'Movie taste'),
              ),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                label: 'Add User',
                isLoading: state.isLoading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(addUserNotifierProvider.notifier).addUser(
            name: _nameCtrl.text.trim(),
            movieTaste: _tasteCtrl.text.trim(),
          );
    }
  }
}
```

### 4.7 Add User Logic — Online/Offline Handling

```dart
// features/add_user/logic/add_user_provider.dart
@riverpod
class AddUserNotifier extends _$AddUserNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> addUser({
    required String name,
    required String movieTaste,
  }) async {
    state = const AsyncLoading();

    final isOnline = await ref.read(isOnlineProvider.future);

    // 1. Always save locally first
    final localId = await ref.read(appDatabaseProvider).usersDao.insertUser(
          UsersTableCompanion.insert(
            name: name,
            movieTaste: movieTaste,
            pendingSync: Value(!isOnline), // mark pending if offline
          ),
        );

    if (isOnline) {
      // 2a. Online — POST immediately
      try {
        final api = ref.read(usersApiProvider);
        final response = await api.createUser(name, movieTaste);
        final serverId = response['id']?.toString();
        if (serverId != null) {
          await ref
              .read(appDatabaseProvider)
              .usersDao
              .updateServerId(localId, serverId);
        }
      } catch (_) {
        // Mark for background sync if POST fails
        await ref.read(appDatabaseProvider).usersDao
            ..insertUser(UsersTableCompanion.insert(
              name: name,
              movieTaste: movieTaste,
              pendingSync: const Value(true),
            ));
      }
    } else {
      // 2b. Offline — schedule WorkManager sync
      await Workmanager().registerOneOffTask(
        'sync_pending_users_$localId',
        SyncWorker.taskName,
        constraints: Constraints(networkType: NetworkType.connected),
        existingWorkPolicy: ExistingWorkPolicy.keep,
      );
    }

    state = const AsyncData(null);
  }
}
```

---

## Phase 5 — Movies Page & Movie Detail

### 5.1 Movie Model

```dart
// features/movies/data/models/movie_model.dart
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
```

### 5.2 Movies Repository

```dart
// features/movies/data/movies_repository.dart
class MoviesRepository {
  final Dio _dio;
  final AppDatabase _db;
  MoviesRepository(this._dio, this._db);

  Future<Result<List<MovieModel>>> fetchTrending(int page) async {
    try {
      final response = await _dio.get(
        ApiConstants.trendingMovies,
        queryParameters: {'language': 'en-US', 'page': page},
      );
      final parsed = MoviesPageResponse.fromJson(response.data);

      // Cache to local DB for offline use
      for (final movie in parsed.results) {
        await _db.moviesDao.upsertMovie(MoviesTableCompanion.insert(
          tmdbId: movie.id,
          title: movie.title,
          overview: Value(movie.overview),
          posterPath: Value(movie.posterPath),
          releaseDate: Value(movie.releaseDate),
          popularity: Value(movie.popularity),
        ));
      }

      return Success(parsed.results);
    } on DioException catch (e) {
      return Failure(AppFailure.fromDio(e));
    }
  }

  Future<void> toggleSave(int userId, int tmdbId) async {
    final movie = await _db.moviesDao.getMovieByTmdbId(tmdbId);
    if (movie == null) return;

    final isSaved = await _db.savedMoviesDao.isMovieSavedByUser(
      userId,
      movie.id,
    );

    if (isSaved) {
      await _db.savedMoviesDao.unsaveMovie(userId, movie.id);
    } else {
      await _db.savedMoviesDao.saveMovie(userId, movie.id);
    }
  }

  Stream<int> watchSaveCount(int tmdbId) async* {
    final movie = await _db.moviesDao.getMovieByTmdbId(tmdbId);
    if (movie == null) {
      yield 0;
      return;
    }
    yield* _db.savedMoviesDao.watchSaveCountForMovie(movie.id);
  }
}
```

### 5.3 Movie Card with Animated Badge

```dart
// features/movies/ui/widgets/movie_card.dart
class MovieCard extends ConsumerWidget {
  final MovieModel movie;
  final int activeUserId;

  const MovieCard({
    super.key,
    required this.movie,
    required this.activeUserId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saveCountAsync = ref.watch(
      StreamProvider((ref) =>
          ref.watch(moviesRepositoryProvider).watchSaveCount(movie.id)),
    );
    final isSavedAsync = ref.watch(isSavedProvider(activeUserId, movie.id));

    return AppCard(
      onTap: () => context.push(RouteNames.movieDetail(movie.id)),
      child: Row(
        children: [
          // Hero animation wraps the poster
          Hero(
            tag: 'movie_poster_${movie.id}',
            child: AppNetworkImage(
              url: '${ApiConstants.tmdbImageSmall}${movie.posterPath}',
              width: 70,
              height: 100,
              borderRadius: AppRadius.smAll,
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(movie.title, style: AppTextStyles.h3, maxLines: 2),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  movie.releaseDate?.substring(0, 4) ?? '',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.grey500,
                  ),
                ),
              ],
            ),
          ),

          Column(
            children: [
              // Animated save count badge
              saveCountAsync.when(
                data: (count) => SaveCountBadge(count: count),
                loading: () => const SizedBox.square(dimension: 28),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Save button
              isSavedAsync.when(
                data: (isSaved) => IconButton(
                  onPressed: () => ref
                      .read(moviesRepositoryProvider)
                      .toggleSave(activeUserId, movie.id),
                  icon: Icon(
                    isSaved
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    color: isSaved ? AppColors.primary : AppColors.grey500,
                  ),
                ),
                loading: () => const SizedBox.square(
                  dimension: 40,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

### 5.4 Animated Save Count Badge

```dart
// design_system/widgets/save_count_badge.dart
class SaveCountBadge extends StatelessWidget {
  final int count;
  const SaveCountBadge({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) => ScaleTransition(
        scale: animation,
        child: child,
      ),
      child: Container(
        key: ValueKey(count),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: count > 0 ? AppColors.primary : AppColors.grey200,
          borderRadius: AppRadius.smAll,
        ),
        child: Text(
          '$count',
          style: AppTextStyles.caption.copyWith(
            color: count > 0 ? Colors.white : AppColors.grey500,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
```

### 5.5 Movie Detail Page

```dart
// features/movie_detail/ui/movie_detail_page.dart
class MovieDetailPage extends ConsumerWidget {
  final int tmdbId;
  const MovieDetailPage({super.key, required this.tmdbId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(movieDetailProvider(tmdbId));
    final activeUser = ref.watch(activeUserProvider);

    return Scaffold(
      body: detailAsync.when(
        loading: () => const MovieDetailShimmer(),
        error: (e, _) => EmptyState(message: e.toString()),
        data: (detail) => CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 350,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(detail.title, maxLines: 1),
                background: Hero(
                  tag: 'movie_poster_${tmdbId}',  // matches card tag
                  child: AppNetworkImage(
                    url: '${ApiConstants.tmdbImageLarge}${detail.posterPath}',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              actions: [
                SaveButton(tmdbId: tmdbId, userId: activeUser?.id),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: AppSpacing.screen,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(detail.releaseDate ?? '', style: AppTextStyles.caption),
                    const SizedBox(height: AppSpacing.md),
                    Text(detail.overview ?? '', style: AppTextStyles.body),
                    const SizedBox(height: AppSpacing.lg),
                    // Who saved this movie
                    SaversRow(tmdbId: tmdbId),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// "X users want to watch this" widget
class SaversRow extends ConsumerWidget {
  final int tmdbId;
  const SaversRow({super.key, required this.tmdbId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saversAsync = ref.watch(movieSaversProvider(tmdbId));
    return saversAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (savers) {
        if (savers.isEmpty) {
          return Text(
            'Be the first to save this.',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500),
          );
        }
        return Row(
          children: [
            ...savers.take(5).map(
                  (u) => Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: CircleAvatar(
                      radius: 14,
                      backgroundImage: NetworkImage(u.avatarUrl ?? ''),
                    ),
                  ),
                ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              '${savers.length} ${savers.length == 1 ? "user wants" : "users want"} to watch this',
              style: AppTextStyles.bodySmall,
            ),
          ],
        );
      },
    );
  }
}
```

---

## Phase 6 — Saved Movies & Matches Pages

### 6.1 Saved Movies Page

```dart
// features/saved_movies/ui/saved_movies_page.dart
class SavedMoviesPage extends ConsumerWidget {
  final int userId;
  const SavedMoviesPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userByIdProvider(userId));
    final savedMoviesAsync = ref.watch(savedMoviesProvider(userId));

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Movies')),
      body: savedMoviesAsync.when(
        loading: () => const MovieListShimmer(),
        error: (e, _) => EmptyState(message: e.toString()),
        data: (movies) {
          if (movies.isEmpty) {
            return EmptyState(
              icon: Icons.bookmark_border_rounded,
              title: 'No saved movies yet',
              subtitle: 'Go browse trending movies and save the ones you want to watch.',
              action: TextButton(
                onPressed: () => context.push(RouteNames.movies(userId)),
                child: const Text('Browse Movies'),
              ),
            );
          }
          return Column(
            children: [
              // User header
              userAsync.whenData((user) => UserHeader(user: user)).value ??
                  const SizedBox.shrink(),

              Expanded(
                child: ListView.builder(
                  itemCount: movies.length,
                  itemBuilder: (ctx, i) => SavedMovieTile(
                    movie: movies[i],
                    activeUserId: userId,
                  ).animate(delay: Duration(milliseconds: i * 40))
                      .fadeIn()
                      .slideX(begin: 0.05),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
```

### 6.2 Matches Page (Stream-Driven, No API)

```dart
// features/matches/ui/matches_page.dart
class MatchesPage extends ConsumerWidget {
  const MatchesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Stream from local DB — updates in real time
    final matchesAsync = ref.watch(matchesProvider);
    final totalUsersAsync = ref.watch(totalUsersCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Matches'),
        centerTitle: true,
      ),
      body: matchesAsync.when(
        loading: () => const MovieListShimmer(),
        error: (e, _) => EmptyState(message: e.toString()),
        data: (matches) {
          if (matches.isEmpty) {
            return const EmptyState(
              icon: Icons.group_rounded,
              title: 'No matches yet',
              subtitle:
                  'When two or more users save the same movie, it appears here.',
            );
          }
          return totalUsersAsync.when(
            data: (totalUsers) => ListView.builder(
              padding: AppSpacing.screen,
              itemCount: matches.length,
              itemBuilder: (ctx, i) {
                final match = matches[i];
                final isTopPick = totalUsers > 1 &&
                    match.saverCount == totalUsers;
                return MatchMovieTile(
                  match: match,
                  isTopPick: isTopPick,
                ).animate(delay: Duration(milliseconds: i * 50))
                    .fadeIn()
                    .slideY(begin: 0.05);
              },
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
```

```dart
// features/matches/logic/matches_provider.dart
@riverpod
Stream<List<MovieWithSavers>> matches(Ref ref) {
  return ref.watch(appDatabaseProvider).savedMoviesDao.watchMatches();
}

@riverpod
Stream<int> totalUsersCount(Ref ref) {
  // Count all users from local DB
  final db = ref.watch(appDatabaseProvider);
  return db.usersDao.watchAllUsersWithCount().map((list) => list.length);
}
```

---

## Phase 7 — Offline Sync with WorkManager

### 7.1 Sync Worker

```dart
// core/sync/sync_worker.dart
class SyncWorker {
  static const taskName = 'sync_pending_users';

  static Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher);
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == SyncWorker.taskName) {
      return await _syncPendingUsers();
    }
    return Future.value(true);
  });
}

Future<bool> _syncPendingUsers() async {
  try {
    final db = AppDatabase();
    final dio = Dio(BaseOptions(baseUrl: ApiConstants.reqresBase))
      ..interceptors.add(ReqresAuthInterceptor());

    final pending = await db.usersDao.getPendingSyncUsers();

    for (final user in pending) {
      try {
        final response = await dio.post(
          ApiConstants.users,
          data: {'name': user.name, 'job': user.movieTaste},
        );
        final serverId = response.data['id']?.toString();
        if (serverId != null) {
          await db.usersDao.updateServerId(user.id, serverId);
        }
        await db.usersDao.markSynced(user.id);
      } catch (_) {
        // Leave as pending; will retry on next background run
        continue;
      }
    }

    await db.close();
    return true;
  } catch (_) {
    return false; // WorkManager will retry
  }
}
```

### 7.2 Register WorkManager in main.dart

```dart
// main.dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize WorkManager
  await SyncWorker.initialize();

  // Register a periodic sync task (fallback for persistent pending)
  await Workmanager().registerPeriodicTask(
    'periodic_sync',
    SyncWorker.taskName,
    frequency: const Duration(minutes: 15),
    constraints: Constraints(networkType: NetworkType.connected),
    existingWorkPolicy: ExistingWorkPolicy.keep,
  );

  runApp(
    const ProviderScope(child: App()),
  );
}
```

### 7.3 Listen to Connectivity — Auto-Trigger Sync

```dart
// app.dart — inside ConsumerWidget build
@override
Widget build(BuildContext context, WidgetRef ref) {
  // When internet comes back, trigger sync
  ref.listen(connectivityStreamProvider, (prev, next) {
    next.whenData((isOnline) {
      if (isOnline && prev?.value == false) {
        // Internet just came back — run sync now
        Workmanager().registerOneOffTask(
          'immediate_sync_${DateTime.now().millisecondsSinceEpoch}',
          SyncWorker.taskName,
          constraints: Constraints(networkType: NetworkType.connected),
        );
      }
    });
  });
  // ... rest of app
}
```

---

## Phase 8 — UI Polish

### 8.1 Shimmer Placeholders

```dart
// design_system/widgets/shimmer/shimmer_box.dart
class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.grey200,
      highlightColor: AppColors.grey50,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.grey200,
          borderRadius: borderRadius ?? AppRadius.smAll,
        ),
      ),
    );
  }
}

// User list shimmer
class UserListShimmer extends StatelessWidget {
  const UserListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 7,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            const ShimmerBox(width: 56, height: 56, borderRadius: AppRadius.fullAll),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(width: MediaQuery.of(context).size.width * 0.5, height: 16),
                  const SizedBox(height: AppSpacing.xs),
                  ShimmerBox(width: MediaQuery.of(context).size.width * 0.3, height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### 8.2 CachedNetworkImage Wrapper with Fade-In

```dart
// design_system/widgets/app_network_image.dart
class AppNetworkImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const AppNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        fit: fit,
        fadeInDuration: const Duration(milliseconds: 400),
        placeholder: (_, __) => ShimmerBox(
          width: width ?? double.infinity,
          height: height ?? double.infinity,
        ),
        errorWidget: (_, __, ___) => Container(
          width: width,
          height: height,
          color: AppColors.grey200,
          child: const Icon(Icons.movie_outlined, color: AppColors.grey500),
        ),
      ),
    );
  }
}
```

### 8.3 Reconnecting Bar

```dart
// design_system/widgets/reconnecting_bar.dart
class ReconnectingBar extends ConsumerWidget {
  const ReconnectingBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityAsync = ref.watch(connectivityStreamProvider);

    return connectivityAsync.when(
      data: (isOnline) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: isOnline ? 0 : 32,
        color: AppColors.warning,
        child: isOnline
            ? const SizedBox.shrink()
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox.square(
                    dimension: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Reconnecting...',
                    style: AppTextStyles.caption.copyWith(color: Colors.white),
                  ),
                ],
              ),
      ),
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
```

### 8.4 Hero Animation (Poster → Detail)

The hero tag must match exactly between the list card and the detail page.

```dart
// In movie card:
Hero(
  tag: 'movie_poster_${movie.id}',   // tmdbId as tag
  child: AppNetworkImage(...),
)

// In detail page SliverAppBar background:
Hero(
  tag: 'movie_poster_${tmdbId}',     // same tag
  child: AppNetworkImage(...),
)
```

GoRouter preserves Hero animations automatically. No extra config needed.

### 8.5 Staggered List Animation

Use `flutter_animate` for clean staggered entry:

```dart
// Apply to any list item
itemBuilder: (context, index) => MovieCard(movie: movies[index])
  .animate(delay: Duration(milliseconds: index * 60))
  .fadeIn(duration: 300.ms)
  .slideY(begin: 0.08, curve: Curves.easeOut),
```

---

## Phase 9 — Bad Connection Simulation

The assignment mentions a 30% block setting. Build a dev toggle that makes your interceptor randomly fail requests:

```dart
// core/network/interceptors/chaos_interceptor.dart
// Only used in debug builds or via a dev settings toggle
class ChaosInterceptor extends Interceptor {
  final double failureRate; // 0.3 = 30%
  ChaosInterceptor({this.failureRate = 0.3});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode && Random().nextDouble() < failureRate) {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionTimeout,
          message: '[Chaos] Simulated network failure',
        ),
      );
      return;
    }
    handler.next(options);
  }
}
```

Add a `ChaosInterceptor` after `RetryInterceptor` in your Dio setup in debug mode. This proves your retry logic works correctly under the exact test conditions the reviewer will run.

```dart
// In dio_client.dart
if (kDebugMode) dio.interceptors.add(ChaosInterceptor(failureRate: 0.3));
```

---

## Phase 10 — README & Submission

### README Template

```markdown
# Movie Discovery App

A Flutter app where multiple users save movies they want to watch and discover
which movies everyone agrees on.

## What It Does
- Browse trending movies from TMDB
- Multiple users can each save movies
- Matches page shows movies 2+ users saved
- Works completely offline with automatic sync when back online

## Architecture
Medium-sized clean architecture with feature folders (data / logic / ui),
Riverpod for state management, GoRouter for navigation, and Drift for
the local SQLite database.

## Design System
Material Design 3 with a custom color scheme and design tokens
(AppColors, AppTextStyles, AppSpacing, AppRadius) applied consistently
across all pages.

## Database Schema

### Tables

**users_table**
| Column       | Type    | Notes                          |
|---|---|---|
| id           | INTEGER | Local auto-increment PK        |
| server_id    | TEXT    | Assigned by Reqres after sync  |
| name         | TEXT    |                                |
| movie_taste  | TEXT    | Maps to "job" in Reqres API    |
| avatar_url   | TEXT    |                                |
| pending_sync | BOOLEAN | true = waiting for server sync |
| created_at   | DATETIME|                                |

**movies_table**
| Column       | Type    | Notes                    |
|---|---|---|
| id           | INTEGER | Local PK                 |
| tmdb_id      | INTEGER | UNIQUE — deduplication   |
| title        | TEXT    |                          |
| overview     | TEXT    |                          |
| poster_path  | TEXT    |                          |
| release_date | TEXT    |                          |

**saved_movies_table**
| Column   | Type    | Notes                             |
|---|---|---|
| id       | INTEGER | PK                                |
| user_id  | INTEGER | FK → users_table.id               |
| movie_id | INTEGER | FK → movies_table.id              |
| saved_at | DATETIME|                                   |
|          |         | UNIQUE(user_id, movie_id) prevents duplicates |

### Relationships
Each user can save many movies. A movie can be saved by many users.
The saved_movies_table is the join table. The Matches page queries
saved_movies grouped by movie_id, filtered to count ≥ 2.

## Offline Flow
1. Add User offline → saved to local DB with pending_sync=true
2. WorkManager registers a one-off task constrained to network available
3. When internet returns, task POSTs to Reqres, saves server_id back
4. Saved movies remain linked to the local user ID throughout — no data lost

## AI Usage
[Link to this document / conversation]
```

### Pre-Submission Checklist

```
Architecture & Code
  [ ] All 6 pages implemented and navigable
  [ ] Feature folders follow data / logic / ui structure
  [ ] No business logic inside widgets
  [ ] No raw colors or text styles hardcoded anywhere
  [ ] Riverpod providers scoped correctly (keepAlive where needed)

Offline
  [ ] Add user with airplane mode on → user appears immediately
  [ ] Movies page shows cached movies offline
  [ ] Save movies offline → correctly stored in local DB
  [ ] Turn internet on → pending user syncs (check with network logger)
  [ ] No duplicate users or saved movies after sync

UI
  [ ] Shimmer on Users page initial load
  [ ] Shimmer on Movies page initial load
  [ ] Shimmer on Movie Detail load
  [ ] Hero animation poster → detail page (smooth)
  [ ] Staggered fade-in on list items
  [ ] Images fade in via CachedNetworkImage
  [ ] Save count badge animates on change (AnimatedSwitcher)
  [ ] Snackbar after: save movie, add user, sync complete
  [ ] Reconnecting bar visible when offline
  [ ] Empty state on Saved Movies page (no movies)
  [ ] Empty state on Matches page (no matches)

Bad Connection
  [ ] ChaosInterceptor added in debug builds
  [ ] RetryInterceptor retries with backoff (1s, 3s, 6s)
  [ ] No full-screen error if list was already loaded
  [ ] ReconnectingBar shows during failed requests

Build
  [ ] flutter analyze — zero errors
  [ ] flutter build apk --release --obfuscate --split-debug-info=symbols/
  [ ] APK tested on a real device or emulator
  [ ] Public Git repo with clean commit history
  [ ] README complete with schema diagram
  [ ] AI prompt document included (this file)
```

---

## Quick Reference — Route Names

```dart
// core/router/route_names.dart
class RouteNames {
  static const users         = '/';
  static const addUser       = '/add-user';
  static const matches       = '/matches';
  static String movies(int userId)       => '/users/$userId/movies';
  static String savedMovies(int userId)  => '/users/$userId/saved';
  static String movieDetail(int tmdbId)  => '/movies/$tmdbId';
}
```

## Quick Reference — Provider Names

| Provider | Type | Scope |
|---|---|---|
| `appDatabaseProvider` | `AppDatabase` | keepAlive |
| `reqresDioProvider` | `Dio` | keepAlive |
| `tmdbDioProvider` | `Dio` | keepAlive |
| `connectivityStreamProvider` | `Stream<bool>` | keepAlive |
| `activeUserProvider` | `UsersTableData?` | app-level |
| `usersNotifierProvider` | `AsyncNotifier` | feature |
| `addUserNotifierProvider` | `AsyncNotifier` | feature |
| `moviesNotifierProvider` | `AsyncNotifier` | feature |
| `movieDetailProvider(id)` | `FutureProvider` | feature |
| `savedMoviesProvider(userId)` | `StreamProvider` | feature |
| `matchesProvider` | `StreamProvider` | feature |

---

*Platform Commons · Flutter Take-Home · Build Guide 2026*
*Flutter 3.27+ / Dart 3.6+ / Drift 2.x / Riverpod 2.x / WorkManager 0.5.x*