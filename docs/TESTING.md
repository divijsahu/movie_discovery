# 🧪 Testing Guide

## Overview

This guide covers testing strategies for each layer of the clean architecture.

## Testing Pyramid

```
       ┌──────────┐
       │ E2E Tests │   (Few)
      ┌┴──────────┴┐
     │ Widget Tests │  (Some)
    ┌┴────────────┴┐
   │   Unit Tests   │ (Many)
  └────────────────┘
```

## Unit Tests (Domain & Data Layers)

### Testing Use Cases

```dart
// test/features/auth/domain/usecases/login_usecase_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;
  
  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(mockRepository);
  });
  
  group('LoginUseCase', () {
    test('should return user on successful login', () async {
      // Arrange
      const testUser = UserEntity(id: '1', email: 'test@example.com');
      when(() => mockRepository.login(any(), any()))
          .thenAnswer((_) async => const Success(testUser));
      
      // Act
      final result = await useCase.execute(
        const LoginParams(email: 'test@example.com', password: 'password'),
      );
      
      // Assert
      expect(result, isA<Success<UserEntity>>());
      result.when(
        success: (user) => expect(user, testUser),
        failure: (_) => fail('Should not fail'),
      );
    });
    
    test('should return failure on invalid credentials', () async {
      // Arrange
      when(() => mockRepository.login(any(), any()))
          .thenAnswer((_) async => const Failure(UnauthorizedFailure()));
      
      // Act
      final result = await useCase.execute(
        const LoginParams(email: 'test@example.com', password: 'wrong'),
      );
      
      // Assert
      expect(result, isA<Failure<UserEntity>>());
      result.when(
        success: (_) => fail('Should not succeed'),
        failure: (error) => expect(error, isA<UnauthorizedFailure>()),
      );
    });
  });
}
```

### Testing Repositories

```dart
// test/features/auth/data/repositories/auth_repository_impl_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockDataSource;
  
  setUp(() {
    mockDataSource = MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(mockDataSource);
  });
  
  group('AuthRepositoryImpl', () {
    test('should return user entity when data source succeeds', () async {
      // Arrange
      final testDto = UserDto(id: '1', email: 'test@example.com');
      when(() => mockDataSource.login(any(), any()))
          .thenAnswer((_) async => testDto);
      
      // Act
      final result = await repository.login('test@example.com', 'password');
      
      // Assert
      expect(result, isA<Success<UserEntity>>());
      verify(() => mockDataSource.login('test@example.com', 'password')).called(1);
    });
    
    test('should return server failure when data source throws', () async {
      // Arrange
      when(() => mockDataSource.login(any(), any()))
          .thenThrow(Exception('Server error'));
      
      // Act
      final result = await repository.login('test@example.com', 'password');
      
      // Assert
      expect(result, isA<Failure<UserEntity>>());
      result.when(
        success: (_) => fail('Should not succeed'),
        failure: (error) => expect(error, isA<ServerFailure>()),
      );
    });
  });
}
```

## Widget Tests (Presentation Layer)

### Testing Screens

```dart
// test/features/home/presentation/screens/home_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app_template/features/home/presentation/screens/home_screen.dart';

void main() {
  testWidgets('HomeScreen displays welcome message', (tester) async {
    // Arrange & Act
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );
    
    // Assert
    expect(find.text('Welcome to Flutter App Template!'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
  });
  
  testWidgets('HomeScreen button is tappable', (tester) async {
    // Arrange
    bool buttonPressed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrimaryButton(
            label: 'Test Button',
            onPressed: () => buttonPressed = true,
          ),
        ),
      ),
    );
    
    // Act
    await tester.tap(find.text('Test Button'));
    await tester.pump();
    
    // Assert
    expect(buttonPressed, true);
  });
}
```

### Testing Widgets

