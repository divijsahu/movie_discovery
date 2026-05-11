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

Three APIs are used:
- **Reqres** (`reqres.in`) — for users (fake REST API, free, requires an API key header)
- **TMDB** (`api.themoviedb.org/3`) — for movies (real movie database)
- **OMDB** (`omdbapi.com`) — fallback when TMDB is unavailable

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

`schemaVersion: 2` — v2 migration runs a `DELETE` that keeps only the lowest-`id` row per `serverId`, cleaning up duplicate remote users that were inserted before the `upsertRemoteUser` fix.

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

**`upsertMovie()`** — checks for an existing row by `tmdbId` first. If found, updates in place. If not, inserts. This is necessary because `insertOnConflictUpdate` in Drift conflicts on the primary key (`id`), not the `tmdbId` unique column — so a naive upsert would hit the unique constraint and throw on re-insert.

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

Three separate `Dio` instances as Riverpod `Provider`s:

**`reqresDioProvider`**
- Base URL: `https://reqres.in/api`
- Interceptors: `ReqresAuthInterceptor` → `RetryInterceptor` → `AppLogInterceptor` (debug only)

**`tmdbDioProvider`**
- Base URL: `https://api.themoviedb.org/3`
- `api_key` query param attached to every request via `BaseOptions.queryParameters`
- Interceptors: `RetryInterceptor` → `AppLogInterceptor` (debug only)

**`omdbDioProvider`**
- Base URL: `https://www.omdbapi.com`
- `apikey` query param attached globally
- Interceptors: `RetryInterceptor` → `AppLogInterceptor` (debug only)
- Used as a fallback when TMDB is unavailable

Keeping them as separate providers means feature repositories declare exactly which client they depend on. `MoviesRepository` takes both `tmdbDioProvider` and `omdbDioProvider`; `UsersRepository` takes only `reqresDioProvider`.

`AppLogInterceptor` (debug only) prints structured `┌─/└─` bordered lines with timing, response summaries, and retry counts. API keys are filtered out of log output.

---

## Phase 4 — Users Page & Add User

The goal of Phase 4 is to build the first fully working feature: fetch users from Reqres, cache them locally, display them in a live-updating list, and let users be added both online and offline.

---

### User Model — `features/users/data/models/user_model.dart`

A Freezed model matching the Reqres API response. `@JsonKey` on the factory parameters maps `first_name` → `firstName` and `last_name` → `lastName`. The `// ignore_for_file: invalid_annotation_target` suppresses a false-positive lint — the generated code handles the mapping correctly.

`UsersResponse` wraps the paginated response with `page`, `totalPages`, and `data` (the list of users).

---

### Users API — `features/users/data/users_api.dart`

Two methods:
- `fetchUsers(page)` — GET `/users?page=X`, returns `UsersResponse`
- `createUser(name, job)` — POST `/users`, returns the raw response map (Reqres returns `{id, name, job, createdAt}`)

Exposed as `usersApiProvider` injecting `reqresDioProvider`.

---

### Users Repository — `features/users/data/users_repository.dart`

The bridge between the API and the local DB:

- `watchUsers()` — returns a `Stream` from the DB. The UI always reads from here, never directly from the API.
- `fetchAndCachePage(page)` — calls the API, then upserts each user into the DB via `upsertRemoteUser`. Returns `Result<UsersResponse>` so the notifier knows the total page count.

The key insight: the UI stream and the network fetch are completely decoupled. The fetch writes to the DB; the stream reads from the DB. They never talk to each other directly.

---

### Users Notifier — `features/users/logic/users_provider.dart`

`UsersNotifier` is an `AsyncNotifier<void>` — it manages pagination state but doesn't hold the list itself (that lives in the DB stream).

- `build()` — fires on first watch, loads page 1
- `loadMore()` — called when the scroll position is 200px from the bottom. Guards against concurrent fetches with `_isFetchingMore`.
- `refresh()` — resets `_currentPage` to 1 and calls `ref.invalidateSelf()` to re-trigger `build()`

`usersStreamProvider` is a separate `StreamProvider` that watches the DB directly — it emits a new list whenever any row in `UsersTable` or `SavedMoviesTable` changes.

---

### Add User Notifier — `features/add_user/logic/add_user_provider.dart`

