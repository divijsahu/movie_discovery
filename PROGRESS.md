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
- [x] `main.dart` — ProviderScope + WidgetsFlutterBinding + WorkManager init
- [x] `app.dart` — MaterialApp.router with GoRouter + light/dark theme
- [x] `core/router/` — `app_router.dart`, `route_names.dart`
- [x] `core/error/` — `failures.dart` (sealed, with `fromDio`), `result.dart`
- [x] `core/network/api_constants.dart` — Reqres + TMDB + OMDB constants
- [x] `core/utils/connectivity_service.dart` — stream + future providers
- [x] `core/utils/validators.dart`
- [x] `core/utils/extensions/context_ext.dart`
- [x] `core/sync/sync_worker.dart` — WorkManager stub
- [x] `design_system/` — colors, text styles, spacing, radius, theme
- [x] `design_system/widgets/` — PrimaryButton, ShimmerBox, EmptyState, ReconnectingBar, AppNetworkImage, AppCard

### Your Checks
- [x] `flutter pub get` — resolves cleanly
- [x] `flutter analyze` — no errors
- [x] `flutter run` — app boots, console shows:
  ```
  🎬 [App] initialising...
  🔄 [App] WorkManager ready
  🚀 [App] launching
  ```
- [x] Screen shows placeholder "Users" text centered on white background
- [x] No red error screen, no exceptions in console

---

## Phase 2 — Database Schema (Drift)

### Dev Completed
- [x] `app_database.dart` — UsersTable, MoviesTable, SavedMoviesTable
- [x] `users_dao.dart` — watchAllUsersWithCount, insert, upsert, pending sync queries, markPendingSync
- [x] `movies_dao.dart` — upsertMovie, getByTmdbId, getByIds
- [x] `saved_movies_dao.dart` — watchSaved, watchSaveCount, watchMatches, save/unsave, getUsersWhoSaved
- [x] `app_database.g.dart` — generated via build_runner
- [x] Database provider wired into Riverpod
- [x] Schema v2 migration — deduplicates remote users by serverId

### Your Checks
- [x] `dart run build_runner build --delete-conflicting-outputs` — no errors
- [x] `flutter analyze` — no errors
- [x] `flutter run` — app still boots, no crash
- [x] No migration errors in console (schema version 2)

---

## Phase 3 — Networking Layer

### Dev Completed
- [x] `retry_interceptor.dart` — exponential backoff, retries on 5xx + connection errors, skips POST/PATCH/PUT
- [x] `auth_interceptor.dart` — Reqres API key header
- [x] `logging_interceptor.dart` — structured ┌─/└─ logs with timing, response summaries, api keys hidden
- [x] `dio_client.dart` — reqresDio, tmdbDio, omdbDio as Riverpod providers
- [x] `connectivity_service.dart` — stream + isOnline providers

### Your Checks
- [x] `flutter analyze` — no errors
- [x] `flutter run` — console shows structured request/response logs
- [x] Real API key set — `└─ ✅ GET /users?page=1 → 200  (Xms)`

---

## Phase 4 — Users Page & Add User

### Dev Completed
- [x] `user_model.dart` — Freezed model with JSON serialization
- [x] `users_api.dart` — fetchUsers (paginated), createUser
- [x] `users_repository.dart` — watchUsers stream, fetchAndCachePage
- [x] `users_provider.dart` — infinite scroll, loadMore, refresh
- [x] `users_page.dart` — list with shimmer, infinite scroll, staggered animations (keyed by ID)
- [x] `user_list_tile.dart` — avatar, name, save count badge (tappable → saved movies), pending sync icon
- [x] `add_user_page.dart` — form with name + movie taste fields
- [x] `add_user_provider.dart` — online/offline handling, WorkManager scheduling with iOS graceful fallback
- [x] GoRouter routes wired: `/` (users), `/add-user`
- [x] Fix: upsertRemoteUser checks serverId before insert — no duplicate rows on restart
- [x] Fix: animation keyed by item ID — no blank tiles on scroll up

### Your Checks
- [x] `flutter analyze` — no errors
- [x] **App start** — console shows full startup + first fetch sequence
- [x] **Users list visible** — avatars with names animate in with stagger
- [x] **No duplicates** — same 6 Reqres users shown on every restart
- [x] **Infinite scroll** — scroll to bottom loads page 2
- [x] **Pull-to-refresh** — swipe down reloads list
- [x] **Add User (online)** — appears at top of list, synced to Reqres
- [x] **Add User (offline)** — appears locally with `⟳` sync icon
- [x] **ReconnectingBar** — orange banner on airplane mode

