# Code Walkthrough — Phase by Phase

> How the Movie Discovery app is built, layer by layer.
> Covers every file implemented so far with plain-English explanations of what each piece does and why it exists.

---

## Phase 1 — Project Setup & Architecture

The goal of Phase 1 is to lay down the skeleton: entry point, routing, error handling, design system, and shared utilities. No feature logic yet — just the infrastructure every future phase will depend on.

---

### Entry Point — `main.dart` + `app.dart`

```
lib/main.dart
lib/app.dart
```

`main.dart` is the absolute entry point. Two things happen here:

1. `WidgetsFlutterBinding.ensureInitialized()` — required before any async work (database init, WorkManager, etc.) can happen before `runApp`.
2. The entire widget tree is wrapped in `ProviderScope` — this is Riverpod's requirement. Every provider in the app lives inside this scope.

`app.dart` holds the root `App` widget. It's a `ConsumerWidget` (Riverpod-aware) so it can read `routerProvider` to get the GoRouter instance. It sets up:
- `MaterialApp.router` with GoRouter for declarative navigation
- Light and dark themes from the design system
- `ThemeMode.system` so the app respects the device's appearance setting

---

### Routing — `core/router/`

```
lib/core/router/app_router.dart
lib/core/router/route_names.dart
```

`route_names.dart` is a single source of truth for every URL in the app. All routes are defined as constants or static methods here so no string is ever typed twice:

```dart
static const home = '/';
static const addUser = '/add-user';
static const matches = '/matches';
static String movies(int userId) => '/users/$userId/movies';
static String savedMovies(int userId) => '/users/$userId/saved';
static String movieDetail(int tmdbId) => '/movies/$tmdbId';
```

`app_router.dart` creates the `GoRouter` instance as a Riverpod `Provider`. Right now it only has a placeholder `/` route — real routes are wired in Phase 4+. Keeping it as a provider means any widget can `ref.watch(routerProvider)` and the router can later be rebuilt when auth state changes.

---

### Error Handling — `core/error/`

```
lib/core/error/failures.dart
lib/core/error/result.dart
```

**`failures.dart`** defines a sealed class hierarchy for every kind of error the app can produce:

| Class | When it's used |
|---|---|
| `NetworkFailure` | No internet / connection timeout |
| `ServerFailure` | API returned 4xx/5xx |
| `UnauthorizedFailure` | API returned 401 |
| `ValidationFailure` | Form input is invalid |
| `CacheFailure` | Local database read/write failed |

The `AppFailure.fromDio(DioException)` factory converts a raw Dio network error into the right failure type automatically. This means repository code never leaks Dio-specific types into the domain layer.

**`result.dart`** defines `Result<T>` — a sealed type with two subtypes: `Success<T>` and `Failure<T>`. Instead of throwing exceptions, every repository method returns a `Result`. The `when()` extension makes consuming results clean:

```dart
result.when(
  success: (data) => // use data,
  failure: (f) => // show f.message,
);
```

This pattern makes error handling explicit and impossible to forget.

---

### Networking Constants — `core/network/api_constants.dart`

```
lib/core/network/api_constants.dart
```

A single class holding every base URL, API key placeholder, and endpoint path. Nothing is hardcoded anywhere else in the app — all network code imports from here. The `movieDetail` method shows how parameterised endpoints are handled:

```dart
static String movieDetail(int id) => '/movie/$id';
```

Two APIs are used:
- **Reqres** (`reqres.in`) — for users (fake REST API, free, no auth needed beyond an API key header)
- **TMDB** (`api.themoviedb.org/3`) — for movies (real movie database)

---

### Connectivity — `core/utils/connectivity_service.dart`

```
lib/core/utils/connectivity_service.dart
```

Two Riverpod providers built on `connectivity_plus`:

- `connectivityStreamProvider` — a `StreamProvider<bool>` that emits `true`/`false` whenever the device's network status changes. The `ReconnectingBar` widget watches this to show/hide itself.
- `isOnlineProvider` — a `FutureProvider<bool>` that does a one-shot check of current connectivity. Used in `AddUserNotifier` (Phase 4) to decide whether to POST immediately or queue for background sync.

---

### Validators — `core/utils/validators.dart`

```
lib/core/utils/validators.dart
```

A simple utility class with static methods that match Flutter's `FormField` validator signature (`String? Function(String?)`). Currently has `required()` — more validators (email, min length, etc.) can be added here as needed.

---

### Context Extensions — `core/utils/extensions/context_ext.dart`

```
lib/core/utils/extensions/context_ext.dart
```

Extends `BuildContext` with shortcuts used throughout the UI:

```dart
context.colors.primary       // instead of Theme.of(context).colorScheme.primary
context.textTheme.bodyLarge  // instead of Theme.of(context).textTheme.bodyLarge
context.showSnackbar('Done') // instead of ScaffoldMessenger.of(context)...
context.push('/route')       // instead of GoRouter.of(context).push(...)
context.pop()                // instead of GoRouter.of(context).pop()
```

These aren't magic — they're just reducing boilerplate that would otherwise repeat hundreds of times across the UI layer.

---

### Background Sync Stub — `core/sync/sync_worker.dart`

```
lib/core/sync/sync_worker.dart
```

A stub for WorkManager background tasks. The `callbackDispatcher` function is annotated `@pragma('vm:entry-point')` — this is required by WorkManager because the callback runs in a separate Dart isolate and the compiler must not tree-shake it. The actual sync logic (reading pending users from DB and POSTing them) is implemented in Phase 7.

---

### Design System — `design_system/`

```
lib/design_system/app_colors.dart
lib/design_system/app_text_styles.dart
lib/design_system/app_spacing.dart
lib/design_system/app_radius.dart
lib/design_system/app_theme.dart
lib/design_system/widgets/...
```

The design system is a set of token classes — no magic, just named constants. The rule is: **nothing in the UI layer hardcodes a color, size, or text style**. Everything comes from here.

**`AppColors`** — 11 named colors covering primary, secondary, error, and a grey scale. The dark theme uses `surface` and `background` from this palette.

**`AppTextStyles`** — 5 text style presets (`h2`, `h3`, `body`, `bodySmall`, `caption`) with consistent font sizes, weights, and line heights.

**`AppSpacing`** — 6 spacing constants (`xs` through `xxl`) plus a `screen` EdgeInsets for consistent page padding.

**`AppRadius`** — 3 border radius presets (`smAll`, `mdAll`, `lgAll`) used on cards, images, and badges.

**`AppTheme`** — Assembles the above tokens into Material 3 `ThemeData` for light and dark modes.

**Widgets:**

| Widget | What it does |
|---|---|
| `PrimaryButton` | Full-width `FilledButton` with a built-in loading spinner state |
| `AppCard` | `Card` + `InkWell` wrapper with consistent padding and border radius |
| `EmptyState` | Centered icon + title + optional subtitle + optional action button, used on every empty list |
| `ReconnectingBar` | Watches `connectivityStreamProvider` and renders an orange banner when offline |
| `AppNetworkImage` | Wraps `CachedNetworkImage` with consistent error/placeholder handling |
| `ShimmerBox` | A single shimmer-animated rectangle, used to build skeleton loaders |

---

## Phase 2 — Database Schema (Drift)

The goal of Phase 2 is to define the local SQLite database that powers the entire offline-first architecture. Every piece of data the app displays — users, movies, saves — lives here first. The network is just a source of truth to sync from.

---

### How Drift Works (Quick Primer)

Drift is a type-safe SQLite library for Flutter. You define tables as Dart classes, annotate a database class, run `build_runner`, and Drift generates all the SQL and Dart boilerplate. You never write raw SQL.

The generated file is `app_database.g.dart`. You never edit it — it's always regenerated from your table definitions.

---

### Database Definition — `app_database.dart`

```
lib/core/storage/database/app_database.dart
```

This file does three things:

**1. Declares the three tables** (see below).

**2. Declares the `AppDatabase` class** — the single database instance for the whole app:

```dart
@DriftDatabase(
  tables: [UsersTable, MoviesTable, SavedMoviesTable],
  daos: [UsersDao, MoviesDao, SavedMoviesDao],
)
class AppDatabase extends _$AppDatabase { ... }
```

The `@DriftDatabase` annotation tells the code generator which tables and DAOs to wire together. `_$AppDatabase` is the generated base class.

`schemaVersion: 1` — when you add columns or tables in the future, you increment this and write a migration in `onUpgrade`.

**3. Exposes a Riverpod provider:**

```dart
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
```

`ref.onDispose(db.close)` ensures the database connection is properly closed if the provider is ever disposed (important for testing).

---

### Table: `UsersTable`

```dart
class UsersTable extends Table {
  IntColumn    get id          => integer().autoIncrement()();
  TextColumn   get serverId    => text().nullable()();
  TextColumn   get name        => text()();
  TextColumn   get movieTaste  => text()();
  TextColumn   get email       => text().nullable()();
  TextColumn   get avatarUrl   => text().nullable()();
  BoolColumn   get pendingSync => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
```

Key design decisions:

- `serverId` is **nullable** — when a user is created offline, they don't have a server ID yet. It gets filled in after the background sync POSTs them to Reqres.
- `pendingSync` defaults to `false`. It's set to `true` when a user is created offline. The sync worker reads all rows where `pendingSync = true`, POSTs them, then sets it back to `false`.
- `movieTaste` maps to the `job` field in the Reqres API — it's a free-text description of what kind of movies the user likes.
- `createdAt` defaults to the current time so the users list can be sorted newest-first without any extra logic.