Handles the online/offline split:

1. Check connectivity via `isOnlineProvider`
2. Always insert locally first — the user appears in the list immediately regardless of network
3. **Online path** — POST to Reqres, get back a `serverId`, call `updateServerId` to store it
4. **POST fails mid-flight** — call `markPendingSync(localId)` to flip the flag, then schedule WorkManager
5. **Offline path** — insert with `pendingSync=true`, schedule WorkManager
6. **WorkManager on iOS** — wrapped in try/catch because iOS requires `BGTaskSchedulerPermittedIdentifiers` in `Info.plist`. The user is already saved locally so nothing is lost.

---

### Users Page — `features/users/ui/users_page.dart`

Two providers watched simultaneously:
- `usersStreamProvider` — the live DB list
- `usersNotifierProvider` — its `isLoading` state drives the shimmer

Shimmer is shown when `isFetching && users.isEmpty` — meaning the network fetch is in flight AND the DB has no cached data yet. On subsequent launches the cached list appears instantly.

Animations use `key: ValueKey('anim_${item.user.id}')` on `.animate()` — this ties the animation lifecycle to the item's identity so `fadeIn` only plays once per item, not every time it scrolls into view.

The stagger delay is capped at `(index % 20) * 50ms` so items beyond position 20 don't wait over a second to appear.

---

### Add User Page — `features/add_user/ui/add_user_page.dart`

A standard `ConsumerStatefulWidget` form with two `TextEditingController`s. Uses `ref.listen` to react to state changes — on success it shows a snackbar and pops; on error it shows an error snackbar. The `PrimaryButton` shows a spinner while `state.isLoading` is true.

---

## Phase 5 — Movies Page & Movie Detail

The goal of Phase 5 is to fetch trending movies, cache them, let users save/unsave them, and navigate to a detail page with a Hero animation.

---

### Movie Model — `features/movies/data/models/movie_model.dart`

Freezes `MovieModel` with `@JsonKey` for `poster_path`, `release_date`. `MoviesPageResponse` wraps the TMDB paginated response with `page`, `totalPages`, `results`.

---

### TMDB API — `features/movies/data/movies_api.dart`

- `fetchTrending(page)` — GET `/trending/movie/day?language=en-US&page=X`
- `fetchDetail(tmdbId)` — GET `/movie/:id`

The `api_key` query param is attached globally in `tmdbDioProvider`'s `BaseOptions.queryParameters` — individual API calls don't need to include it.

---

### OMDB API — `features/movies/data/omdb_api.dart`

OMDB has no trending endpoint, so `fetchPopular(page)` cycles through a list of 20 curated search terms (one per page) and fetches the first 5 detail results for each. This simulates pagination.

OMDB's `imdbID` field (e.g. `tt1234567`) is stripped of non-numeric characters and used as the movie's `id`. Poster URLs from OMDB are full `https://` URLs — `AppNetworkImage` handles them identically to TMDB paths.

---

### Movies Repository — `features/movies/data/movies_repository.dart`

Three-layer fallback chain for `fetchTrending`:
1. Try TMDB → on success, cache and return
2. On any `DioException` → try OMDB fallback
3. OMDB also fails → return `Failure(NetworkFailure())`

For `fetchDetail`:
1. Try TMDB detail
2. Try OMDB by constructing an imdbID from the tmdbId (`tt` + zero-padded number)
3. Serve from local DB cache if both APIs are down

`toggleSave` resolves the `tmdbId` → local `id` via `getMovieByTmdbId`, then delegates to `SavedMoviesDao`.

`watchSaveCount` is an `async*` generator — it first awaits the DB lookup, then yields from the stream. This avoids the stream emitting before the movie row exists.

---

### Movies Notifier — `features/movies/logic/movies_provider.dart`

The notifier state is a Dart record `({List<MovieModel> movies, String? error})` — both the list and any error live in the same `AsyncValue`. This avoids the Riverpod rule violation that occurs when one provider tries to write to another provider during `build()`.

- `build()` — loads page 1, returns the initial `MoviesState`
- `loadMore()` — appends to the existing list, sets `AsyncData` directly
- `refresh()` — sets `AsyncLoading` then `AsyncData` without calling `invalidateSelf()`, preventing a `build()` re-trigger

