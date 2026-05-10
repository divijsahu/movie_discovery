# Movie Discovery App — Progress Checklist

> Platform Commons Engineering Assignment · 2026
> Reference: `Platform Commons Plan.md` for full implementation details.

---

## How This Works

After each phase:
1. Dev completes implementation → marks phase tasks ✅
2. You run build/test/run checks → mark your checks ✅
3. On green light → move to next phase

---

## Phase 1 — Project Setup & Architecture

### Dev Completed
- [x] Renamed package to `movie_discovery`, updated Android `applicationId`
- [x] Replaced `pubspec.yaml` with all plan dependencies (Riverpod, GoRouter, Dio, Drift, WorkManager, Connectivity, Freezed, Shimmer, flutter_animate, etc.)
- [x] Created full folder structure matching the plan
- [x] `main.dart` — ProviderScope + WidgetsFlutterBinding
- [x] `app.dart` — MaterialApp.router with GoRouter + light/dark theme
- [x] `core/router/` — `app_router.dart` (placeholder route), `route_names.dart`
- [x] `core/error/` — `failures.dart` (sealed, with `fromDio`), `result.dart`
- [x] `core/network/api_constants.dart` — Reqres + TMDB constants
- [x] `core/utils/connectivity_service.dart` — stream + future providers
- [x] `core/utils/validators.dart`
- [x] `core/utils/extensions/context_ext.dart`
- [x] `core/sync/sync_worker.dart` — WorkManager stub
- [x] `design_system/` — colors, text styles, spacing, radius, theme
- [x] `design_system/widgets/` — PrimaryButton, ShimmerBox, EmptyState, ReconnectingBar, AppNetworkImage, AppCard
- [x] Removed all old `flutter_app_template` files
- [x] `flutter analyze` → No issues found

### Your Checks
- [x] `flutter pub get` — resolves cleanly
- [x] `flutter analyze` — no errors
- [ ] `flutter run` — app boots, console shows:
  ```
  🎬 [App] initialising...
  🔄 [App] WorkManager ready
  🚀 [App] launching
  ```
- [ ] Screen shows placeholder "Users" text centered on white background
- [ ] No red error screen, no exceptions in console
---

## Phase 2 — Database Schema (Drift)

### Dev Completed
- [x] `app_database.dart` — UsersTable, MoviesTable, SavedMoviesTable
- [x] `users_dao.dart` — watchAllUsersWithCount, insert, upsert, pending sync queries
- [x] `movies_dao.dart` — upsertMovie, getByTmdbId, getByIds
- [x] `saved_movies_dao.dart` — watchSaved, watchSaveCount, watchMatches, save/unsave, getUsersWhoSaved
- [x] `app_database.g.dart` — generated via build_runner
- [x] Database provider wired into Riverpod

### Your Checks
- [x] `dart run build_runner build --delete-conflicting-outputs` — no errors
- [x] `flutter analyze` — no errors
- [ ] `flutter run` — app still boots, no crash, same placeholder screen as Phase 1
- [ ] No migration errors in console (schema version 1, fresh install)

---

## Phase 3 — Networking Layer

### Dev Completed
- [x] `retry_interceptor.dart` — exponential backoff, retries on 5xx + connection errors
- [x] `auth_interceptor.dart` — Reqres API key header
- [x] `dio_client.dart` — two Dio instances (reqresDio, tmdbDio) as keepAlive Riverpod providers
- [x] `connectivity_service.dart` — finalized stream + isOnline providers

### Your Checks
- [x] `flutter analyze` — no errors
- [ ] `flutter run` — app boots, console shows:
  ```
  🌐 GET → /users?page=1   (before API key was set, showed 403)
  └─ ❌ GET /users?page=1 → 403 badResponse
  ```
- [ ] After setting real API key: `└─ ✅ GET /users?page=1 → 200  (Xms)`

---

## Phase 4 — Users Page & Add User

### Dev Completed
- [x] `user_model.dart` — Freezed model with JSON serialization
- [x] `users_api.dart` — fetchUsers (paginated), createUser
- [x] `users_repository.dart` — watchUsers stream, fetchAndCachePage
- [x] `users_provider.dart` — infinite scroll, loadMore, refresh
- [x] `users_page.dart` — list with shimmer, infinite scroll, staggered animations
- [x] `user_list_tile.dart` — avatar, name, save count badge
- [x] `add_user_page.dart` — form with name + movie taste fields
- [x] `add_user_provider.dart` — online/offline handling, WorkManager scheduling
- [x] GoRouter routes wired: `/` (users), `/add-user`, `/matches`