---

### Table: `MoviesTable`

```dart
class MoviesTable extends Table {
  IntColumn  get id          => integer().autoIncrement()();
  IntColumn  get tmdbId      => integer().unique()();
  TextColumn get title       => text()();
  TextColumn get overview    => text().nullable()();
  TextColumn get posterPath  => text().nullable()();
  TextColumn get releaseDate => text().nullable()();
  RealColumn get popularity  => real().nullable()();
}
```

Key design decisions:

- `tmdbId` has a `.unique()` constraint — this is what makes `insertOnConflictUpdate` work correctly. When the same trending movie is fetched on two different days, it updates the existing row rather than creating a duplicate.
- `id` is the local primary key used for all foreign key references within the app. `tmdbId` is the external identifier used when talking to the TMDB API.
- All content fields are nullable because the TMDB API occasionally returns incomplete data.

---

### Table: `SavedMoviesTable`

```dart
class SavedMoviesTable extends Table {
  IntColumn    get id      => integer().autoIncrement()();
  IntColumn    get userId  => integer().references(UsersTable, #id)();
  IntColumn    get movieId => integer().references(MoviesTable, #id)();
  DateTimeColumn get savedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [{userId, movieId}];
}
```

This is a classic many-to-many join table. One user can save many movies; one movie can be saved by many users.

Key design decisions:

- `.references(UsersTable, #id)` and `.references(MoviesTable, #id)` declare foreign keys. Drift enforces referential integrity — you can't save a movie for a user that doesn't exist.
- The `uniqueKeys` override creates a composite unique constraint on `(userId, movieId)`. This means `InsertMode.insertOrIgnore` in `saveMovie()` silently does nothing if the user already saved that movie — no duplicates, no errors.

---

### DAO: `UsersDao`

```
lib/core/storage/database/daos/users_dao.dart
```

DAOs (Data Access Objects) are where all the query logic lives. Each DAO is a `part of` the main database file — this is how Drift's code generation works across multiple files.

**`watchAllUsersWithCount()`** — the most complex query in the app. It:
1. Selects all users, ordered newest-first
2. LEFT OUTER JOINs the `saved_movies` table on `userId`
3. Counts the number of saved movies per user
4. Groups by `userId` to collapse the join rows

The result is a `Stream<List<UserWithSaveCount>>` — it emits a new list every time any user or saved movie changes. The UI just watches this stream and rebuilds automatically.

**`insertUser()`** — inserts a new user row and returns the auto-generated local `id`. This local ID is used immediately to reference the user in the UI, even before the server assigns a `serverId`.

**`upsertRemoteUser()`** — uses `insertOnConflictUpdate` to insert a user from the Reqres API. If a user with the same primary key already exists (e.g. fetched on a previous session), it updates the row instead of failing.

**`getPendingSyncUsers()`** — returns all users where `pendingSync = true`. Called by the sync worker in Phase 7.

**`updateServerId()` / `markSynced()`** — called after a successful POST to Reqres. First sets the `serverId` returned by the API, then clears the `pendingSync` flag.

---

### DAO: `MoviesDao`

```
lib/core/storage/database/daos/movies_dao.dart
```

Intentionally simple — movies are read-only from the app's perspective (you can't create or delete movies, only save/unsave them).

**`upsertMovie()`** — inserts or updates a movie by its `tmdbId` unique constraint. Called every time trending movies are fetched from TMDB, keeping the local cache fresh.

**`getMovieByTmdbId()`** — looks up a movie by its TMDB ID. Used in `MoviesRepository.toggleSave()` to resolve the TMDB ID (from the API response) to the local `id` (needed for the `SavedMoviesTable` foreign key).