Error is only surfaced (`error != null`) when the movie list is empty — if there are cached movies, the error is swallowed silently so the user sees their cached data instead of an error screen.

Derived providers:
- `moviesListProvider` — reads `valueOrNull?.movies ?? []`
- `moviesErrorProvider` — reads `valueOrNull?.error`
- `saveCountProvider(tmdbId)` — `StreamProvider.family` watching save count per movie
- `isSavedProvider((userId, tmdbId))` — `FutureProvider.family` using a record tuple as the key
- `movieSaversProvider(tmdbId)` — `FutureProvider.family` for the detail page savers row

---

### Movie Card — `features/movies/ui/widgets/movie_card.dart`

The poster is wrapped in a `Hero` with tag `movie_poster_${movie.id}` — this matches the tag in `MovieDetailPage` to produce the expand/shrink transition.

`SaveCountBadge` uses `AnimatedSwitcher` with a `ScaleTransition` — when the count changes, the old badge scales down and the new one scales up. The `ValueKey(count)` on the inner container is what triggers the switcher.

---

### Movie Detail Page — `features/movie_detail/ui/movie_detail_page.dart`

Uses `movieDetailProvider(tmdbId)` — a `FutureProvider.family` defined in `movies_provider.dart` — to fetch the detail. Riverpod caches the result by `tmdbId` so the fetch only fires once regardless of rebuilds.

The `SliverAppBar` with `expandedHeight: 340` and `pinned: true` keeps the title visible while scrolling. The `Hero` widget wraps the background image — Flutter matches it to the card's Hero by tag and animates between them.

`_SaversRow` watches `movieSaversProvider(tmdbId)` and shows up to 5 avatar circles plus a count label.

---

## Phase 6 — Saved Movies & Matches Pages

The goal of Phase 6 is to build two purely local pages — no API calls, everything driven by DB streams that update in real time as saves happen.

---

### Saved Movies Provider — `features/saved_movies/logic/saved_movies_provider.dart`

A single `StreamProvider.family<List<MoviesTableData>, int>` keyed by `userId`. It delegates directly to `SavedMoviesDao.watchSavedMoviesForUser(userId)` — a Drift stream that re-emits whenever any row in `saved_movies` changes for that user.

Because it's a `family`, each user gets their own independent stream. Navigating to User A's saved page and User B's saved page simultaneously would create two separate stream subscriptions.

---

### Matches Provider — `features/matches/logic/matches_provider.dart`

Two providers:

- `matchesProvider` — delegates to `SavedMoviesDao.watchMatches()`, which returns movies saved by 2+ users ordered by saver count descending. Updates in real time.
- `totalUsersCountProvider` — maps the users stream to just its length. Used by `MatchesPage` to determine the Top Pick threshold.

---

### Saved Movies Page — `features/saved_movies/ui/saved_movies_page.dart`

Watches `savedMoviesProvider(userId)`. Each row shows the poster, title, year, and a filled bookmark icon. Tapping the bookmark calls `moviesRepository.toggleSave(userId, movie.tmdbId)` — the DB stream immediately removes the row from the list without any manual state management.

The empty state includes a "Browse Movies" `TextButton` that pushes `RouteNames.movies(userId)` — keeping the user in context of which user they're browsing for.

Poster URLs use `ApiConstants.tmdbImageSmall` prefix — OMDB movies store full URLs in `posterPath` so the prefix is harmless (the full URL still resolves correctly).

---

### Matches Page — `features/matches/ui/matches_page.dart`

Watches both `matchesProvider` and `totalUsersCountProvider`. The Top Pick condition is:

```dart
final isTopPick = totalUsers > 1 && match.saverCount >= totalUsers;
```

This means every user in the app has saved that movie. `totalUsers > 1` prevents a single user from triggering Top Pick on their own saves.

The page makes zero API calls — it's entirely driven by the local DB. Adding a new save on the Movies page will cause this page to update instantly if it's open in the navigation stack.

---

### Match Movie Tile — `features/matches/ui/widgets/match_movie_tile.dart`

Shows poster, title, saver count row, and conditionally the Top Pick badge. The badge uses `AppColors.secondary` (green) with a fire icon to visually distinguish it from the primary blue used elsewhere. The poster is wrapped in a `Hero` with tag `match_poster_${movie.tmdbId}` for a smooth transition if tapped.