### Your Checks
- [x] `flutter analyze` — no errors
- [x] **App start** — console shows full startup + first fetch sequence:
  ```
  🎬 [App] initialising...
  🔄 [App] WorkManager ready
  🚀 [App] launching

  🚀 [App] starting up — loading users page 1
  👥 [Users] fetching page 1 from Reqres...
  ┌─ 🌐 GET → /users?page=1
  └─ ✅ GET /users?page=1 → 200  (312ms)
     📋 6 users  (page 1 of 2)
  💾 [Users] cached 6 users to DB  (page 1/2)
  📊 [Users] page 1/2 loaded — 6 users
  ```
- [ ] **Users list visible** — 6 avatars with names and email subtitles animate in with stagger
- [ ] **Shimmer** — briefly visible before first data arrives on a slow connection
- [ ] **Infinite scroll** — scroll to bottom, console shows:
  ```
  🔽 [Users] loading more — page 2/2
  👥 [Users] fetching page 2 from Reqres...
  └─ ✅ GET /users?page=2 → 200  (Xms)
  💾 [Users] cached 6 users to DB  (page 2/2)
  📊 [Users] page 2/2 loaded — 6 users
  ```
  Total 12 users now visible in list
- [ ] **Pull-to-refresh** — swipe down, console shows `🔄 [Users] pull-to-refresh triggered`, list reloads
- [ ] **Add User (online)** — tap FAB, fill Name + Movie Taste, submit. Console shows:
  ```
  👤 [AddUser] submitting "Alex" — online: true
  💾 [AddUser] saved locally  (localId=X, pendingSync=false)
  ┌─ 🌐 POST → /users
  └─ ✅ POST /users → 201  (Xms)
     👤 created user id=... name=Alex
  ☁️  [AddUser] synced to Reqres  (serverId=...)
  ✅ [AddUser] done
  ```
  New user appears at top of list immediately
- [ ] **Add User (offline)** — enable airplane mode, add another user. Console shows:
  ```
  👤 [AddUser] submitting "Sam" — online: false
  💾 [AddUser] saved locally  (localId=X, pendingSync=true)
  📵 [AddUser] offline — WorkManager task queued for localId=X
  ✅ [AddUser] done
  ```
  User appears in list with a `⟳` sync icon next to their name
- [ ] **Pending sync icon** — offline-created user shows small sync icon in tile
- [ ] **ReconnectingBar** — enable airplane mode, orange banner appears at top of Users page

---

## Phase 5 — Movies Page & Movie Detail

### Dev Completed
- [ ] `movie_model.dart` — Freezed model
- [ ] `movies_api.dart` — fetchTrending (paginated)
- [ ] `movies_repository.dart` — fetchTrending + cache, toggleSave, watchSaveCount
- [ ] `movies_provider.dart` — infinite scroll
- [ ] `movies_page.dart` — grid/list with shimmer, staggered animations
- [ ] `movie_card.dart` — poster, title, animated save count badge, save button
- [ ] `save_count_badge.dart` — AnimatedSwitcher scale transition
- [ ] `movie_detail_page.dart` — SliverAppBar, Hero animation, SaversRow
- [ ] GoRouter routes wired: `/users/:userId/movies`, `/movies/:tmdbId`

### Your Checks
- [ ] `flutter analyze` — no errors
- [ ] **Movies page** — tap any user → movies page loads, console shows:
  ```
  🎬 [Movies] fetching page 1 from TMDB...
  ┌─ 🌐 GET → /trending/movie/day?page=1
  └─ ✅ GET /trending/movie/day?page=1 → 200  (Xms)
     🎬 20 movies  (page 1 of X)
  💾 [Movies] cached 20 movies to DB
  ```
- [ ] Movie posters load with cached images (no broken image icons)
- [ ] **Save a movie** — tap bookmark on a movie card:
  - Badge animates from 0 → 1
  - Tap again → badge animates back to 0
- [ ] **Infinite scroll** — scroll to bottom of movies list, next page loads
- [ ] **Tap a movie card** — Hero animation plays, detail page opens
- [ ] **Detail page** — poster expands in SliverAppBar, overview text visible
- [ ] **Savers row** — after saving a movie as 1+ users, avatars appear on detail page with "X users want to watch this"

---

## Phase 6 — Saved Movies & Matches Pages

### Dev Completed
- [ ] `saved_movies_page.dart` — stream from DB, empty state with CTA
- [ ] `saved_movies_provider.dart`
- [ ] `matches_page.dart` — stream-driven, real-time updates
- [ ] `matches_provider.dart` — watchMatches from DB
- [ ] `match_movie_tile.dart` — "Top Pick" badge when all users saved
- [ ] GoRouter routes wired: `/users/:userId/saved`, `/matches`

