# 🎬 Movie Discovery

A production-quality Flutter app built for the Platform Commons Engineering Assignment (2026).

Users browse trending movies, save the ones they want to watch, and see which movies their group has in common — all with full offline support.

---

## 📱 Pages

| Page | Description |
|---|---|
| **Users** | List of all users with their saved movie count. Tap a user to browse movies as them. |
| **Add User** | Form to add a new user. Works offline — syncs automatically when back online. |
| **Movies** | Trending movies from TMDB (falls back to OMDB if TMDB is unavailable). Save/unsave with animated badge. |
| **Movie Detail** | Full poster, overview, release date, and a row of avatars showing who saved it. |
| **Saved Movies** | All movies bookmarked by a specific user. Unsave directly from the list. |
| **Matches** | Movies saved by 2+ users, ordered by popularity. 🔥 Top Pick badge when every user saved the same movie. |

---

## 🚀 Setup

### 1. Install dependencies

```bash
flutter pub get
```

### 2. Add API keys

Open `lib/core/network/api_constants.dart` and replace the placeholders:

```dart
// Reqres — free key from https://app.reqres.in/api-keys
static const reqresApiKey = 'YOUR_REQRES_KEY';

// TMDB — free key from https://www.themoviedb.org/settings/api (use "API Key v3 auth")
static const tmdbApiKey = 'YOUR_TMDB_KEY';

// OMDB — free key from https://www.omdbapi.com/apikey.aspx (used as TMDB fallback)
static const omdbApiKey = 'YOUR_OMDB_KEY';
```

### 3. Run code generation

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4. Run the app

```bash
flutter run
```

---

## 🏗️ Architecture

```
lib/
├── core/
│   ├── error/          # Result<T> type + sealed AppFailure hierarchy
│   ├── network/        # Dio clients, interceptors (retry, auth, logging)
│   ├── router/         # GoRouter + RouteNames
│   ├── storage/        # Drift database — tables, DAOs
│   ├── sync/           # WorkManager offline sync worker
│   └── utils/          # Connectivity, validators, context extensions
│
├── design_system/      # Colors, typography, spacing, radius, theme
│   └── widgets/        # AppCard, AppNetworkImage, ShimmerBox, ReconnectingBar, SaveCountBadge
│
├── features/
│   ├── users/          # Users list + Add User form
│   ├── movies/         # Trending movies + Movie Detail
│   ├── saved_movies/   # Per-user saved movies
│   └── matches/        # Movies saved by 2+ users
│
├── app.dart            # MaterialApp.router
└── main.dart           # Entry point — WorkManager init + launch sync
```

**Stack:** Flutter · Riverpod · GoRouter · Dio · Drift (SQLite) · WorkManager · Freezed · flutter_animate

---

## ✨ Key Features

### Offline-first
- All data is cached to a local Drift (SQLite) database on first fetch
- Users added offline are stored locally with `pendingSync=true`
- On next launch with connectivity, pending users are POSTed to Reqres automatically
- The UI always reads from the local DB — network is just a sync mechanism

### TMDB → OMDB fallback
- Movies are fetched from TMDB first
- If TMDB is unavailable (timeout, outage), the app silently falls back to OMDB
- The same `MovieModel` and DB cache are used for both — the UI never knows the difference

### Real-time streams
- The users list, saved movies, and matches pages are all powered by Drift `Stream`s
- Saving or unsaving a movie updates every affected page instantly with no manual refresh

### Bad connection handling
- `RetryInterceptor` silently retries GET requests up to 3 times with exponential backoff (1s → 3s → 6s)
- POST/PATCH/PUT are never retried to prevent duplicate mutations
- `ReconnectingBar` slides in on all pages when connectivity is lost, slides out when restored
- Error states with a Retry button are shown only when all retries are exhausted and the DB cache is empty

---

## 🔑 API Keys

| Service | Where to get it | Used for |
|---|---|---|
| Reqres | [app.reqres.in/api-keys](https://app.reqres.in/api-keys) | User list + create user |
| TMDB | [themoviedb.org/settings/api](https://www.themoviedb.org/settings/api) | Trending movies + detail |
| OMDB | [omdbapi.com/apikey.aspx](https://www.omdbapi.com/apikey.aspx) | Movie fallback when TMDB is down |

All three are free. OMDB is optional — the app works without it, but the movies page will show an error when TMDB is unavailable instead of falling back gracefully.

---

## 🗄️ Database Schema

```
UsersTable          — id, serverId, name, movieTaste, email, avatarUrl, pendingSync, createdAt
MoviesTable         — id, tmdbId (unique), title, overview, posterPath, releaseDate, popularity
SavedMoviesTable    — id, userId → UsersTable, movieId → MoviesTable, savedAt
                      unique(userId, movieId) — no duplicate saves
```

Schema version: **2** (v2 migration deduplicates remote users by serverId)

---

## 📋 Console Output

On a clean launch with all API keys set:

```
🎬 [App] initialising...
🔄 [App] WorkManager ready
🚀 [App] launching

🚀 [App] starting up — loading users page 1
👥 [Users] fetching page 1 from Reqres...
┌─ 🌐 GET → /api/users?page=1
└─ ✅ GET /api/users?page=1 → 200  (312ms)
   📋 6 users  (page 1 of 2)
💾 [Users] cached 6 users to DB  (page 1/2)
📊 [Users] page 1/2 loaded — 6 users

🎬 [Movies] starting up — loading page 1
🎬 [Movies] fetching page 1 from TMDB...
┌─ 🌐 GET → /trending/movie/day?language=en-US&page=1
└─ ✅ GET /trending/movie/day?language=en-US&page=1 → 200  (890ms)
   🎬 20 movies  (page 1 of X)
💾 [Movies] cached 20 movies to DB  (page 1/X)
📊 [Movies] page 1/X loaded — 20 movies
```

---

## 📦 Build

```bash
# Analyze
flutter analyze

# Release APK
flutter build apk --release

# Release iOS
flutter build ios --release
```