---

### Navigation — `UserListTile` save count badge

The save count badge on each user tile is now wrapped in a `GestureDetector` that pushes `RouteNames.savedMovies(user.id)`. This gives a direct path from the users list to any user's saved movies without going through the movies page first.

---

## Phase 7 — Offline Sync (WorkManager)

The goal of Phase 7 is to ensure users created while offline are automatically POSTed to Reqres the next time the app has connectivity — with zero data loss and no duplicates.

---

### `runPendingUserSync()` — `core/sync/sync_worker.dart`

The sync logic lives in a standalone top-level function (not a class method) so it can be called from two places:
1. The WorkManager background isolate via `callbackDispatcher`
2. `main.dart` on every app launch if online

This is important because WorkManager on iOS requires `BGTaskSchedulerPermittedIdentifiers` registered in `Info.plist` to schedule background tasks. Without that, the WorkManager call throws a `PlatformException`. The launch sync covers this gap — even if the background task never fires, the sync happens the next time the user opens the app.

The function opens its own `AppDatabase` and `Dio` instances directly — Riverpod is not available in a background isolate. It reads all rows where `pendingSync = true`, POSTs each to Reqres, then calls `updateServerId` + `markSynced`. If an individual POST fails, the row stays `pendingSync = true` and WorkManager retries the task automatically.

**`callbackDispatcher`** is annotated `@pragma('vm:entry-point')` — required so the Dart compiler doesn't tree-shake it, since it's called from native code in a separate isolate.

---

### Launch sync — `main.dart`

`_syncOnLaunch()` is called in `main()` before `runApp`. It checks connectivity first — if offline it skips silently. If online, it calls `runPendingUserSync()`. This means:
- On Android: both the launch sync and WorkManager background task can fire
- On iOS: only the launch sync fires reliably

The `⟳` sync icon disappears from the user tile as soon as `markSynced` clears the `pendingSync` flag, because the users list is a live DB stream.

---

## Phase 8 — UI Polish

The goal of Phase 8 is to make the app feel native and polished — smooth animations, correct shimmer in dark mode, responsive feedback on every interaction.

---

### Dark-mode aware shimmer — `ShimmerBox`

The original `ShimmerBox` used hardcoded `Colors.grey[300]`/`Colors.grey[100]` which looked jarring in dark mode (bright white rectangles on a dark background). Now reads `Theme.of(context).brightness` and switches to `Colors.grey[800]`/`Colors.grey[700]` in dark mode.

---

### Animated `ReconnectingBar`

Replaced the abrupt `if (isOnline) return SizedBox.shrink()` with `AnimatedSlide` + `AnimatedOpacity`. The bar slides down from above when connectivity is lost and slides back up while fading out when restored. Duration is 300ms with `Curves.easeInOut`.

---

### Stale bookmark icon fix

`isSavedProvider` is a `FutureProvider` — it runs once and caches the result. After `toggleSave`, the icon wouldn't flip until something caused the provider to rebuild. Fixed by calling `ref.invalidate(isSavedProvider((userId, tmdbId)))` immediately after `toggleSave` in both `MovieCard` and `MovieDetailPage`. This forces a fresh DB read and the icon flips instantly.

---

### OMDB poster URL fix — `_posterUrl()` helper

OMDB returns full `https://` poster URLs. TMDB returns relative paths like `/abc123.jpg` that need the base URL prepended. The `_posterUrl()` helper checks `path.startsWith('http')` — if true, returns as-is; otherwise prepends `ApiConstants.tmdbImageSmall`. Applied to `MovieCard`, `SavedMoviesPage`, and `MatchMovieTile`.

---

### `BouncingScrollPhysics`

Added to all four list views (users, movies, saved movies, matches) for the native iOS rubber-band bounce feel at the top and bottom of lists.

---

### `movieDetailProvider` family

The original detail page used an inline `FutureProvider((ref) async {...})` created inside `build()`. Every rebuild created a new provider instance, causing duplicate API calls. Replaced with `movieDetailProvider` as a proper `FutureProvider.family` in `movies_provider.dart` — Riverpod caches it by `tmdbId`, so the fetch only happens once regardless of how many widgets watch it.

---

## Phase 9 — Bad Connection Handling

