# 🏗️ Enterprise Flutter App Architecture — 2026 Edition

> A battle-tested, future-proof architecture for scalable Flutter applications across SaaS platforms, POS systems, ERP solutions, enterprise dashboards, and multi-team projects.

---

## Table of Contents

1. [Architecture Philosophy](#1-architecture-philosophy)
2. [The Hybrid Modular Clean Architecture](#2-the-hybrid-modular-clean-architecture)
3. [Complete Folder Structure](#3-complete-folder-structure)
4. [Layer-by-Layer Breakdown](#4-layer-by-layer-breakdown)
   - [Core Layer](#41-core-layer)
   - [Design System Layer](#42-design-system-layer)
   - [Shared Layer](#43-shared-layer)
   - [Features Layer](#44-features-layer)
   - [App Layer](#45-app-layer)
5. [Design System Deep Dive](#5-design-system-deep-dive)
6. [Feature Module Deep Dive](#6-feature-module-deep-dive)
7. [State Management Strategy](#7-state-management-strategy)
8. [Routing Architecture](#8-routing-architecture)
9. [Networking & Data Layer](#9-networking--data-layer)
10. [Error Handling Strategy](#10-error-handling-strategy)
11. [Dependency Injection](#11-dependency-injection)
12. [Testing Architecture](#12-testing-architecture)
13. [Security Practices](#13-security-practices)
14. [Performance Best Practices](#14-performance-best-practices)
15. [CI/CD & Dev Tooling](#15-cicd--dev-tooling)
16. [Recommended Tech Stack](#16-recommended-tech-stack)
17. [Enterprise Design Principles](#17-enterprise-design-principles)
18. [Multi-Platform Strategy](#18-multi-platform-strategy)
19. [Common Anti-Patterns to Avoid](#19-common-anti-patterns-to-avoid)
20. [Migration Path from Legacy Structure](#20-migration-path-from-legacy-structure)

---

## 1. Architecture Philosophy

### Why Architecture Matters at Enterprise Scale

As Flutter teams grow from 2 developers to 20+, the biggest challenges become:

| Problem | Without Architecture | With This Architecture |
|---|---|---|
| Feature conflicts | Merge hell | Isolated modules |
| UI inconsistency | Every screen looks different | Design system tokens |
| State bugs | Shared mutable state everywhere | Scoped, testable state |
| Slow onboarding | Weeks to understand codebase | Feature folders = mental map |
| Refactoring cost | Touch one thing, break ten | Clean boundaries |
| Testing gaps | Nothing is testable | Every layer is independently testable |

### Core Principles

1. **Feature Isolation** — Features are islands; shared bridges are explicit and minimal.
2. **Domain-Driven** — Code structure mirrors business language.
3. **Inversion of Dependencies** — High-level modules don't depend on low-level ones.
4. **Design Token Driven** — No hardcoded values. Ever.
5. **Contract-First** — Abstractions defined in domain; implementations live in data.
6. **Composition over Inheritance** — Prefer mixins and composition for UI and logic.
7. **Fail Fast, Recover Gracefully** — Typed errors propagate cleanly.

---

## 2. The Hybrid Modular Clean Architecture

This architecture is a deliberate fusion of three well-proven patterns:

```
┌─────────────────────────────────────────────────────────┐
│                    PRESENTATION                          │
│          (UI, Riverpod Notifiers, Screens)               │
├─────────────────────────────────────────────────────────┤
│                      DOMAIN                              │
│        (Entities, Use Cases, Repository Contracts)       │
├─────────────────────────────────────────────────────────┤
│                       DATA                               │
│    (APIs, Local DB, Repository Impls, DTOs, Mappers)     │
└─────────────────────────────────────────────────────────┘
        Wrapped inside Feature-Based Module Boundaries
        Powered by a Centralized Design System
```

**Dependency Rule:** Data → Domain ← Presentation. Domain knows nothing about either. Data and Presentation implement Domain contracts.

---

## 3. Complete Folder Structure

```
lib/
│
├── core/
│   ├── api/
│   │   ├── api_client.dart               # Dio instance factory
│   │   ├── api_constants.dart            # Base URLs, timeouts
│   │   └── interceptors/
│   │       ├── auth_interceptor.dart
│   │       ├── logging_interceptor.dart
│   │       └── retry_interceptor.dart
│   │
│   ├── network/
│   │   ├── network_info.dart             # Connectivity checker
│   │   └── result.dart                   # Result<T, Failure> type
│   │
│   ├── storage/
│   │   ├── secure_storage.dart           # flutter_secure_storage wrapper
│   │   ├── local_storage.dart            # Hive / Isar wrapper
│   │   └── cache_manager.dart
│   │
│   ├── routing/
│   │   ├── app_router.dart               # GoRouter config
│   │   ├── route_names.dart              # Typed route constants
│   │   ├── route_guards.dart             # Auth, role guards
│   │   └── transitions/
│   │       └── slide_transition.dart
│   │
│   ├── services/
│   │   ├── analytics_service.dart
│   │   ├── notification_service.dart
│   │   ├── crash_reporting_service.dart
│   │   ├── biometric_service.dart
│   │   └── permission_service.dart
│   │
│   ├── errors/
│   │   ├── failures.dart                 # Sealed Failure classes
│   │   ├── exceptions.dart               # App-specific exceptions
│   │   └── error_handler.dart
│   │
│   ├── utils/
│   │   ├── date_utils.dart
│   │   ├── currency_utils.dart
│   │   ├── validators.dart
│   │   └── debouncer.dart
│   │
│   ├── constants/
│   │   ├── app_constants.dart
│   │   ├── regex_constants.dart
│   │   └── durations.dart
│   │
│   └── base/
│       ├── base_usecase.dart
│       ├── base_repository.dart
│       └── base_state.dart
│
├── design_system/
│   ├── tokens/
│   │   ├── colors.dart
│   │   ├── typography.dart
│   │   ├── spacing.dart
│   │   ├── radius.dart
│   │   ├── shadows.dart
│   │   ├── durations.dart
│   │   └── breakpoints.dart
│   │
│   ├── theme/
│   │   ├── app_theme.dart                # ThemeData builder
│   │   ├── light_theme.dart
│   │   ├── dark_theme.dart
│   │   └── theme_extensions.dart         # Custom ThemeExtension classes
│   │
│   ├── atoms/
│   │   ├── buttons/
│   │   │   ├── primary_button.dart
│   │   │   ├── secondary_button.dart
│   │   │   ├── icon_button.dart
│   │   │   └── loading_button.dart
│   │   ├── inputs/
│   │   │   ├── app_text_field.dart
│   │   │   ├── app_dropdown.dart
│   │   │   └── app_search_field.dart
│   │   ├── text/
│   │   │   ├── display_text.dart
│   │   │   ├── headline_text.dart
│   │   │   ├── body_text.dart
│   │   │   └── caption_text.dart
│   │   ├── indicators/
│   │   │   ├── app_loader.dart
│   │   │   ├── app_badge.dart
│   │   │   └── status_dot.dart
│   │   └── app_icon.dart
│   │
│   ├── molecules/
│   │   ├── app_card.dart
│   │   ├── list_tile_item.dart
│   │   ├── form_field_group.dart
│   │   ├── search_bar.dart
│   │   ├── avatar_with_label.dart
│   │   └── info_chip.dart
│   │
│   ├── organisms/
│   │   ├── app_header.dart
│   │   ├── app_sidebar.dart
│   │   ├── data_table.dart
│   │   ├── filter_panel.dart
│   │   ├── pagination_bar.dart
│   │   └── empty_state.dart
│   │
│   └── layouts/
│       ├── responsive_layout.dart        # Mobile/Tablet/Desktop switcher
│       ├── scaffold_with_nav.dart
│       ├── two_column_layout.dart
│       └── centered_content_layout.dart
│
├── shared/
│   ├── widgets/
│   │   ├── async_value_widget.dart       # AsyncValue UI helper
│   │   ├── paginated_list.dart
│   │   ├── infinite_scroll_list.dart
│   │   └── image_with_placeholder.dart
│   │
│   ├── extensions/
│   │   ├── context_extensions.dart       # theme, l10n, nav shortcuts
│   │   ├── string_extensions.dart
│   │   ├── datetime_extensions.dart
│   │   ├── num_extensions.dart
│   │   └── list_extensions.dart
│   │
│   ├── helpers/
│   │   ├── dialog_helper.dart
│   │   ├── snackbar_helper.dart
│   │   └── bottom_sheet_helper.dart
│   │
│   ├── enums/
│   │   ├── user_role.dart
│   │   ├── order_status.dart
│   │   └── payment_method.dart
│   │
│   └── models/
│       ├── pagination_model.dart
│       └── sort_config.dart
│
├── features/
│   │
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── auth_remote_datasource.dart
│   │   │   │   └── auth_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── user_dto.dart
│   │   │   │   └── token_dto.dart
│   │   │   ├── mappers/
│   │   │   │   └── user_mapper.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   │
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart  # Abstract contract
│   │   │   └── usecases/
│   │   │       ├── login_usecase.dart
│   │   │       ├── logout_usecase.dart
│   │   │       └── refresh_token_usecase.dart
│   │   │
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── login_screen.dart
│   │       │   └── forgot_password_screen.dart
│   │       ├── widgets/
│   │       │   ├── login_form.dart
│   │       │   └── social_auth_buttons.dart
│   │       ├── providers/
│   │       │   ├── auth_provider.dart
│   │       │   └── auth_state.dart
│   │       └── controllers/
│   │           └── login_controller.dart
│   │
│   ├── dashboard/
│   ├── booking/
│   ├── payments/
│   ├── inventory/
│   ├── analytics/
│   ├── notifications/
│   ├── settings/
│   └── admin/
│
├── app/
│   ├── app.dart                          # Root MaterialApp / RouterConfig
│   ├── app_providers.dart                # Root ProviderScope overrides
│   └── observers/
│       ├── app_observer.dart             # NavigatorObserver
│       └── riverpod_observer.dart        # ProviderObserver for logging
│
├── l10n/                                 # Localization ARB files
│   ├── app_en.arb
│   ├── app_hi.arb
│   └── app_ar.arb
│
├── bootstrap.dart                        # App initialization logic
└── main.dart                             # Entry point (env-aware)
```

---

## 4. Layer-by-Layer Breakdown

### 4.1 Core Layer

The **Core** layer is infrastructure. It has no knowledge of any feature.

#### API Client Setup (Dio)

```dart
// core/api/api_client.dart
class ApiClient {
  static Dio create({
    required String baseUrl,
    required List<Interceptor> interceptors,
  }) {
    final dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    dio.interceptors.addAll([
      ...interceptors,
      LogInterceptor(responseBody: kDebugMode),
    ]);

    return dio;
  }
}
```

#### Auth Interceptor

```dart
// core/api/interceptors/auth_interceptor.dart
class AuthInterceptor extends Interceptor {
  final SecureStorage _storage;
  final Dio _tokenRefreshDio; // Separate Dio, avoids infinite loop

  AuthInterceptor(this._storage, this._tokenRefreshDio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storage.readAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        await _refreshToken();
        final retryResponse = await _retry(err.requestOptions);
        handler.resolve(retryResponse);
      } catch (_) {
        handler.reject(err);
      }
    } else {
      handler.next(err);
    }
  }
  // ... _refreshToken, _retry implementations
}
```

#### Result Type (No More Exceptions Leaking)

```dart
// core/network/result.dart
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final AppFailure failure;
  const Failure(this.failure);
}

// Usage
extension ResultExtension<T> on Result<T> {
  R when<R>({
    required R Function(T data) success,
    required R Function(AppFailure failure) failure,
  }) => switch (this) {
    Success<T> s => success(s.data),
    Failure<T> f => failure(f.failure),
  };
}
```

---

### 4.2 Design System Layer

> The single most important layer for long-term maintainability.

See [Section 5 — Design System Deep Dive](#5-design-system-deep-dive) for full details.

---

### 4.3 Shared Layer

Shared widgets and utilities used by **two or more** features. If something is only used in one feature, it stays inside that feature's `/presentation/widgets/`.

#### Context Extensions (Power Tool)

```dart
// shared/extensions/context_extensions.dart
extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  AppLocalizations get l10n => AppLocalizations.of(this)!;
  
  // Custom theme extensions
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
  AppTypography get typography => Theme.of(this).extension<AppTypography>()!;

  NavigatorState get navigator => Navigator.of(this);
  bool get isMobile => MediaQuery.of(this).size.width < 600;
  bool get isTablet =>
      MediaQuery.of(this).size.width >= 600 &&
      MediaQuery.of(this).size.width < 1024;
  bool get isDesktop => MediaQuery.of(this).size.width >= 1024;
}
```

---

### 4.4 Features Layer

Each feature is a **self-contained vertical slice** of the application. No feature imports from another feature's internal layers. Cross-feature communication happens through:

- **Shared domain entities** in `shared/models/`
- **Riverpod providers** exposed at feature root
- **Events/callbacks** passed via GoRouter query params or state

---

### 4.5 App Layer

```dart
// app/app.dart
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      routerConfig: router,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
    );
  }
}
```

```dart
// bootstrap.dart
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services in order
  await _initializeFirebase();
  await _initializeLocalStorage();
  await _configureSystemUI();

  FlutterError.onError = CrashReportingService.recordFlutterError;
  PlatformDispatcher.instance.onError = (error, stack) {
    CrashReportingService.recordError(error, stack);
    return true;
  };

  runApp(
    ProviderScope(
      observers: [RiverpodObserver()],
      child: const App(),
    ),
  );
}
```

---

## 5. Design System Deep Dive

### Design Tokens

All visual properties are centralized as typed constants. Never use raw values.

```dart
// design_system/tokens/colors.dart
class AppColors {
  // Brand
  static const primary = Color(0xFF0A84FF);
  static const primaryVariant = Color(0xFF0066CC);
  static const secondary = Color(0xFF30D158);
  static const accent = Color(0xFFFF9F0A);

  // Semantic
  static const error = Color(0xFFFF453A);
  static const warning = Color(0xFFFFD60A);
  static const success = Color(0xFF30D158);
  static const info = Color(0xFF0A84FF);

  // Neutrals
  static const grey50 = Color(0xFFF9FAFB);
  static const grey100 = Color(0xFFF3F4F6);
  static const grey200 = Color(0xFFE5E7EB);
  static const grey600 = Color(0xFF4B5563);
  static const grey900 = Color(0xFF111827);

  // Dark surfaces
  static const surface = Color(0xFF1C1C1E);
  static const surfaceVariant = Color(0xFF2C2C2E);
  static const background = Color(0xFF000000);
}
```

```dart
// design_system/tokens/spacing.dart
class AppSpacing {
  static const double xxs = 2.0;
  static const double xs  = 4.0;
  static const double sm  = 8.0;
  static const double md  = 16.0;
  static const double lg  = 24.0;
  static const double xl  = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  // Insets (shorthand EdgeInsets)
  static const EdgeInsets pagePadding = EdgeInsets.all(md);
  static const EdgeInsets cardPadding = EdgeInsets.symmetric(
    horizontal: md, vertical: sm,
  );
}
```

```dart
// design_system/tokens/typography.dart
class AppTypography {
  static const String _fontFamily = 'PlusJakartaSans';

  static const displayLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 57,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
    height: 1.12,
  );

  static const headlineMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.28,
  );

  static const bodyLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.5,
  );

  static const labelSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.45,
  );
}
```

```dart
// design_system/tokens/breakpoints.dart
class AppBreakpoints {
  static const double mobile  = 0;
  static const double tablet  = 600;
  static const double desktop = 1024;
  static const double wide    = 1440;
}
```

### ThemeExtensions (Custom Theme Data)

```dart
// design_system/theme/theme_extensions.dart
@immutable
class AppColorScheme extends ThemeExtension<AppColorScheme> {
  final Color cardSurface;
  final Color divider;
  final Color shimmer;

  const AppColorScheme({
    required this.cardSurface,
    required this.divider,
    required this.shimmer,
  });

  @override
  AppColorScheme copyWith({Color? cardSurface, Color? divider, Color? shimmer}) {
    return AppColorScheme(
      cardSurface: cardSurface ?? this.cardSurface,
      divider: divider ?? this.divider,
      shimmer: shimmer ?? this.shimmer,
    );
  }

  @override
  AppColorScheme lerp(AppColorScheme? other, double t) {
    if (other is! AppColorScheme) return this;
    return AppColorScheme(
      cardSurface: Color.lerp(cardSurface, other.cardSurface, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      shimmer: Color.lerp(shimmer, other.shimmer, t)!,
    );
  }
}
```

### Atomic Design Components

#### Atom: PrimaryButton

```dart
// design_system/atoms/buttons/primary_button.dart
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final Widget? prefixIcon;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: 52,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (prefixIcon != null) ...[
                    prefixIcon!,
                    const SizedBox(width: AppSpacing.xs),
                  ],
                  Text(label),
                ],
              ),
      ),
    );
  }
}
```

#### Organism: ResponsiveLayout

```dart
// design_system/layouts/responsive_layout.dart
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= AppBreakpoints.desktop) {
          return desktop ?? tablet ?? mobile;
        }
        if (constraints.maxWidth >= AppBreakpoints.tablet) {
          return tablet ?? mobile;
        }
        return mobile;
      },
    );
  }
}
```

---

## 6. Feature Module Deep Dive

### Domain Layer

```dart
// features/auth/domain/entities/user_entity.dart
@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String id,
    required String email,
    required String name,
    required UserRole role,
    String? avatarUrl,
    required DateTime createdAt,
  }) = _UserEntity;
}
```

```dart
// features/auth/domain/repositories/auth_repository.dart
abstract interface class AuthRepository {
  Future<Result<UserEntity>> login(String email, String password);
  Future<Result<void>> logout();
  Future<Result<UserEntity>> refreshSession();
  Stream<UserEntity?> get authStateChanges;
}
```

```dart
// features/auth/domain/usecases/login_usecase.dart
class LoginUseCase extends BaseUseCase<UserEntity, LoginParams> {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  @override
  Future<Result<UserEntity>> execute(LoginParams params) {
    if (!Validators.isValidEmail(params.email)) {
      return Future.value(Failure(ValidationFailure('Invalid email')));
    }
    return _repository.login(params.email, params.password);
  }
}

@freezed
class LoginParams with _$LoginParams {
  const factory LoginParams({
    required String email,
    required String password,
  }) = _LoginParams;
}
```

### Data Layer

```dart
// features/auth/data/datasources/auth_remote_datasource.dart
abstract interface class AuthRemoteDataSource {
  Future<UserDto> login(String email, String password);
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<UserDto> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      return UserDto.fromJson(response.data);
    } on DioException catch (e) {
      throw _mapDioToException(e);
    }
  }
}
```

```dart
// features/auth/data/repositories/auth_repository_impl.dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;
  final UserMapper _mapper;

  AuthRepositoryImpl(this._remote, this._local, this._mapper);

  @override
  Future<Result<UserEntity>> login(String email, String password) async {
    try {
      final dto = await _remote.login(email, password);
      await _local.cacheUser(dto);
      return Success(_mapper.toEntity(dto));
    } on ServerException catch (e) {
      return Failure(ServerFailure(e.message));
    } on NetworkException {
      return Failure(const NetworkFailure());
    }
  }
}
```

### Presentation Layer

```dart
// features/auth/presentation/providers/auth_provider.dart
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  FutureOr<UserEntity?> build() async {
    return ref.watch(authRepositoryProvider).authStateChanges.first;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    final result = await ref
        .read(loginUseCaseProvider)
        .execute(LoginParams(email: email, password: password));

    state = result.when(
      success: (user) => AsyncData(user),
      failure: (failure) => AsyncError(failure, StackTrace.current),
    );
  }

  Future<void> logout() async {
    await ref.read(logoutUseCaseProvider).execute(NoParams());
    state = const AsyncData(null);
    ref.read(appRouterProvider).go(RouteNames.login);
  }
}
```

```dart
// features/auth/presentation/screens/login_screen.dart
class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    ref.listen(authNotifierProvider, (_, state) {
      state.whenOrNull(
        error: (error, _) => SnackbarHelper.showError(context, error.toString()),
        data: (user) {
          if (user != null) context.go(RouteNames.dashboard);
        },
      );
    });

    return Scaffold(
      body: ResponsiveLayout(
        mobile: _MobileLoginLayout(),
        desktop: _DesktopLoginLayout(),
      ),
    );
  }
}
```

---

## 7. State Management Strategy

### Riverpod Architecture (Recommended)

```
┌─────────────────────────────────────────────────────────┐
│ UI Layer         ConsumerWidget / HookConsumerWidget      │
│                  ref.watch / ref.listen                   │
├─────────────────────────────────────────────────────────┤
│ State Layer      @riverpod AsyncNotifier / Notifier       │
│                  Handles UI state + delegates to UC       │
├─────────────────────────────────────────────────────────┤
│ Use Case Layer   Injected via riverpod providers          │
├─────────────────────────────────────────────────────────┤
│ Repository Layer Implements domain contract               │
└─────────────────────────────────────────────────────────┘
```

### Provider Organization per Feature

```dart
// features/auth/presentation/providers/auth_providers.dart

// Infrastructure
@riverpod
AuthRemoteDataSource authRemoteDataSource(Ref ref) =>
    AuthRemoteDataSourceImpl(ref.watch(dioProvider));

@riverpod
AuthRepository authRepository(Ref ref) => AuthRepositoryImpl(
      ref.watch(authRemoteDataSourceProvider),
      ref.watch(authLocalDataSourceProvider),
      const UserMapper(),
    );

// Use Cases
@riverpod
LoginUseCase loginUseCase(Ref ref) =>
    LoginUseCase(ref.watch(authRepositoryProvider));

// UI State
@riverpod
class AuthNotifier extends _$AuthNotifier { ... }
```

### When to Use What

| Scenario | Recommended |
|---|---|
| Server data with loading/error | `AsyncNotifier` + `AsyncValue` |
| UI-only toggle, form input | `Notifier` or `StateProvider` |
| Computed/derived data | `Provider` (no state) |
| Stream-based data | `StreamNotifier` |
| Global singleton (auth) | `@Riverpod(keepAlive: true)` |

---

## 8. Routing Architecture

### GoRouter Setup with Guards

```dart
// core/routing/app_router.dart
@riverpod
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: RouteNames.splash,
    refreshListenable: GoRouterRefreshStream(
      ref.watch(authStateStreamProvider.stream),
    ),
    observers: [AppNavigatorObserver()],
    redirect: (context, state) {
      final isAuthenticated = authState.value != null;
      final isAuthRoute = state.matchedLocation.startsWith('/auth');

      if (!isAuthenticated && !isAuthRoute) return RouteNames.login;
      if (isAuthenticated && isAuthRoute) return RouteNames.dashboard;
      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      ShellRoute(
        builder: (_, __, child) => ScaffoldWithNav(child: child),
        routes: _authenticatedRoutes,
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (_, __) => const LoginScreen(),
      ),
    ],
  );
}
```

```dart
// core/routing/route_names.dart
abstract class RouteNames {
  static const splash     = '/';
  static const login      = '/auth/login';
  static const register   = '/auth/register';
  static const dashboard  = '/dashboard';
  static const booking    = '/booking';
  static const bookingDetail = '/booking/:id';
  static const analytics  = '/analytics';
  static const settings   = '/settings';
  static const admin      = '/admin';
}
```

---

## 9. Networking & Data Layer

### Failure Types

```dart
// core/errors/failures.dart
sealed class AppFailure {
  final String message;
  const AppFailure(this.message);
}

class ServerFailure extends AppFailure {
  final int? statusCode;
  const ServerFailure(super.message, {this.statusCode});
}

class NetworkFailure extends AppFailure {
  const NetworkFailure() : super('No internet connection');
}

class ValidationFailure extends AppFailure {
  const ValidationFailure(super.message);
}

class CacheFailure extends AppFailure {
  const CacheFailure(super.message);
}

class UnauthorizedFailure extends AppFailure {
  const UnauthorizedFailure() : super('Session expired. Please log in again.');
}
```

### DTO with Freezed + JSON Serializable

```dart
// features/auth/data/models/user_dto.dart
@freezed
class UserDto with _$UserDto {
  const factory UserDto({
    required String id,
    required String email,
    required String name,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    required String role,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
}
```

### Mapper Pattern

```dart
// features/auth/data/mappers/user_mapper.dart
class UserMapper {
  UserEntity toEntity(UserDto dto) => UserEntity(
        id: dto.id,
        email: dto.email,
        name: dto.name,
        avatarUrl: dto.avatarUrl,
        role: UserRole.fromString(dto.role),
        createdAt: DateTime.parse(dto.createdAt),
      );

  UserDto toDto(UserEntity entity) => UserDto(
        id: entity.id,
        email: entity.email,
        name: entity.name,
        avatarUrl: entity.avatarUrl,
        role: entity.role.name,
        createdAt: entity.createdAt.toIso8601String(),
      );
}
```

---

## 10. Error Handling Strategy

### Centralized Error Handler

```dart
// core/errors/error_handler.dart
class ErrorHandler {
  static AppFailure handle(dynamic error) {
    return switch (error) {
      DioException e => _handleDio(e),
      SocketException _ => const NetworkFailure(),
      FormatException _ => const CacheFailure('Data format error'),
      _ => ServerFailure(error.toString()),
    };
  }

  static AppFailure _handleDio(DioException e) {
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout =>
        const NetworkFailure(),
      DioExceptionType.badResponse => switch (e.response?.statusCode) {
          400 => ValidationFailure(
              e.response?.data['message'] ?? 'Bad request',
            ),
          401 => const UnauthorizedFailure(),
          403 => ServerFailure('Access denied', statusCode: 403),
          404 => ServerFailure('Resource not found', statusCode: 404),
          500 => ServerFailure('Server error', statusCode: 500),
          _ => ServerFailure('Unexpected error'),
        },
      _ => ServerFailure(e.message ?? 'Unknown error'),
    };
  }
}
```

### AsyncValue in UI

```dart
// shared/widgets/async_value_widget.dart
class AsyncValueWidget<T> extends StatelessWidget {
  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final Widget? loading;
  final Widget Function(Object error)? error;

  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
    this.loading,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      loading: () => loading ?? const Center(child: AppLoader()),
      error: (e, _) => error?.call(e) ??
          ErrorStateWidget(message: e is AppFailure ? e.message : e.toString()),
    );
  }
}
```

---

## 11. Dependency Injection

Use **Riverpod** as your DI framework. No `get_it` needed for most cases.

```dart
// core/api/providers/dio_provider.dart
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  return ApiClient.create(
    baseUrl: AppConstants.baseUrl,
    interceptors: [
      ref.watch(authInterceptorProvider),
      RetryInterceptor(
        dio: Dio(),
        retries: 3,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 3),
        ],
      ),
    ],
  );
}
```

> For heavy initialization (Firebase, Hive), initialize in `bootstrap.dart` and pass via `ProviderScope(overrides: [...])`.

---

## 12. Testing Architecture

### Test Pyramid for Flutter Enterprise

```
               ┌──────────┐
               │ E2E Tests │   (Patrol / integration_test)
              ┌┴──────────┴┐
             │ Widget Tests │  (mockito + flutter_test)
            ┌┴────────────┴┐
           │   Unit Tests   │  (test + mocktail)
          └────────────────┘
```

### Unit Test — Use Case

```dart
// test/features/auth/domain/usecases/login_usecase_test.dart
void main() {
  late LoginUseCase sut;
  late MockAuthRepository mockRepo;

  setUp(() {
    mockRepo = MockAuthRepository();
    sut = LoginUseCase(mockRepo);
  });

  group('LoginUseCase', () {
    test('returns ValidationFailure for invalid email', () async {
      final result = await sut.execute(
        const LoginParams(email: 'bad-email', password: '123456'),
      );
      expect(result, isA<Failure<UserEntity>>());
      expect((result as Failure).failure, isA<ValidationFailure>());
    });

    test('delegates to repository on valid params', () async {
      when(() => mockRepo.login(any(), any()))
          .thenAnswer((_) async => const Success(tUserEntity));

      final result = await sut.execute(
        const LoginParams(email: 'test@example.com', password: 'password'),
      );
      expect(result, isA<Success<UserEntity>>());
    });
  });
}
```

### Widget Test — Screen

```dart
// test/features/auth/presentation/screens/login_screen_test.dart
void main() {
  testWidgets('shows error snackbar on login failure', (tester) async {
    final container = ProviderContainer(
      overrides: [
        authNotifierProvider.overrideWith(() => FakeAuthNotifier(failLogin: true)),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: LoginScreen()),
      ),
    );

    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pump();

    expect(find.text('Invalid credentials'), findsOneWidget);
  });
}
```

---

## 13. Security Practices

```dart
// core/storage/secure_storage.dart
class SecureStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  Future<void> writeAccessToken(String token) =>
      _storage.write(key: 'access_token', value: token);

  Future<String?> readAccessToken() =>
      _storage.read(key: 'access_token');

  Future<void> clearAll() => _storage.deleteAll();
}
```

### Security Checklist

- ✅ Use `flutter_secure_storage` for tokens — never SharedPreferences
- ✅ Enable Certificate Pinning for production APIs
- ✅ Obfuscate release builds: `--obfuscate --split-debug-info`
- ✅ Validate all user inputs on client AND server
- ✅ Mask sensitive fields in logging interceptors
- ✅ Implement session expiry + forced logout
- ✅ Use `--dart-define` for environment variables (never commit `.env`)
- ✅ Enable ProGuard / R8 on Android release builds
- ✅ Disable screenshots on sensitive screens (`FLAG_SECURE`)

---

## 14. Performance Best Practices

### Widget Performance

```dart
// Use const constructors wherever possible
const PrimaryButton(label: 'Submit')

// Extract widgets before using selectors — avoids unnecessary rebuilds
@override
Widget build(BuildContext context, WidgetRef ref) {
  final isLoading = ref.watch(
    authNotifierProvider.select((state) => state.isLoading),
  );
  // ...
}

// Use RepaintBoundary for isolated animation areas
RepaintBoundary(
  child: AnimatedDashboardChart(data: chartData),
)
```

### List Performance

```dart
ListView.builder(
  // Always set for large lists
  cacheExtent: 500,
  addRepaintBoundaries: true,
  itemCount: items.length,
  itemBuilder: (_, index) => ItemCard(item: items[index]),
)
```

### Image Performance

```dart
CachedNetworkImage(
  imageUrl: url,
  memCacheWidth: 300,  // Decode at display size, not full res
  placeholder: (_, __) => const ShimmerBox(),
  errorWidget: (_, __, ___) => const PlaceholderAvatar(),
)
```

### Performance Checklist

- ✅ Run `flutter analyze` + `dart fix` in CI
- ✅ Enable `flutter run --profile` for realistic performance testing
- ✅ Set image `memCacheWidth`/`memCacheHeight` for large images
- ✅ Use `Selector` / `.select()` to minimize widget rebuilds
- ✅ Defer heavy computation with `compute()` or Isolates
- ✅ Lazy-load feature modules with deferred imports
- ✅ Measure with Flutter DevTools before optimizing

---

## 15. CI/CD & Dev Tooling

### Recommended CI Pipeline (GitHub Actions)

```yaml
# .github/workflows/ci.yml
name: CI

on: [push, pull_request]

jobs:
  analyze-and-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.27.x'
          channel: 'stable'
          cache: true

      - run: flutter pub get
      - run: dart run build_runner build --delete-conflicting-outputs
      - run: flutter analyze --fatal-infos
      - run: flutter test --coverage
      - run: dart pub global activate lcov_report
      # Enforce >80% coverage
      - run: lcov --summary coverage/lcov.info
```

### Required Dev Tools

```yaml
# pubspec.yaml — dev_dependencies
dev_dependencies:
  flutter_test:
    sdk: flutter
  mocktail: ^1.0.4
  build_runner: ^2.4.13
  freezed: ^2.5.7
  json_serializable: ^6.8.0
  riverpod_generator: ^2.4.3
  go_router_builder: ^2.7.1
  very_good_analysis: ^6.0.0   # Strict lint rules
  patrol: ^3.6.0               # E2E testing
```

### analysis_options.yaml

```yaml
include: package:very_good_analysis/analysis_options.yaml

linter:
  rules:
    prefer_const_constructors: true
    prefer_const_widgets: true
    avoid_print: true
    always_use_package_imports: true
```

---

## 16. Recommended Tech Stack

| Category | Package | Reason |
|---|---|---|
| **State** | `riverpod` + `riverpod_generator` | Compile-safe, testable, scales well |
| **Routing** | `go_router` + `go_router_builder` | Deep linking, type-safe routes |
| **Networking** | `dio` + `retrofit` | Interceptors, code-gen endpoints |
| **Models** | `freezed` + `json_serializable` | Immutable, copyWith, pattern matching |
| **Local DB** | `isar` | Blazing fast, Flutter-native NoSQL |
| **Secure Storage** | `flutter_secure_storage` | Keychain / Keystore integration |
| **Images** | `cached_network_image` | LRU cache, placeholders |
| **Connectivity** | `connectivity_plus` | Network monitoring |
| **Analytics** | `firebase_analytics` | Industry standard |
| **Crash Reports** | `firebase_crashlytics` | Real-time crash tracking |
| **Localization** | `flutter_localizations` + `intl` | Official, ARB-based |
| **Environment** | `--dart-define-from-file` | No env secrets in code |
| **Linting** | `very_good_analysis` | Strict, opinionated, production-grade |
| **E2E Tests** | `patrol` | Native Flutter UI testing |
| **Logging** | `logger` | Colorized, structured logs |

---

## 17. Enterprise Design Principles

### 1. Feature Isolation — Hard Rule

```
✅ CORRECT
features/booking  →  features/payments (via shared domain entity)
features/booking  →  shared/models/pagination_model.dart

❌ WRONG
features/booking/presentation/providers  →  features/payments/data/datasources
```

### 2. One Source of Truth per Domain

Each concept (User, Order, Product) has **one canonical entity** in domain. Every feature maps to it. No duplicate models floating around.

### 3. No Business Logic in Widgets

```dart
// ❌ Business logic in widget
onPressed: () {
  if (cart.isNotEmpty && user.balance >= total) {
    // process payment...
  }
},

// ✅ Delegate to use case via notifier
onPressed: () => ref.read(checkoutNotifierProvider.notifier).submit(),
```

### 4. Theme Driven — No Raw Values

```dart
// ❌ Never
color: const Color(0xFF0A84FF),
padding: const EdgeInsets.all(16),
borderRadius: BorderRadius.circular(12),

// ✅ Always
color: context.colors.primary,
padding: const EdgeInsets.all(AppSpacing.md),
borderRadius: BorderRadius.circular(AppRadius.md),
```

### 5. Responsive by Default

```dart
// ❌ Fixed pixel sizes
SizedBox(width: 320, child: ...)

// ✅ Adaptive
ConstrainedBox(
  constraints: BoxConstraints(maxWidth: context.isDesktop ? 480 : double.infinity),
  child: ...
)
```

---

## 18. Multi-Platform Strategy

```dart
// design_system/layouts/adaptive_scaffold.dart
class AdaptiveScaffold extends StatelessWidget {
  final Widget body;
  final List<NavDestination> destinations;

  const AdaptiveScaffold({
    super.key,
    required this.body,
    required this.destinations,
  });

  @override
  Widget build(BuildContext context) {
    if (context.isDesktop) {
      return Row(children: [
        AppSidebar(destinations: destinations),
        Expanded(child: body),
      ]);
    }
    if (context.isTablet) {
      return Scaffold(
        body: Row(children: [
          NavigationRail(destinations: destinations.toRailDestinations()),
          Expanded(child: body),
        ]),
      );
    }
    return Scaffold(
      body: body,
      bottomNavigationBar: AppBottomNav(destinations: destinations),
    );
  }
}
```

### Platform Matrix

| Feature | Mobile | Tablet | Web | Desktop |
|---|---|---|---|---|
| Navigation | Bottom Nav | Rail | Sidebar | Sidebar |
| Layout | Single column | Two column | Two/Three column | Three column |
| Input | Touch, gestures | Touch + keyboard | Mouse + keyboard | Mouse + keyboard |
| Typography scale | Base | +2pt | +4pt | +4pt |
| Card density | Comfortable | Standard | Compact | Compact |

---

## 19. Common Anti-Patterns to Avoid

| ❌ Anti-Pattern | ✅ Solution |
|---|---|
| `BuildContext` across async gaps | Use `mounted` check or Riverpod listener |
| `setState` in large screens | Extract to Notifier / Riverpod state |
| Passing `WidgetRef` deep into widget trees | Use `ConsumerWidget` locally |
| Repository calling another repository | Use Use Case to orchestrate |
| Hardcoded Strings in UI | Use l10n ARB keys |
| `navigator.push()` with route string literals | Use typed GoRouter routes |
| `print()` for logging | Use `Logger` with levels |
| Using `context.read()` in `build()` | Use `context.watch()` / `ref.watch()` |
| Giant 2000-line screens | Decompose into organisms + molecules |
| Mixing DTOs and Entities | Strict mapper layer between data/domain |

---

## 20. Migration Path from Legacy Structure

If you're migrating from a flat structure (`screens/`, `models/`, `providers/`):

### Phase 1 — Extract Core (Week 1)
- Move `dio` setup → `core/api/`
- Move router → `core/routing/`
- Move global utils → `core/utils/`

### Phase 2 — Create Design System (Week 2–3)
- Extract all colors → `design_system/tokens/colors.dart`
- Extract all text styles → `design_system/tokens/typography.dart`
- Extract spacing constants → `design_system/tokens/spacing.dart`
- Wrap repeated UI into atoms/molecules

### Phase 3 — Introduce Domain Layer (Week 3–4)
- Create abstract repository interfaces for each feature
- Write use cases for business logic (start with auth)

### Phase 4 — Slice Features (Ongoing)
- Move one feature at a time into `/features/featureName/`
- Apply data → domain → presentation structure per feature
- Migrate from `setState` / `Provider` to `Riverpod` one screen at a time

> ⚠️ Never do a "big bang" rewrite. Migrate feature by feature. Your app must ship throughout.

---

## Summary

For modern enterprise Flutter in 2026, the winning combination is:

| Pillar | Choice |
|---|---|
| Structure | Feature-first modular + Clean Architecture |
| UI | Atomic Design System with design tokens |
| State | Riverpod (code-generated, type-safe) |
| Routing | GoRouter with typed routes + guards |
| Networking | Dio + Retrofit + sealed Result type |
| Data | Freezed + JSON Serializable + Isar |
| Testing | Unit + Widget + Patrol E2E |
| DX | very_good_analysis + build_runner + CI |

This architecture delivers:

- 🚀 **Scalability** — Add features without touching existing ones
- 🤝 **Team Collaboration** — Feature ownership is clear
- 🧪 **Testability** — Every layer independently testable
- 🎨 **UI Consistency** — Design tokens propagate everywhere
- 🔒 **Security** — Encrypted storage, token refresh, obfuscation
- 📱 **Multi-Platform** — Mobile, Tablet, Web, Desktop from one codebase
- ⚡ **Performance** — Lazy loading, selective rebuilds, image caching
- 🔧 **Maintainability** — Strict boundaries, typed errors, clean contracts

---

*Flutter Enterprise Architecture Guide — 2026 Edition*
*Covers Flutter 3.27+ / Dart 3.6+ / Riverpod 2.x / GoRouter 14.x*