**`getMoviesByIds()`** — bulk fetch by local IDs. Available for future use (e.g. fetching a specific set of movies for a user's saved list by ID).

---

### DAO: `SavedMoviesDao`

```
lib/core/storage/database/daos/saved_movies_dao.dart
```

The most query-rich DAO — it powers three different pages.

**`watchSavedMoviesForUser(userId)`** — INNER JOINs `movies` and `saved_movies` filtered by `userId`. Returns a stream of `MoviesTableData` — the Saved Movies page watches this directly.

**`watchSaveCountForMovie(movieLocalId)`** — counts how many rows in `saved_movies` reference a given movie. Returns a `Stream<int>` — the animated save count badge on each movie card watches this. When any user saves or unsaves the movie, the badge updates in real time.

**`watchMatches()`** — the most complex query. It finds movies saved by 2 or more users:

```
SELECT movies.*, COUNT(saved_movies.userId) as saverCount
FROM movies
INNER JOIN saved_movies ON saved_movies.movieId = movies.id
GROUP BY movies.id
HAVING COUNT > 1
ORDER BY saverCount DESC
```

Because Drift 2.28.x puts `having` as a named parameter on `groupBy` (not a separate method), the query uses `selectOnly` to manually project all movie columns alongside the aggregate count. The result is mapped back to `MoviesTableData` objects manually.

**`getUsersWhoSavedMovie(movieLocalId)`** — INNER JOINs `users` and `saved_movies` to get the list of users who saved a specific movie. Used on the Movie Detail page to show the row of avatar images.

**`isMovieSavedByUser()`** — a simple existence check. Returns `true` if a row exists for the given `(userId, movieId)` pair. Used to determine whether to show a filled or outlined bookmark icon.

**`saveMovie()` / `unsaveMovie()`** — insert or delete a row in `saved_movies`. `saveMovie` uses `InsertMode.insertOrIgnore` so calling it twice for the same pair is a no-op (the unique constraint handles it silently).

---

### Code Generation

After writing the table and DAO definitions, running:

```bash
dart run build_runner build --delete-conflicting-outputs
```

generates `app_database.g.dart`, which contains:
- The `_$AppDatabase` base class with the actual SQLite schema creation SQL
- Mixin classes (`_$UsersDaoMixin`, etc.) with the typed query helpers each DAO uses
- Companion classes (`UsersTableCompanion`, etc.) for building insert/update payloads with optional fields

You never edit the `.g.dart` file. Re-run `build_runner` any time you change a table definition or DAO.

---

## Phase 3 — Networking Layer

The goal of Phase 3 is to set up two typed HTTP clients — one for Reqres, one for TMDB — with automatic retries on bad connections and auth headers injected transparently.

---

### Retry Interceptor — `core/network/interceptors/retry_interceptor.dart`

Dio interceptors sit in the request/response pipeline. `RetryInterceptor` hooks into `onError` — every failed request passes through here before the error reaches the caller.

The logic:
1. Read `retryAttempt` from `requestOptions.extra` (defaults to 0 if not set)
2. Check if the error is retryable (connection timeout, receive timeout, connection error, or 5xx status)
3. If retryable and under `maxRetries`, wait for the backoff delay (`1s → 3s → 6s`) then re-fire the original request via `dio.fetch(options)`
4. If the retry succeeds, `handler.resolve(response)` — the original caller gets the response as if nothing happened
5. If the retry also fails, `handler.next(err)` — pass the error downstream

The retry Dio instance passed into `RetryInterceptor` is a plain `Dio` with no interceptors — this prevents infinite retry loops (the retry request doesn't go through `RetryInterceptor` again).

---

### Auth Interceptor — `core/network/interceptors/auth_interceptor.dart`

Hooks into `onRequest` and adds the Reqres API key as an `x-api-key` header to every outgoing request on the Reqres client. The TMDB client doesn't use this interceptor — TMDB auth is handled via a query parameter (`api_key`) set in `BaseOptions.queryParameters` instead.

---

### Dio Clients — `core/network/dio_client.dart`

Two separate `Dio` instances as Riverpod `Provider`s:

**`reqresDioProvider`**
- Base URL: `https://reqres.in/api`
- Interceptors: `ReqresAuthInterceptor` → `RetryInterceptor` → `LogInterceptor` (debug only)

**`tmdbDioProvider`**
- Base URL: `https://api.themoviedb.org/3`
- `api_key` query param attached to every request via `BaseOptions.queryParameters`
- Interceptors: `RetryInterceptor` → `LogInterceptor` (debug only)

Keeping them as separate providers means feature repositories declare exactly which client they depend on — `MoviesRepository` takes `tmdbDioProvider`, `UsersRepository` takes `reqresDioProvider`. There's no shared mutable state between the two.

`LogInterceptor(responseBody: true)` is only added in `kDebugMode` — it prints full request/response bodies to the console during development but is stripped from release builds.

---

| Phase | What it adds |
|---|---|
| **Phase 3** | Dio HTTP clients with retry interceptor and auth headers |
| **Phase 4** | Users page (infinite scroll, shimmer) + Add User form (online/offline) |
| **Phase 5** | Movies page + Movie Detail with Hero animation |
| **Phase 6** | Saved Movies page + Matches page (stream-driven, no API) |
| **Phase 7** | WorkManager background sync for offline-created users |
| **Phase 8** | Shimmer loaders, staggered animations, animated badge |
| **Phase 9** | ReconnectingBar wired to retry interceptor |
| **Phase 10** | Release build + README |