The goal of Phase 9 is to ensure the app degrades gracefully on poor or no connectivity — silent retries, visible feedback, and accurate error states.

---

### `RetryInterceptor` — already built in Phase 3, verified here

- Retries GET requests up to 3 times with exponential backoff: 1s → 3s → 6s
- POST/PATCH/PUT are never retried — prevents duplicate mutations
- Uses a plain inner `Dio` instance with no interceptors to avoid re-triggering itself
- Retry log fires in `onRequest` (before the retry) not `onError` (after), so the console reads in chronological order

---

### `ReconnectingBar` on all pages

Phases 4–6 added `ReconnectingBar` to `UsersPage` and `MoviesPage`. Phase 9 adds it to `SavedMoviesPage` and `MatchesPage` — now all four pages show the animated orange bar when connectivity is lost.

---

### Error states

The movies page shows a `"Could not load movies"` error with the actual API failure message and a Retry button — but only when the movie list is empty. If there are cached movies, the error is swallowed silently and the cached list is shown. This is the correct UX: don't interrupt the user with an error if they already have data to look at.

---

## Phase 10 — Final Polish & Submission

---

### README

Completely rewritten from the old template boilerplate. Contains: pages table, step-by-step setup with exact file paths for API keys, architecture tree, key features section, API keys table with signup links, database schema, sample console output, and build commands.

---

### `.env.example`

Replaced the generic template file with just the 3 keys this project uses (Reqres, TMDB, OMDB), each with a direct link to where to get them.

---

### GitHub Actions — `.github/workflows/`

Three separate workflow files:

**`code_quality.yml`** — auto-runs on every push/PR to `main`/`develop`:
- `flutter analyze --fatal-infos --fatal-warnings`
- `dart format --set-exit-if-changed lib/`
- `concurrency` group cancels in-progress runs on the same branch

**`tests.yml`** — manual trigger (`workflow_dispatch`):
- Optional Flutter version input
- `flutter test --coverage`
- Writes a summary table to the Actions run page

**`build_apk.yml`** — manual trigger:
- Builds unsigned release APK
- Renames to `MD {version} +{build}.apk` (e.g. `MD 1.0.0 +1.apk`)
- Creates and pushes a git tag (`v1.0.0+1`)
- Creates a GitHub Release with the APK attached as a downloadable asset
- Uploads APK as a workflow artifact (configurable retention)
- Cleanup job deletes artifacts older than the retention period

---

## Branding — App Icon & Native Splash

---

### App Icon — `flutter_launcher_icons`

Configured in `pubspec.yaml` under `flutter_launcher_icons`. Points to `assets/icons/app_icon.png` (1080×1080 Movie Discovery logo). Running `dart run flutter_launcher_icons` generates all required sizes:
- **Android**: `mipmap-mdpi` through `mipmap-xxxhdpi` in `android/app/src/main/res/`
- **iOS**: all sizes in `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

Web, Windows, and macOS generation is disabled (`generate: false`) since this is a mobile-only app.

---

### Native Splash Screen — `flutter_native_splash`

Configured in `pubspec.yaml` under `flutter_native_splash`. Uses the same `app_icon.png` centered on a pure black (`#000000`) background — matching the icon's outer border for a seamless look.

Running `dart run flutter_native_splash:create` generates:
- **Android**: `launch_background.xml` drawables + `styles.xml` entries for all density buckets
- **Android 12+**: dedicated `android12splash` drawables using the new `SplashScreen` API
- **iOS**: `LaunchImage` assets + `LaunchScreen.storyboard` background color

**`FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding)`** is called at the very start of `main()` — this keeps the native splash visible while WorkManager initialises and `_syncOnLaunch()` runs. **`FlutterNativeSplash.remove()`** is called just before `runApp` — Flutter takes over at that exact moment with no gap.

**Black background fix** — the `NormalTheme` in all four Android styles files (`values`, `values-night`, `values-v31`, `values-night-v31`) had `windowBackground` set to `?android:colorBackground` which resolves to the system's light/dark background color. This caused a brief bluish flash between the splash and Flutter's first frame. Fixed by hardcoding `#000000` in all four files. The iOS `LaunchScreen.storyboard` `backgroundColor` was also changed from white `(1,1,1)` to black `(0,0,0)`.
