# 🧩 Flutter Medium App Architecture — 2026 Edition

> A practical, developer-friendly architecture for medium-sized Flutter apps — SaaS MVPs, client apps, e-commerce, booking systems, and team projects with 2–8 developers.

---

## Who Is This For?

| ✅ Perfect Match | ❌ Not For |
|---|---|
| 2–8 developer teams | Solo weekend projects |
| 10–50 screens | 100+ screen enterprise products |
| SaaS MVPs & client products | Multi-team, multi-repo monorepos |
| Startup → scale-up phase | Government / banking grade apps |
| Apps that need to grow | Throwaway prototypes |

---

## Table of Contents

1. [Core Philosophy](#1-core-philosophy)
2. [Folder Structure](#2-folder-structure)
3. [Layer Breakdown](#3-layer-breakdown)
4. [Design System (Simplified)](#4-design-system-simplified)
5. [Feature Module Structure](#5-feature-module-structure)
6. [State Management](#6-state-management)
7. [Routing](#7-routing)
8. [Networking](#8-networking)
9. [Error Handling](#9-error-handling)
10. [Local Storage](#10-local-storage)
11. [Testing Strategy](#11-testing-strategy)
12. [Security Basics](#12-security-basics)
13. [Recommended Tech Stack](#13-recommended-tech-stack)
14. [Common Mistakes to Avoid](#14-common-mistakes-to-avoid)
15. [Quick Start Checklist](#15-quick-start-checklist)

---

## 1. Core Philosophy

### Keep It Simple, Keep It Scalable

Medium apps sit in a sweet spot: they're complex enough to need structure, but not so large that you need a full enterprise setup. The goal is:

- **Low boilerplate** — You shouldn't write 5 files just to add a button
- **Clear separation** — UI, logic, and data never mix
- **Easy onboarding** — A new dev understands the project in one day
- **Growable** — Can evolve into the enterprise structure if needed

### The 3-Layer Rule

Every piece of code lives in exactly one of three places:

```
┌───────────────────────────┐
│       Presentation         │  Screens, Widgets, Providers
├───────────────────────────┤
│         Logic              │  Use Cases / Services
├───────────────────────────┤
│          Data              │  APIs, Local DB, Repositories
└───────────────────────────┘
```

> No skipping layers. UI never calls an API directly. Data never imports a widget.

---

## 2. Folder Structure

```
lib/
│
├── core/
│   ├── network/
│   │   ├── dio_client.dart           # Dio setup
│   │   ├── api_constants.dart        # Base URL, endpoints
│   │   └── interceptors/
│   │       ├── auth_interceptor.dart
│   │       └── logging_interceptor.dart
│   │
│   ├── storage/
│   │   ├── secure_storage.dart       # Tokens
│   │   └── local_storage.dart        # Hive / SharedPreferences
│   │
│   ├── router/
│   │   ├── app_router.dart
│   │   └── route_names.dart
│   │
│   ├── error/
│   │   ├── failures.dart
│   │   └── app_exception.dart
│   │
│   └── utils/
│       ├── validators.dart
│       ├── date_helper.dart
│       └── extensions/
│           ├── context_ext.dart
│           ├── string_ext.dart
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
│       │   ├── primary_button.dart
│       │   └── secondary_button.dart
│       ├── inputs/
│       │   └── app_text_field.dart
│       ├── loaders/
│       │   └── app_loader.dart
│       ├── app_card.dart
│       ├── empty_state.dart
│       └── error_widget.dart
│
├── features/
│   │
│   ├── auth/
│   │   ├── data/
│   │   │   ├── auth_api.dart         # API calls
│   │   │   ├── auth_repository.dart  # Implementation
│   │   │   └── models/
│   │   │       └── user_model.dart   # Freezed model
│   │   ├── logic/
│   │   │   ├── auth_provider.dart    # Riverpod notifier
│   │   │   └── auth_state.dart
│   │   └── ui/
│   │       ├── login_screen.dart
│   │       ├── register_screen.dart
│   │       └── widgets/
│   │           └── login_form.dart
│   │
│   ├── home/
│   ├── profile/
│   ├── settings/
│   └── [your_feature]/
│
├── shared/
│   ├── models/
│   │   └── pagination.dart
│   └── widgets/
│       ├── paginated_list.dart
│       └── async_widget.dart
│
├── app.dart                          # MaterialApp root
└── main.dart                         # Entry point
```

### Why This Structure Works

- `core/` — Infrastructure, used everywhere, no business logic
- `design_system/` — All visual tokens and reusable UI
- `features/` — Self-contained feature folders (each is its own mini-app)
- `shared/` — Only things genuinely used in 2+ features

---

## 3. Layer Breakdown

### core/ — Infrastructure Only

The core folder handles setup and utilities. It should have **zero business logic**.

```dart
// core/network/api_constants.dart
class ApiConstants {
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://api.yourapp.com/v1',
  );

  // Endpoints
  static const String login         = '/auth/login';
  static const String register      = '/auth/register';
  static const String refreshToken  = '/auth/refresh';
  static const String userProfile   = '/user/profile';
}
```

```dart
// core/utils/extensions/context_ext.dart
extension ContextExt on BuildContext {
  ThemeData get theme      => Theme.of(this);
  ColorScheme get colors   => Theme.of(this).colorScheme;
  TextTheme get textTheme  => Theme.of(this).textTheme;

  double get screenWidth   => MediaQuery.of(this).size.width;
  double get screenHeight  => MediaQuery.of(this).size.height;
  bool get isMobile        => screenWidth < 600;
  bool get isTablet        => screenWidth >= 600;

  void showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: isError ? colors.error : colors.primary,
    ));
  }
}
```

### features/ — Business Logic Lives Here

Each feature folder is a mini vertical slice with three sub-layers:

```
features/auth/
├── data/          → API calls, models, repository
├── logic/         → Riverpod providers, state
└── ui/            → Screens and feature-specific widgets
```

---

## 4. Design System (Simplified)

For medium apps, you don't need full atomic design. You need **design tokens** + **a small widget library**.

### Tokens — The Non-Negotiables

```dart
// design_system/app_colors.dart
class AppColors {
  // Primary brand
  static const primary      = Color(0xFF6C63FF);
  static const primaryLight = Color(0xFF9D97FF);
  static const primaryDark  = Color(0xFF4A42CC);

  // Semantic
  static const success = Color(0xFF22C55E);
  static const error   = Color(0xFFEF4444);
  static const warning = Color(0xFFF59E0B);
  static const info    = Color(0xFF3B82F6);

  // Neutrals
  static const white      = Color(0xFFFFFFFF);
  static const grey50     = Color(0xFFF8FAFC);
  static const grey200    = Color(0xFFE2E8F0);
  static const grey500    = Color(0xFF64748B);
  static const grey900    = Color(0xFF0F172A);

  // Surfaces
  static const background     = Color(0xFFF8FAFC);
  static const surface        = Color(0xFFFFFFFF);
  static const surfaceDark    = Color(0xFF1E293B);
}
```

```dart
// design_system/app_spacing.dart
class AppSpacing {
  static const double xs  = 4.0;
  static const double sm  = 8.0;
  static const double md  = 16.0;
  static const double lg  = 24.0;
  static const double xl  = 32.0;
  static const double xxl = 48.0;

  // Common paddings
  static const EdgeInsets screen = EdgeInsets.all(md);
  static const EdgeInsets card   = EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );
}
```

```dart
// design_system/app_text_styles.dart
class AppTextStyles {
  static const String _font = 'Inter';

  static const h1 = TextStyle(
    fontFamily: _font, fontSize: 32,
    fontWeight: FontWeight.w700, height: 1.2,
  );
  static const h2 = TextStyle(
    fontFamily: _font, fontSize: 24,
    fontWeight: FontWeight.w600, height: 1.3,
  );
  static const h3 = TextStyle(
    fontFamily: _font, fontSize: 20,
    fontWeight: FontWeight.w600, height: 1.3,
  );
  static const body = TextStyle(
    fontFamily: _font, fontSize: 16,
    fontWeight: FontWeight.w400, height: 1.5,
  );
  static const bodySmall = TextStyle(
    fontFamily: _font, fontSize: 14,
    fontWeight: FontWeight.w400, height: 1.5,
  );
  static const caption = TextStyle(
    fontFamily: _font, fontSize: 12,
    fontWeight: FontWeight.w400, height: 1.4,
  );
  static const label = TextStyle(
    fontFamily: _font, fontSize: 14,
    fontWeight: FontWeight.w500, height: 1.4,
  );
}
```

```dart
// design_system/app_radius.dart
class AppRadius {
  static const double sm  = 6.0;
  static const double md  = 12.0;
  static const double lg  = 16.0;
  static const double xl  = 24.0;
  static const double full = 999.0;

  static BorderRadius get smAll  => BorderRadius.circular(sm);
  static BorderRadius get mdAll  => BorderRadius.circular(md);
  static BorderRadius get lgAll  => BorderRadius.circular(lg);
}
```

### Theme Setup

```dart
// design_system/app_theme.dart
class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      surface: AppColors.surface,
      background: AppColors.background,
      error: AppColors.error,
    ),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.mdAll,
        side: const BorderSide(color: AppColors.grey200),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: AppRadius.mdAll),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
        textStyle: AppTextStyles.label.copyWith(fontSize: 16),
      ),
    ),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      surface: AppColors.surfaceDark,
    ),
    // Mirror light theme overrides for dark
  );
}
```

### Reusable Widgets

```dart
// design_system/widgets/buttons/primary_button.dart
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
          : Text(label),
    );
  }
}
```

```dart
// design_system/widgets/inputs/app_text_field.dart
class AppTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: AppSpacing.xs),
        TextFormField(
          controller: controller,
          validator: validator,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
```

```dart
// design_system/widgets/app_card.dart
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.mdAll,
        child: Padding(
          padding: padding ?? AppSpacing.card,
          child: child,
        ),
      ),
    );
  }
}
```

---

## 5. Feature Module Structure

### The `data/` Sub-Layer

Handles API calls and data models. This is the only place that knows about HTTP or databases.

```dart
// features/auth/data/models/user_model.dart
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String name,
    required String email,
    String? avatarUrl,
    required String role,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
```

```dart
// features/auth/data/auth_api.dart
class AuthApi {
  final Dio _dio;
  AuthApi(this._dio);

  Future<UserModel> login(String email, String password) async {
    final response = await _dio.post(
      ApiConstants.login,
      data: {'email': email, 'password': password},
    );
    return UserModel.fromJson(response.data['user']);
  }

  Future<void> logout() async {
    await _dio.post('/auth/logout');
  }
}
```

```dart
// features/auth/data/auth_repository.dart
class AuthRepository {
  final AuthApi _api;
  final SecureStorage _storage;

  AuthRepository(this._api, this._storage);

  Future<Result<UserModel>> login(String email, String password) async {
    try {
      final user = await _api.login(email, password);
      return Success(user);
    } on DioException catch (e) {
      return Failure(AppFailure.fromDio(e));
    } catch (e) {
      return Failure(AppFailure.unknown(e.toString()));
    }
  }

  Future<void> logout() async {
    await _api.logout();
    await _storage.clearAll();
  }
}
```

### The `logic/` Sub-Layer

Riverpod providers and state classes. The bridge between data and UI.

```dart
// features/auth/logic/auth_state.dart
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial()              = _Initial;
  const factory AuthState.loading()              = _Loading;
  const factory AuthState.authenticated(UserModel user) = _Authenticated;
  const factory AuthState.unauthenticated()      = _Unauthenticated;
  const factory AuthState.error(String message)  = _Error;
}
```

```dart
// features/auth/logic/auth_provider.dart
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() => const AuthState.initial();

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  Future<void> login(String email, String password) async {
    state = const AuthState.loading();

    final result = await _repo.login(email, password);

    state = result.when(
      success: (user) => AuthState.authenticated(user),
      failure: (failure) => AuthState.error(failure.message),
    );
  }

  Future<void> logout() async {
    await _repo.logout();
    state = const AuthState.unauthenticated();
    ref.read(appRouterProvider).go(RouteNames.login);
  }
}

// Providers for dependencies
@riverpod
AuthApi authApi(Ref ref) => AuthApi(ref.watch(dioProvider));

@riverpod
AuthRepository authRepository(Ref ref) => AuthRepository(
      ref.watch(authApiProvider),
      ref.watch(secureStorageProvider),
    );
```

### The `ui/` Sub-Layer

Screens and feature-specific widgets only. No API calls, no business logic.

```dart
// features/auth/ui/login_screen.dart
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen for side effects (navigation, snackbar)
    ref.listen(authNotifierProvider, (_, state) {
      state.whenOrNull(
        authenticated: (_) => context.go(RouteNames.home),
        error: (msg) => context.showSnackbar(msg, isError: true),
      );
    });

    final isLoading = ref.watch(
      authNotifierProvider.select((s) => s is _Loading),
    );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screen,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.xxl),
                Text('Welcome back', style: AppTextStyles.h1),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Sign in to your account',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.grey500,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                AppTextField(
                  label: 'Email',
                  hint: 'you@example.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Password',
                  hint: '••••••••',
                  controller: _passwordController,
                  obscureText: true,
                  validator: Validators.password,
                ),
                const SizedBox(height: AppSpacing.xl),
                PrimaryButton(
                  label: 'Sign In',
                  isLoading: isLoading,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(authNotifierProvider.notifier).login(
            _emailController.text.trim(),
            _passwordController.text,
          );
    }
  }
}
```

---

## 6. State Management

### Riverpod — Simplified Usage for Medium Apps

You don't need complex Notifiers for everything. Pick the right tool:

| State Type | Use | Example |
|---|---|---|
| Server data | `AsyncNotifier` | Product list from API |
| User actions | `Notifier` | Auth flow, form submit |
| Simple toggle | `StateProvider` | Dark mode, filter toggle |
| Computed value | `Provider` | Cart total from cart list |
| Stream | `StreamProvider` | Realtime notifications |

```dart
// Simple toggle — no class needed
@riverpod
class ThemeMode extends _$ThemeMode {
  @override
  bool build() => false; // false = light

  void toggle() => state = !state;
}

// Computed value
@riverpod
double cartTotal(Ref ref) {
  final items = ref.watch(cartProvider);
  return items.fold(0.0, (sum, item) => sum + item.price * item.quantity);
}

// Server data with AsyncNotifier
@riverpod
class ProductList extends _$ProductList {
  @override
  Future<List<Product>> build() async {
    return ref.watch(productRepositoryProvider).getProducts();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future; // Wait for rebuild
  }
}
```

### AsyncValue in UI — Keep It Clean

```dart
// shared/widgets/async_widget.dart
class AsyncWidget<T> extends StatelessWidget {
  final AsyncValue<T> value;
  final Widget Function(T data) builder;
  final Widget? loadingWidget;
  final Widget Function(String error)? errorBuilder;

  const AsyncWidget({
    super.key,
    required this.value,
    required this.builder,
    this.loadingWidget,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: builder,
      loading: () => loadingWidget ?? const Center(child: AppLoader()),
      error: (e, _) => errorBuilder?.call(e.toString()) ??
          Center(child: Text('Something went wrong: $e')),
    );
  }
}

// Usage in a screen — clean and readable
AsyncWidget(
  value: ref.watch(productListProvider),
  builder: (products) => ProductGrid(products: products),
  errorBuilder: (error) => AppErrorWidget(message: error),
)
```

---

## 7. Routing

### GoRouter — Clean Setup

```dart
// core/router/route_names.dart
class RouteNames {
  static const splash    = '/';
  static const login     = '/login';
  static const register  = '/register';
  static const home      = '/home';
  static const profile   = '/profile';
  static const settings  = '/settings';
  static const details   = '/details/:id';  // Typed param

  // Helper for detail routes
  static String detailPath(String id) => '/details/$id';
}
```

```dart
// core/router/app_router.dart
@riverpod
GoRouter appRouter(Ref ref) {
  final isAuth = ref.watch(
    authNotifierProvider.select((s) => s is _Authenticated),
  );

  return GoRouter(
    initialLocation: RouteNames.splash,
    redirect: (context, state) {
      final onAuthRoute = [RouteNames.login, RouteNames.register]
          .contains(state.matchedLocation);

      if (!isAuth && !onAuthRoute) return RouteNames.login;
      if (isAuth && onAuthRoute) return RouteNames.home;
      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.register,
        builder: (_, __) => const RegisterScreen(),
      ),
      ShellRoute(
        builder: (_, __, child) => HomeShell(child: child),
        routes: [
          GoRoute(
            path: RouteNames.home,
            builder: (_, __) => const HomeScreen(),
          ),
          GoRoute(
            path: RouteNames.profile,
            builder: (_, __) => const ProfileScreen(),
          ),
          GoRoute(
            path: RouteNames.settings,
            builder: (_, __) => const SettingsScreen(),
          ),
          GoRoute(
            path: RouteNames.details,
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return DetailsScreen(id: id);
            },
          ),
        ],
      ),
    ],
  );
}
```

---

## 8. Networking

### Dio Client Setup

```dart
// core/network/dio_client.dart
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final dio = Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 20),
    headers: {'Content-Type': 'application/json'},
  ));

  dio.interceptors.addAll([
    AuthInterceptor(ref.watch(secureStorageProvider)),
    if (kDebugMode) LogInterceptor(responseBody: true, requestBody: true),
  ]);

  return dio;
}
```

```dart
// core/network/interceptors/auth_interceptor.dart
class AuthInterceptor extends Interceptor {
  final SecureStorage _storage;
  AuthInterceptor(this._storage);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.readToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Optionally handle token refresh here
      // For simplicity, clear tokens and redirect to login
    }
    handler.next(err);
  }
}
```

---

## 9. Error Handling

### Simple but Effective

For medium apps, a clean `Result` type + a few `Failure` classes covers 95% of cases.

```dart
// core/error/failures.dart
sealed class AppFailure {
  final String message;
  const AppFailure(this.message);

  factory AppFailure.fromDio(DioException e) {
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout =>
        const NetworkFailure(),
      DioExceptionType.badResponse => switch (e.response?.statusCode) {
          401 => const UnauthorizedFailure(),
          404 => const NotFoundFailure(),
          500 => const ServerFailure(),
          _ => ServerFailure(
              e.response?.data?['message'] ?? 'Unknown server error',
            ),
        },
      _ => const NetworkFailure(),
    };
  }

  factory AppFailure.unknown(String message) => ServerFailure(message);
}

class NetworkFailure extends AppFailure {
  const NetworkFailure() : super('No internet connection. Check your network.');
}

class ServerFailure extends AppFailure {
  const ServerFailure([super.message = 'Server error. Try again later.']);
}

class UnauthorizedFailure extends AppFailure {
  const UnauthorizedFailure() : super('Session expired. Please log in again.');
}

class NotFoundFailure extends AppFailure {
  const NotFoundFailure() : super('The requested item was not found.');
}

class ValidationFailure extends AppFailure {
  const ValidationFailure(super.message);
}
```

```dart
// core/error/result.dart
sealed class Result<T> {
  const Result();

  R when<R>({
    required R Function(T data) success,
    required R Function(AppFailure failure) failure,
  }) => switch (this) {
    Success<T> s => success(s.data),
    Failure<T> f => failure(f.failure),
  };

  T? get dataOrNull => this is Success<T> ? (this as Success<T>).data : null;
  bool get isSuccess => this is Success<T>;
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final AppFailure failure;
  const Failure(this.failure);
}
```

---

## 10. Local Storage

### Two Storages, Two Jobs

```dart
// core/storage/secure_storage.dart
// For tokens and sensitive data
class SecureStorage {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  Future<void> writeToken(String token) =>
      _storage.write(key: 'auth_token', value: token);

  Future<String?> readToken() =>
      _storage.read(key: 'auth_token');

  Future<void> clearAll() => _storage.deleteAll();
}
```

```dart
// core/storage/local_storage.dart
// For app preferences and cache
class LocalStorage {
  final SharedPreferences _prefs;
  LocalStorage(this._prefs);

  // Theme
  bool get isDarkMode => _prefs.getBool('dark_mode') ?? false;
  Future<void> setDarkMode(bool value) =>
      _prefs.setBool('dark_mode', value);

  // Onboarding
  bool get hasSeenOnboarding => _prefs.getBool('onboarding_done') ?? false;
  Future<void> setOnboardingDone() =>
      _prefs.setBool('onboarding_done', true);

  // Generic helpers
  Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);

  String? getString(String key) => _prefs.getString(key);
}

@Riverpod(keepAlive: true)
Future<LocalStorage> localStorage(Ref ref) async {
  final prefs = await SharedPreferences.getInstance();
  return LocalStorage(prefs);
}
```

---

## 11. Testing Strategy

For medium apps, focus testing effort on the **logic layer** — that's where bugs live.

### What to Test

| Layer | What to Test | Priority |
|---|---|---|
| `logic/` (Notifiers) | State transitions on success/failure | 🔴 High |
| `data/` (Repositories) | Correct mapping + error handling | 🟡 Medium |
| `design_system/` | Visual regression (golden tests) | 🟢 Low |
| `ui/` (Screens) | Critical flows (login, checkout) | 🟡 Medium |

### Example — Notifier Test

```dart
// test/features/auth/logic/auth_provider_test.dart
void main() {
  late ProviderContainer container;
  late MockAuthRepository mockRepo;

  setUp(() {
    mockRepo = MockAuthRepository();
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
  });

  tearDown(() => container.dispose());

  test('login success → authenticated state', () async {
    when(() => mockRepo.login(any(), any()))
        .thenAnswer((_) async => Success(tUserModel));

    await container.read(authNotifierProvider.notifier).login(
          'test@example.com',
          'password123',
        );

    expect(
      container.read(authNotifierProvider),
      isA<_Authenticated>(),
    );
  });

  test('login failure → error state with message', () async {
    when(() => mockRepo.login(any(), any()))
        .thenAnswer((_) async => Failure(const NetworkFailure()));

    await container.read(authNotifierProvider.notifier).login(
          'test@example.com',
          'password123',
        );

    final state = container.read(authNotifierProvider);
    expect(state, isA<_Error>());
    expect(
      (state as _Error).message,
      'No internet connection. Check your network.',
    );
  });
}
```

---

## 12. Security Basics

For a medium app, these five practices cover the most important attack surfaces:

```
✅ 1. Never store tokens in SharedPreferences
       → Use flutter_secure_storage

✅ 2. Never hardcode API keys or base URLs in code
       → Use --dart-define-from-file=.env.json

✅ 3. Mask sensitive fields in Dio logs
       → Custom LoggingInterceptor that redacts Authorization header

✅ 4. Obfuscate release builds
       → flutter build apk --obfuscate --split-debug-info=symbols/

✅ 5. Validate input on the client
       → Validators class before any API call
```

```dart
// core/utils/validators.dart
class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    final regex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value)) return 'Enter a valid email';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) return 'Phone is required';
    if (value.length < 10) return 'Enter a valid phone number';
    return null;
  }
}
```

---

## 13. Recommended Tech Stack

| Category | Package | Version | Why |
|---|---|---|---|
| **State** | `riverpod` + `riverpod_generator` | ^2.6 | Simple, testable, scalable |
| **Routing** | `go_router` | ^14.x | Deep linking, auth guards |
| **Networking** | `dio` | ^5.x | Interceptors, cancellation |
| **Models** | `freezed` + `json_serializable` | ^2.5 / ^6.8 | Immutable, JSON ready |
| **Secure Storage** | `flutter_secure_storage` | ^9.x | Token storage |
| **Preferences** | `shared_preferences` | ^2.x | App settings |
| **Images** | `cached_network_image` | ^3.x | Cache + placeholders |
| **Linting** | `flutter_lints` | ^4.x | Standard lint rules |
| **Testing** | `mocktail` | ^1.x | Clean mocking |
| **Code Gen** | `build_runner` | ^2.x | Freezed + Riverpod gen |

### pubspec.yaml Template

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State
  flutter_riverpod: ^2.6.1
  riverpod_annotation: ^2.3.5

  # Routing
  go_router: ^14.2.7

  # Networking
  dio: ^5.7.0

  # Models
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0

  # Storage
  flutter_secure_storage: ^9.2.2
  shared_preferences: ^2.3.3

  # UI
  cached_network_image: ^3.4.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
  build_runner: ^2.4.13
  freezed: ^2.5.7
  json_serializable: ^6.8.0
  riverpod_generator: ^2.4.3
  go_router_builder: ^2.7.1
  mocktail: ^1.0.4
```

---

## 14. Common Mistakes to Avoid

### ❌ Calling APIs Directly from Widgets

```dart
// ❌ Wrong — API call inside build or onPressed
ElevatedButton(
  onPressed: () async {
    final dio = Dio();
    final response = await dio.get('/products');
    // ...
  },
)

// ✅ Right — delegate to provider
ElevatedButton(
  onPressed: () => ref.read(productProvider.notifier).loadProducts(),
)
```

### ❌ One Giant Feature File

```dart
// ❌ Wrong — everything in one file
// auth_feature.dart — 800 lines mixing model, API, state, and UI

// ✅ Right — split across data/logic/ui
features/auth/
  data/auth_api.dart
  data/auth_repository.dart
  data/models/user_model.dart
  logic/auth_provider.dart
  logic/auth_state.dart
  ui/login_screen.dart
```

### ❌ Hardcoding Colors and Text Styles

```dart
// ❌ Wrong
Text('Hello', style: TextStyle(fontSize: 24, color: Color(0xFF6C63FF)))

// ✅ Right
Text('Hello', style: AppTextStyles.h2.copyWith(color: AppColors.primary))
```

### ❌ Putting Business Logic in Repositories

```dart
// ❌ Wrong — repository decides app behavior
class CartRepository {
  Future<void> addItem(CartItem item) async {
    if (items.length >= 10) {
      throw Exception('Cart is full'); // Business rule in data layer!
    }
  }
}

// ✅ Right — repository only handles data, logic goes in provider/service
class CartNotifier extends _$CartNotifier {
  void addItem(CartItem item) {
    if (state.items.length >= 10) {
      // Handle in UI state layer
      state = state.copyWith(error: 'Cart limit reached');
      return;
    }
    ref.read(cartRepositoryProvider).save(item);
  }
}
```

### ❌ No Error States in UI

```dart
// ❌ Wrong — ignoring failure cases
final products = await ref.watch(productProvider.future);
return ProductGrid(products: products); // Crashes on error!

// ✅ Right — handle all cases
AsyncWidget(
  value: ref.watch(productProvider),
  builder: (products) => ProductGrid(products: products),
  errorBuilder: (error) => AppErrorWidget(
    message: error,
    onRetry: () => ref.invalidate(productProvider),
  ),
)
```

---

## 15. Quick Start Checklist

Use this when starting a new medium Flutter project:

### Project Setup
- [ ] Create project with `flutter create --org com.yourcompany appname`
- [ ] Set up `analysis_options.yaml` with `flutter_lints`
- [ ] Configure `--dart-define-from-file` for environment variables
- [ ] Set up folder structure from Section 2

### Design System
- [ ] Define `AppColors` with brand + semantic colors
- [ ] Define `AppTextStyles` with font family
- [ ] Define `AppSpacing` and `AppRadius`
- [ ] Create `AppTheme.light()` and `AppTheme.dark()`
- [ ] Build `PrimaryButton`, `AppTextField`, `AppCard`, `AppLoader`

### Core Setup
- [ ] Configure `Dio` with base URL and timeouts
- [ ] Add `AuthInterceptor`
- [ ] Set up `SecureStorage` for tokens
- [ ] Set up `LocalStorage` for preferences
- [ ] Define `AppFailure` sealed classes
- [ ] Create `Result<T>` type

### Routing
- [ ] Define `RouteNames` constants
- [ ] Set up `GoRouter` with auth redirect guard
- [ ] Wire `appRouterProvider` to `MaterialApp.router`

### First Feature
- [ ] Create `data/` (model, API, repository)
- [ ] Create `logic/` (state, provider)
- [ ] Create `ui/` (screens, widgets)
- [ ] Write at least one notifier unit test

### Before Launch
- [ ] Enable release obfuscation in build script
- [ ] Confirm tokens stored in secure storage (not SharedPreferences)
- [ ] Run `flutter analyze` with zero errors
- [ ] Test on both light and dark themes

---

## Comparison: Medium vs Enterprise

| Aspect | Medium (This Guide) | Enterprise |
|---|---|---|
| Layers per feature | 3 (data / logic / ui) | 3 + explicit domain (entities, use cases, abstractions) |
| Repository | Concrete class | Interface + Implementation separated |
| Use Cases | Logic lives in Notifier | Dedicated `UseCase` classes |
| Design System | Tokens + small widget lib | Full Atomic Design (atoms → organisms) |
| DI | Riverpod providers | Riverpod + explicit module providers |
| Error handling | Simple sealed `AppFailure` | Typed failure hierarchy per feature |
| Testing | Logic layer priority | All layers, 80%+ coverage enforced in CI |
| Team size | 2–8 devs | 8–50+ devs |
| Scalability | Grows to enterprise with refactor | Ready for 100+ screens out of the box |

> When your app grows past 50 screens or 8 developers, consider migrating toward the enterprise architecture — the folder structure is compatible, you'd mainly be adding the `domain/` layer and separating repository interfaces from implementations.

---

*Flutter Medium App Architecture — 2026 Edition*
*Flutter 3.27+ / Dart 3.6+ / Riverpod 2.x / GoRouter 14.x*