```dart
// test/design_system/atoms/buttons/primary_button_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app_template/design_system/atoms/buttons/primary_button.dart';

void main() {
  group('PrimaryButton', () {
    testWidgets('displays label correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              label: 'Test Label',
              onPressed: () {},
            ),
          ),
        ),
      );
      
      expect(find.text('Test Label'), findsOneWidget);
    });
    
    testWidgets('shows loading indicator when isLoading is true', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              label: 'Test',
              isLoading: true,
            ),
          ),
        ),
      );
      
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Test'), findsNothing);
    });
    
    testWidgets('is disabled when onPressed is null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              label: 'Test',
              onPressed: null,
            ),
          ),
        ),
      );
      
      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
    });
    
    testWidgets('displays prefix icon when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              label: 'Test',
              prefixIcon: const Icon(Icons.check),
              onPressed: () {},
            ),
          ),
        ),
      );
      
      expect(find.byIcon(Icons.check), findsOneWidget);
    });
  });
}
```

## Integration Tests

### Testing Feature Flow

```dart
// integration_test/app_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_app_template/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('App Integration Tests', () {
    testWidgets('complete user flow', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      // Verify home screen
      expect(find.text('Welcome to Flutter App Template!'), findsOneWidget);
      
      // Tap get started button
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();
      
      // Add more flow steps...
    });
  });
}
```

## Test Utilities

### Mock Data

```dart
// test/fixtures/test_data.dart
import 'package:flutter_app_template/features/auth/domain/entities/user_entity.dart';

class TestData {
  static const testUser = UserEntity(
    id: '1',
    email: 'test@example.com',
    name: 'Test User',
  );
  
  static const testUsers = [
    UserEntity(id: '1', email: 'user1@example.com', name: 'User 1'),
    UserEntity(id: '2', email: 'user2@example.com', name: 'User 2'),
  ];
}
```

### Test Helpers

```dart
// test/helpers/pump_app.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(Widget widget) {
    return pumpWidget(
      MaterialApp(
        home: widget,
      ),
    );
  }
}

// Usage
await tester.pumpApp(MyWidget());
```

## Running Tests

### Run All Tests
```bash
flutter test
```

### Run Specific Test File
```bash
flutter test test/features/auth/domain/usecases/login_usecase_test.dart
```

### Run Tests with Coverage
```bash
flutter test --coverage
```

### Generate Coverage Report
```bash
# Install lcov (macOS)
brew install lcov

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# Open report
open coverage/html/index.html
```

### Run Integration Tests
```bash
flutter test integration_test/app_test.dart
```

## Test Coverage Goals

- **Domain Layer**: 100% coverage
- **Data Layer**: 90%+ coverage
- **Presentation Layer**: 70%+ coverage
- **Overall**: 80%+ coverage

## Best Practices

### DO ✅
- Write tests before or alongside code (TDD)
- Test business logic thoroughly
- Use descriptive test names
- Follow AAA pattern (Arrange, Act, Assert)
- Mock external dependencies
- Test edge cases and error scenarios
- Keep tests independent
- Use test fixtures for common data

### DON'T ❌
- Test implementation details
- Write flaky tests
- Skip error case testing
- Test framework code
- Make tests dependent on each other
- Hardcode test data everywhere
- Ignore failing tests

## Test Organization

```
test/
├── features/
│   └── auth/
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   └── usecases/
│       └── presentation/
│           ├── screens/
│           └── widgets/
├── design_system/
│   ├── atoms/
│   └── layouts/
├── fixtures/
│   └── test_data.dart
└── helpers/
    └── pump_app.dart
```

## Continuous Integration

### GitHub Actions Example

```yaml
# .github/workflows/test.yml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.4.4'
      - run: flutter pub get
      - run: flutter test --coverage
      - run: flutter analyze
```

## Debugging Tests

### Print Debug Info
```dart
test('my test', () {
  debugPrint('Debug info: $value');
  // test code
});
```

### Run Single Test
```dart
test('my test', () {
  // test code
}, skip: false); // Remove skip to run only this test
```

### Use Test Tags
```dart
@Tags(['unit', 'auth'])
test('login test', () {
  // test code
});

// Run: flutter test --tags=auth
```

---

**Remember**: Good tests are your safety net for refactoring and adding new features!