### Your Checks
- [ ] `flutter analyze` — no errors
- [ ] **Saved Movies page** — tap a user → tap "Saved" → page shows only movies that user bookmarked
- [ ] **Empty state** — user with no saves sees empty state with "Browse Movies" CTA button
- [ ] **Save a movie then check** — go to movies, save one, go back to saved → it appears immediately (stream update, no refresh needed)
- [ ] **Matches page** — tap Matches in AppBar:
  - Empty state shown when fewer than 2 users saved any common movie
  - Save the same movie as 2 different users → movie appears in Matches instantly
- [ ] **Saver count** — matches list shows how many users saved each movie
- [ ] **Top Pick badge** — save the same movie as ALL users → "Top Pick" badge appears on that tile

---

## Phase 7 — Offline Sync (WorkManager)

### Dev Completed
- [ ] `sync_worker.dart` — reads pendingSync users, POSTs to Reqres, marks synced
- [ ] WorkManager initialized in `main.dart`
- [ ] Add user offline → syncs automatically on reconnect
- [ ] No duplicate entries after sync

### Your Checks
- [ ] `flutter analyze` — no errors
- [ ] **Offline add user** — enable airplane mode, add a user:
  - User appears in list with `⟳` sync icon
  - Console shows `📵 [AddUser] offline — WorkManager task queued`
- [ ] **Reconnect sync** — disable airplane mode:
  - Console shows sync worker firing, POST succeeds
  - `⟳` icon disappears from the user tile
  - `pendingSync` cleared in DB (no duplicate row)
- [ ] **No duplicates** — user appears exactly once after sync

---

## Phase 8 — UI Polish

### Dev Completed
- [ ] Shimmer loaders — UserListShimmer, MovieListShimmer, MovieDetailShimmer
- [ ] Staggered list animations (flutter_animate) on all list pages
- [ ] Hero animation — movie poster card → detail page
- [ ] AnimatedSwitcher on save count badge
- [ ] Smooth scroll behavior

### Your Checks
- [ ] **Shimmer on cold start** — kill app, reopen → shimmer skeleton visible for ~300ms before list appears
- [ ] **Stagger animation** — list items fade + slide in one by one from top
- [ ] **Hero transition** — tap a movie card → poster smoothly expands into detail page header; back → shrinks back
- [ ] **Save badge animation** — save count badge scales up/down with AnimatedSwitcher when count changes
- [ ] **Scroll feel** — no jank, no dropped frames on fast scroll through 20+ movies

---

## Phase 9 — Bad Connection Handling

### Dev Completed
- [ ] ReconnectingBar — shows on connectivity loss, hides on reconnect
- [ ] RetryInterceptor — silent retries with backoff on all API calls
- [ ] Error states shown when all retries exhausted

### Your Checks
- [ ] **ReconnectingBar** — enable airplane mode mid-use → orange bar appears at top of Users page with "No internet" message
- [ ] **Bar disappears** — re-enable wifi → bar hides automatically within ~2 seconds
- [ ] **Silent retry** — throttle network (Network Link Conditioner or Charles), make a request → console shows:
  ```
  🔁 RETRY #1 GET /users?page=1
  🔁 RETRY #2 GET /users?page=1
  └─ ✅ GET /users?page=1 → 200  (Xms)   ← succeeds on retry
  ```
- [ ] **All retries exhausted** — full offline, all 3 retries fail → error state shown in UI, no crash

---

## Phase 10 — Final Polish & Submission

### Dev Completed
- [ ] README updated with setup instructions + API key placeholders
- [ ] `.env.example` updated
- [ ] `flutter analyze` — clean
- [ ] Release APK builds successfully

### Your Checks
- [ ] `flutter build apk --release` — builds without errors, no debug logs in output
- [ ] APK installs and runs on a physical Android device
- [ ] All 6 pages reachable and functional end-to-end
- [ ] README has clear setup steps and API key instructions for the reviewer

---

## Summary

| Phase | Status | Your Sign-off |
|-------|--------|---------------|
| 1 — Setup & Architecture | ✅ Complete | ⬜ Pending |
| 2 — Database Schema | ✅ Complete | ⬜ Pending |
| 3 — Networking Layer | ✅ Complete | ⬜ Pending |
| 4 — Users Page & Add User | ✅ Complete | ⬜ Pending |
| 5 — Movies Page & Detail | ⬜ Not started | ⬜ Pending |
| 6 — Saved Movies & Matches | ⬜ Not started | ⬜ Pending |
| 7 — Offline Sync | ⬜ Not started | ⬜ Pending |
| 8 — UI Polish | ⬜ Not started | ⬜ Pending |
| 9 — Bad Connection Handling | ⬜ Not started | ⬜ Pending |
| 10 — Final Polish | ⬜ Not started | ⬜ Pending |
