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
- [x] `flutter run` — app boots, shows placeholder "Users" screen
- [x] Build confirmed on: `[ ] iOS` `[ ] Android`

Commit → "Phase 1 complete: Project setup, architecture, and core utilities implemented. Ready for database schema design."
---

## Phase 2 — Database Schema (Drift)

### Dev Completed
- [ ] `app_database.dart` — UsersTable, MoviesTable, SavedMoviesTable
- [ ] `users_dao.dart` — watchAllUsersWithCount, insert, upsert, pending sync queries
- [ ] `movies_dao.dart` — upsertMovie, getByTmdbId, getByIds
- [ ] `saved_movies_dao.dart` — watchSaved, watchSaveCount, watchMatches, save/unsave, getUsersWhoSaved
- [ ] `app_database.g.dart` — generated via build_runner
- [ ] Database provider wired into Riverpod

### Your Checks
- [ ] `dart run build_runner build --delete-conflicting-outputs` — no errors
- [ ] `flutter analyze` — no errors
- [ ] `flutter run` — app still boots cleanly

---

## Phase 3 — Networking Layer

### Dev Completed
- [ ] `retry_interceptor.dart` — exponential backoff, retries on 5xx + connection errors
- [ ] `auth_interceptor.dart` — Reqres API key header
- [ ] `dio_client.dart` — two Dio instances (reqresDio, tmdbDio) as keepAlive Riverpod providers
- [ ] `connectivity_service.dart` — finalized stream + isOnline providers

### Your Checks
- [ ] `flutter analyze` — no errors
- [ ] `flutter run` — app boots cleanly

---

## Phase 4 — Users Page & Add User

### Dev Completed
- [ ] `user_model.dart` — Freezed model with JSON serialization
- [ ] `users_api.dart` — fetchUsers (paginated), createUser
- [ ] `users_repository.dart` — watchUsers stream, fetchAndCachePage
- [ ] `users_provider.dart` — infinite scroll, loadMore, refresh
- [ ] `users_page.dart` — list with shimmer, infinite scroll, staggered animations
- [ ] `user_list_tile.dart` — avatar, name, save count badge
- [ ] `add_user_page.dart` — form with name + movie taste fields
- [ ] `add_user_provider.dart` — online/offline handling, WorkManager scheduling
- [ ] GoRouter routes wired: `/` (users), `/add-user`, `/matches`

### Your Checks
- [ ] `flutter analyze` — no errors
- [ ] `flutter run` — Users page loads, shows list from Reqres API
- [ ] Add user online — appears in list immediately
- [ ] Add user offline — appears locally, pending sync indicator
- [ ] Infinite scroll — loads next page on scroll

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
- [ ] `flutter run` — Movies page loads trending movies
- [ ] Save/unsave movie — badge animates, count updates in real time
- [ ] Tap movie — Hero animation to detail page
- [ ] Detail page — shows savers row with avatars

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
- [ ] `flutter run` — Saved Movies page shows correct movies per user
- [ ] Matches page — shows movies saved by 2+ users
- [ ] Top Pick badge — appears when all users saved the same movie
- [ ] Real-time update — saving a movie updates Matches instantly

---

## Phase 7 — Offline Sync (WorkManager)

### Dev Completed
- [ ] `sync_worker.dart` — reads pendingSync users, POSTs to Reqres, marks synced
- [ ] WorkManager initialized in `main.dart`
- [ ] Add user offline → syncs automatically on reconnect
- [ ] No duplicate entries after sync

### Your Checks
- [ ] `flutter analyze` — no errors
- [ ] Add user with airplane mode ON → user appears locally
- [ ] Turn airplane mode OFF → user syncs, `pendingSync` cleared
- [ ] No duplicate users after sync

---

## Phase 8 — UI Polish

### Dev Completed
- [ ] Shimmer loaders — UserListShimmer, MovieListShimmer, MovieDetailShimmer
- [ ] Staggered list animations (flutter_animate) on all list pages
- [ ] Hero animation — movie poster card → detail page
- [ ] AnimatedSwitcher on save count badge
- [ ] Smooth scroll behavior

### Your Checks
- [ ] `flutter run` — shimmer shows on initial load
- [ ] List items animate in with stagger
- [ ] Hero transition is smooth
- [ ] No jank on scroll

---

## Phase 9 — Bad Connection Handling

### Dev Completed
- [ ] ReconnectingBar — shows on connectivity loss, hides on reconnect
- [ ] RetryInterceptor — silent retries with backoff on all API calls
- [ ] Error states shown when all retries exhausted

### Your Checks
- [ ] Enable airplane mode mid-use → ReconnectingBar appears
- [ ] Disable airplane mode → bar disappears, data reloads
- [ ] Throttle network → retries happen silently, no crash

---

## Phase 10 — Final Polish & Submission

### Dev Completed
- [ ] README updated with setup instructions + API key placeholders
- [ ] `.env.example` updated
- [ ] `flutter analyze` — clean
- [ ] Release APK builds successfully

### Your Checks
- [ ] `flutter build apk --release` — builds without errors
- [ ] APK installs and runs on device
- [ ] All pages working end-to-end
- [ ] README is clear for reviewer

---

## Summary

| Phase | Status | Your Sign-off |
|-------|--------|---------------|
| 1 — Setup & Architecture | ✅ Complete | ⬜ Pending |
| 2 — Database Schema | ⬜ Not started | ⬜ Pending |
| 3 — Networking Layer | ⬜ Not started | ⬜ Pending |
| 4 — Users Page & Add User | ⬜ Not started | ⬜ Pending |
| 5 — Movies Page & Detail | ⬜ Not started | ⬜ Pending |
| 6 — Saved Movies & Matches | ⬜ Not started | ⬜ Pending |
| 7 — Offline Sync | ⬜ Not started | ⬜ Pending |
| 8 — UI Polish | ⬜ Not started | ⬜ Pending |
| 9 — Bad Connection Handling | ⬜ Not started | ⬜ Pending |
| 10 — Final Polish | ⬜ Not started | ⬜ Pending |
