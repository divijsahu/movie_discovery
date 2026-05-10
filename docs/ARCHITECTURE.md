# 🏗️ Architecture Guide

## Overview

This template follows the **2026 Enterprise Flutter Architecture** - a hybrid of Clean Architecture, Feature-First organization, and Design System principles.

## Core Principles

### 1. Feature Isolation
Each feature is a vertical slice containing all its layers:
```
features/
  └── feature_name/
      ├── data/          # External data sources
      ├── domain/        # Business logic
      └── presentation/  # UI layer
```

### 2. Dependency Rule
```
┌─────────────────────────────────────┐
│         PRESENTATION                │
│    (Screens, Widgets, State)        │
├─────────────────────────────────────┤
│           DOMAIN                    │
│  (Entities, UseCases, Contracts)    │
├─────────────────────────────────────┤
│            DATA                     │
│  (APIs, DB, Repository Impls)       │
└─────────────────────────────────────┘
```

**Rule**: Dependencies point inward. Domain knows nothing about outer layers.

### 3. Design Token Driven
All visual properties come from design tokens:
- `AppColors` - Color palette
- `AppTypography` - Text styles
- `AppSpacing` - Spacing values
- `AppBreakpoints` - Responsive breakpoints

### 4. Type-Safe Error Handling
Use `Result<T>` instead of throwing exceptions:
```dart
Future<Result<User>> getUser() async {
  try {
    final user = await api.fetchUser();
    return Success(user);
  } catch (e) {
    return Failure(NetworkFailure());
  }
}
```

## Layer Breakdown

### Core Layer
Infrastructure that all features depend on:
- **base/**: Base classes (UseCase, Repository)
- **errors/**: Failure types
- **network/**: Result type, connectivity
- **constants/**: App-wide constants

### Design System Layer
Visual building blocks:
- **tokens/**: Design tokens (colors, spacing, etc.)
- **atoms/**: Basic components (buttons, inputs)
- **molecules/**: Composite components (cards, list items)
- **organisms/**: Complex components (headers, forms)
- **layouts/**: Layout components (responsive wrappers)

### Shared Layer
Code shared across features:
- **extensions/**: Dart extensions
- **helpers/**: Utility functions
- **widgets/**: Reusable widgets
- **models/**: Shared data models

### Features Layer
Business features organized by domain:
```
features/
  └── auth/
      ├── data/
      │   ├── datasources/      # API, local DB
      │   ├── models/           # DTOs
      │   └── repositories/     # Repository implementations
      ├── domain/
      │   ├── entities/         # Business models
      │   ├── repositories/     # Repository contracts
      │   └── usecases/         # Business logic
      └── presentation/
          ├── screens/          # Full screens
          ├── widgets/          # Feature-specific widgets
          └── providers/        # State management
```

## Adding a New Feature

### Step 1: Create Structure
```bash
mkdir -p lib/features/my_feature/{data/{datasources,models,repositories},domain/{entities,repositories,usecases},presentation/{screens,widgets,providers}}
```

### Step 2: Define Domain
```dart
// domain/entities/my_entity.dart
class MyEntity {
  final String id;
  final String name;
  
  MyEntity({required this.id, required this.name});
}

// domain/repositories/my_repository.dart
abstract class MyRepository {
  Future<Result<MyEntity>> getEntity(String id);
}

// domain/usecases/get_entity_usecase.dart
class GetEntityUseCase extends BaseUseCase<MyEntity, String> {
  final MyRepository repository;
  
  GetEntityUseCase(this.repository);
  
  @override
  Future<Result<MyEntity>> execute(String id) {
    return repository.getEntity(id);
  }
}
```

### Step 3: Implement Data
```dart
// data/models/my_entity_dto.dart
class MyEntityDto {
  final String id;
  final String name;
  
  factory MyEntityDto.fromJson(Map<String, dynamic> json) {
    return MyEntityDto(
      id: json['id'],
      name: json['name'],
    );
  }
  
  MyEntity toEntity() => MyEntity(id: id, name: name);
}

// data/datasources/my_remote_datasource.dart
class MyRemoteDataSource {
  Future<MyEntityDto> fetchEntity(String id) async {
    // API call
  }
}

// data/repositories/my_repository_impl.dart
class MyRepositoryImpl implements MyRepository {
  final MyRemoteDataSource dataSource;
  
  MyRepositoryImpl(this.dataSource);
  
  @override
  Future<Result<MyEntity>> getEntity(String id) async {
    try {
      final dto = await dataSource.fetchEntity(id);
      return Success(dto.toEntity());
    } catch (e) {
      return Failure(ServerFailure('Failed to fetch entity'));
    }
  }
}
```

### Step 4: Build Presentation
```dart
// presentation/screens/my_screen.dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Feature')),
      body: ResponsiveLayout(
        mobile: _MobileLayout(),
        tablet: _TabletLayout(),
      ),
    );
  }
}
```

## Best Practices

### DO ✅
- Use design tokens for all visual properties
- Keep features isolated
- Use Result type for error handling
- Make layouts responsive
- Write tests for business logic
- Use context extensions

### DON'T ❌
- Hardcode colors, spacing, or text
- Import from other features
- Throw exceptions in repositories
- Skip error handling
- Assume screen size
- Put business logic in widgets

## Testing Strategy

### Unit Tests (Domain Layer)
```dart
test('GetEntityUseCase returns entity on success', () async {
  final mockRepo = MockMyRepository();
  final useCase = GetEntityUseCase(mockRepo);
  when(() => mockRepo.getEntity(any()))
      .thenAnswer((_) async => Success(testEntity));
  
  final result = await useCase.execute('123');
  
  expect(result, isA<Success<MyEntity>>());
});
```

### Widget Tests (Presentation Layer)
```dart
testWidgets('MyScreen displays entity name', (tester) async {
  await tester.pumpWidget(
    MaterialApp(home: MyScreen()),
  );
  
  expect(find.text('Entity Name'), findsOneWidget);
});
```

## Performance Tips

1. **Use const constructors** wherever possible
2. **Lazy load features** with deferred imports
3. **Cache network images** with CachedNetworkImage
4. **Optimize list rendering** with ListView.builder
5. **Profile before optimizing** with Flutter DevTools

---

For more details, see:
- [Enterprise Architecture](ENTERPRISE_ARCHITECTURE.md) - Full enterprise patterns
- [Design System Guide](DESIGN_SYSTEM.md) - Design system usage
- [Feature Development](FEATURE_DEVELOPMENT.md) - Step-by-step feature guide