---

## Phase 5 — Movies Page & Movie Detail

### Dev Completed
- [x] `movie_model.dart` — Freezed model
- [x] `movies_api.dart` — fetchTrending (paginated), fetchDetail
- [x] `omdb_api.dart` — OMDB fallback with curated search terms, maps to MovieModel
- [x] `movies_repository.dart` — TMDB first → OMDB fallback → DB cache chain for both trending and detail
- [x] `movies_provider.dart` — MoviesState record (movies + error), infinite scroll, error surfaced only when list empty
- [x] `movies_page.dart` — shimmer, staggered animations, infinite scroll, accurate error state with Retry button
- [x] `movie_card.dart` — poster Hero, title, animated save count badge, save button
- [x] `save_count_badge.dart` — AnimatedSwitcher scale transition
- [x] `movie_detail_page.dart` — SliverAppBar, Hero animation, SaversRow, shimmer, DB cache fallback
- [x] `movie_list_shimmer.dart` — skeleton loader
- [x] GoRouter routes wired: `/users/:userId/movies`, `/movies/:tmdbId?userId=`
- [x] Fix: POST not retried by RetryInterceptor (prevents duplicate mutations)
- [x] Fix: error state shows actual API message, not hardcoded text

### Your Checks
- [x] `flutter analyze` — no errors
- [x] **Movies page** — loads trending movies from TMDB (or OMDB fallback)
- [x] **Error state** — TMDB down shows "Could not load movies" + actual error + Retry button
- [x] **Save a movie** — badge animates 0 → 1, tap again → 0
- [x] **Infinite scroll** — next page loads on scroll
- [x] **Hero animation** — tap card → poster expands into detail page
- [x] **Detail page** — overview visible, savers row shows avatars

---

## Phase 6 — Saved Movies & Matches Pages

### Dev Completed
- [x] `saved_movies_provider.dart` — StreamProvider.family watching DB per userId
- [x] `saved_movies_page.dart` — stream from DB, empty state with Browse CTA, staggered animations, unsave from list
- [x] `matches_provider.dart` — watchMatches stream + totalUsersCount stream
- [x] `matches_page.dart` — stream-driven real-time updates, Top Pick badge, staggered animations
- [x] `match_movie_tile.dart` — poster, saver count, Top Pick badge (🔥 green)
- [x] GoRouter routes wired: `/users/:userId/saved`, `/matches`
- [x] UserListTile save count badge is now tappable → navigates to saved movies page

### Your Checks
- [ ] `flutter analyze` — no errors
- [ ] **Saved Movies page** — tap save count badge on a user → page shows only that user's bookmarked movies
- [ ] **Empty state** — user with no saves sees empty state with "Browse Movies" button that navigates to their movies page
- [ ] **Real-time update** — save a movie → go back to saved → it appears instantly (no refresh needed)
- [ ] **Unsave from list** — tap bookmark icon on saved movies page → movie disappears immediately
- [ ] **Matches page** — tap 🔥 Matches in AppBar:
  - Empty state when no common saves yet
  - Save same movie as 2 different users → appears in Matches instantly
- [ ] **Saver count** — each match tile shows "X people want to watch"
- [ ] **Top Pick badge** — save same movie as ALL users → 🔥 Top Pick badge appears

---

## Phase 7 — Offline Sync (WorkManager)

### Dev Completed
- [x] `sync_worker.dart` — `runPendingUserSync()` opens DB + Dio directly (no Riverpod), reads pendingSync users, POSTs each to Reqres, marks synced
- [x] `callbackDispatcher` delegates to `runPendingUserSync()` — WorkManager fires this in a background isolate
- [x] Launch sync in `main.dart` — calls `runPendingUserSync()` on startup if online (covers iOS where WorkManager background tasks need Info.plist)
- [x] Failed individual syncs leave `pendingSync=true` — WorkManager retries the task automatically
- [x] No duplicate entries after sync — `upsertRemoteUser` checks serverId before insert

### Your Checks
- [x] `flutter analyze` — no errors
- [ ] **Offline add user** — enable airplane mode, add a user:
  - User appears in list with `⟳` sync icon
  - Console shows `📵 [AddUser] offline — WorkManager task queued`
- [ ] **Relaunch online** — kill app, re-enable wifi, reopen:
  - Console shows:
    ```
    🔄 [Sync] running pending user sync...
    🔄 [Sync] 1 pending user(s) to sync
    ☁️  [Sync] synced "Sam" → serverId=...
    ✅ [Sync] done
    ```
  - `⟳` icon disappears from the user tile
- [ ] **No duplicates** — user appears exactly once after sync

---

## Phase 8 — UI Polish

### Dev Completed
- [x] Shimmer loaders — UserListShimmer, MovieListShimmer, MovieDetailShimmer (all dark-mode aware)
- [x] Staggered list animations (flutter_animate) on all list pages, keyed by item ID
- [x] Hero animation — movie poster card → detail page
- [x] AnimatedSwitcher on save count badge
- [x] ReconnectingBar — animated slide+fade in/out instead of abrupt appear
- [x] BouncingScrollPhysics on all list views
- [x] Fix: isSavedProvider invalidated after toggleSave — bookmark icon updates immediately
- [x] Fix: OMDB poster URLs handled correctly — full https:// URLs not prefixed with TMDB base

### Your Checks
- [ ] **Shimmer on cold start** — uninstall app, reinstall, open → shimmer skeleton visible before list appears
- [ ] **Dark mode shimmer** — switch device to dark mode → shimmer uses dark grey, not white
- [ ] **Stagger animation** — list items fade + slide in one by one from top
- [ ] **Hero transition** — tap a movie card → poster smoothly expands into detail page header; back → shrinks back
- [ ] **Save badge animation** — tap bookmark → badge scales 0→1, tap again → scales back to 0
- [ ] **Bookmark icon updates** — tap bookmark on movie card or detail page → icon flips immediately (no stale state)
- [ ] **ReconnectingBar** — enable airplane mode → bar slides down smoothly; re-enable wifi → bar slides up and fades out
- [ ] **Scroll feel** — all lists bounce at top/bottom on iOS
- [ ] **OMDB posters** — when TMDB is down and OMDB fallback is used, movie posters load correctly

---

## Phase 9 — Bad Connection Handling

### Dev Completed
- [x] ReconnectingBar — animated slide+fade, shows on connectivity loss, hides on reconnect
- [x] ReconnectingBar added to all 4 pages (Users, Movies, Saved Movies, Matches)
- [x] RetryInterceptor — silent retries with exponential backoff on all GET calls
- [x] Error states shown when all retries exhausted (Movies page + Detail page)
- [x] Retry log moved to onRequest — fires before the retry attempt, not after

### Your Checks
- [x] **ReconnectingBar** — enable airplane mode mid-use → orange bar slides down on all pages
- [x] **Bar disappears** — re-enable wifi → bar slides up and fades out within ~2 seconds
- [ ] **Silent retry** — throttle network, make a request → console shows:
  ```
  ┌─ 🌐 GET → /trending/movie/day?page=1
  ├─ 🔁 RETRY #1 GET /trending/movie/day?page=1
  ├─ 🔁 RETRY #2 GET /trending/movie/day?page=1
  └─ ✅ GET /trending/movie/day?page=1 → 200  (Xms)
  ```
- [ ] **All retries exhausted** — full offline, 3 retries fail → error state shown, no crash

---

## Phase 10 — Final Polish & Submission

### Dev Completed
- [x] README rewritten — setup instructions, architecture overview, API key table, console output example, build commands
- [x] `.env.example` updated — only the 3 keys this project actually needs
- [x] `flutter analyze` — clean

### Your Checks
- [ ] `flutter build apk --release` — builds without errors, no debug logs in output
- [ ] APK installs and runs on a physical Android device
- [ ] All 6 pages reachable and functional end-to-end
- [ ] README has clear setup steps and API key instructions for the reviewer

---

## Summary

| Phase | Status | Your Sign-off |
|-------|--------|---------------|
| 1 — Setup & Architecture | ✅ Complete | ✅ Verified |
| 2 — Database Schema | ✅ Complete | ✅ Verified |
| 3 — Networking Layer | ✅ Complete | ✅ Verified |
| 4 — Users Page & Add User | ✅ Complete | ✅ Verified |
| 5 — Movies Page & Detail | ✅ Complete | ✅ Verified |
| 6 — Saved Movies & Matches | ✅ Complete | ⬜ Pending |
| 7 — Offline Sync | ✅ Complete | ⬜ Pending |
| 8 — UI Polish | ✅ Complete | ⬜ Pending |
| 9 — Bad Connection Handling | ✅ Complete | ⬜ Pending |
| 10 — Final Polish | ✅ Complete | ⬜ Pending |
