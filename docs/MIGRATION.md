# 🔄 Migration Guide: Old Template → 2026 Architecture

This guide helps you migrate from the old template structure to the new 2026 Enterprise Architecture.

## Overview of Changes

### Old Structure
```
lib/
├── models/
├── pages/
├── providers/
├── services/
└── utils/
```

### New Structure
```
lib/
├── core/              # Infrastructure
├── design_system/     # UI components & tokens
├── shared/            # Shared utilities
├── features/          # Feature modules
├── app/               # App configuration
└── l10n/              # Localization
```

## Step-by-Step Migration

### Step 1: Backup Your Code
```bash
git checkout -b migration-backup
git commit -am "Backup before migration"
```

### Step 2: Update Dependencies

**Old pubspec.yaml:**
```yaml
dependencies:
  flutter:
    sdk: flutter
  intl: ^0.19.0
```

**New pubspec.yaml:**
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  intl: ^0.20.2

flutter:
  generate: true
```

Run:
```bash
flutter pub get
```

### Step 3: Create l10n.yaml
```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

### Step 4: Migrate Models → Domain Entities

**Old:** `lib/models/your_data_model.dart`
```dart
class YourDataModel {
  final String id;
  final String name;
  // ...
}
```

**New:** `lib/features/your_feature/domain/entities/your_entity.dart`
```dart
class YourEntity {
  final String id;
  final String name;
  
  const YourEntity({
    required this.id,
    required this.name,
  });
}
```

### Step 5: Migrate Services → Data Sources

**Old:** `lib/services/your_api_service.dart`
```dart
class YourApiService {
  Future<YourDataModel> getData() async {
    // API call
  }
}
```

**New:** `lib/features/your_feature/data/datasources/your_remote_datasource.dart`
```dart
abstract class YourRemoteDataSource {
  Future<YourDto> getData();
}

class YourRemoteDataSourceImpl implements YourRemoteDataSource {
  @override
  Future<YourDto> getData() async {
    // API call
  }
}
```

### Step 6: Create Repository Layer

**New:** `lib/features/your_feature/domain/repositories/your_repository.dart`
```dart
abstract class YourRepository {
  Future<Result<YourEntity>> getData();
}
```

**New:** `lib/features/your_feature/data/repositories/your_repository_impl.dart`
```dart
class YourRepositoryImpl implements YourRepository {
  final YourRemoteDataSource dataSource;
  
  YourRepositoryImpl(this.dataSource);
  
  @override
  Future<Result<YourEntity>> getData() async {
    try {
      final dto = await dataSource.getData();
      return Success(dto.toEntity());
    } catch (e) {
      return Failure(ServerFailure('Failed to fetch data'));
    }
  }
}
```

### Step 7: Migrate Providers → Use Cases + State

**Old:** `lib/providers/your_provider.dart`
```dart
class YourProvider extends ChangeNotifier {
  List<YourDataModel> _items = [];
  
  Future<void> fetchItems() async {
    _items = await _apiService.getAllItems();
    notifyListeners();
  }
}
```

**New:** `lib/features/your_feature/domain/usecases/get_items_usecase.dart`
```dart
class GetItemsUseCase extends BaseUseCase<List<YourEntity>, NoParams> {
  final YourRepository repository;
  
  GetItemsUseCase(this.repository);
  
  @override
  Future<Result<List<YourEntity>>> execute(NoParams params) {
    return repository.getItems();
  }
}
```

**New:** `lib/features/your_feature/presentation/providers/your_provider.dart`
```dart
// Use Riverpod, Bloc, or your preferred state management
```

### Step 8: Migrate Pages → Screens

**Old:** `lib/pages/home_page.dart`
```dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Home'),
    );
  }
}
```

**New:** `lib/features/home/presentation/screens/home_screen.dart`
```dart
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.home)),
      body: ResponsiveLayout(
        mobile: _MobileLayout(),
        tablet: _TabletLayout(),
      ),
    );
  }
}
```

### Step 9: Extract Design Tokens

**Old:** `lib/utils/color.dart`
```dart
class AppColors {
  static const Color primary = Color(0xFFFFCFA3);
  // Hardcoded everywhere
}
```

**New:** `lib/design_system/tokens/colors.dart`
```dart
class AppColors {
  static const Color primary = Color(0xFF0A84FF);
  // Used via context.colors.primary
}
```

### Step 10: Update Theme Usage

**Old:**
```dart
Container(
  color: AppColors.primary,
  padding: EdgeInsets.all(16),
)
```

**New:**
```dart
Container(
  color: context.colors.primary,
  padding: AppSpacing.pagePadding,
)
```

### Step 11: Add Localization

**Create:** `lib/l10n/app_en.arb`
```json
{
  "@@locale": "en",
  "appTitle": "Your App Name",
  "home": "Home",
  "settings": "Settings"
}
```

**Update widgets:**
```dart
// Old
Text('Home')

// New
Text(context.l10n.home)
```

### Step 12: Update Main App

**Old:** `lib/main.dart`
```dart
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App',
      theme: AppTheme.lightTheme,
      home: HomePage(),
    );
  }
}
```

**New:** `lib/main.dart`
```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}
```

**New:** `lib/app/app.dart`
```dart
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.APP_NAME,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomeScreen(),
    );
  }
}
```

## Common Migration Patterns

### Pattern 1: API Call with Error Handling

**Old:**
```dart
try {
  final data = await apiService.getData();
  return data;
} catch (e) {
  throw Exception('Error: $e');
}
```

**New:**
```dart
try {
  final dto = await dataSource.getData();
  return Success(dto.toEntity());
} catch (e) {
  return Failure(ServerFailure('Failed to fetch data'));
}
```

### Pattern 2: Loading States

**Old:**
```dart
bool _isLoading = false;

void fetchData() async {
  _isLoading = true;
  notifyListeners();
  
  final data = await api.getData();
  
  _isLoading = false;
  notifyListeners();
}
```

**New:**
```dart
// Use AsyncValue with Riverpod or similar pattern
@riverpod
Future<List<Item>> items(ItemsRef ref) async {
  final result = await ref.read(getItemsUseCaseProvider).execute(NoParams());
  return result.when(
    success: (data) => data,
    failure: (error) => throw error,
  );
}
```

### Pattern 3: Responsive UI

**Old:**
```dart
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > 600) {
      return TabletLayout();
    }
    return MobileLayout();
  },
)
```

**New:**
```dart
ResponsiveLayout(
  mobile: MobileLayout(),
  tablet: TabletLayout(),
  desktop: DesktopLayout(),
)
```

## Checklist

- [ ] Update pubspec.yaml with new dependencies
- [ ] Create l10n.yaml configuration
- [ ] Create ARB files for each language
- [ ] Run `flutter gen-l10n`
- [ ] Migrate models to domain entities
- [ ] Create data sources from services
- [ ] Implement repository layer
- [ ] Create use cases for business logic
- [ ] Migrate providers to new state management
- [ ] Migrate pages to feature screens
- [ ] Extract design tokens
- [ ] Update all hardcoded strings to use l10n
- [ ] Update theme usage to use context extensions
- [ ] Test all features
- [ ] Update documentation

## Testing After Migration

```bash
# Generate localization
flutter gen-l10n

# Get dependencies
flutter pub get

# Run app
flutter run

# Run tests
flutter test

# Check for issues
flutter analyze
```

## Troubleshooting

### Issue: Localization not working
**Solution:** Make sure you've:
1. Created l10n.yaml
2. Added ARB files
3. Run `flutter gen-l10n`
4. Added `flutter_localizations` to pubspec.yaml
5. Added `generate: true` in pubspec.yaml

### Issue: Import errors
**Solution:** Update imports to new structure:
```dart
// Old
import 'package:app/models/user.dart';

// New
import 'package:app/features/auth/domain/entities/user_entity.dart';
```

### Issue: Theme not applying
**Solution:** Use context extensions:
```dart
// Instead of
Theme.of(context).colorScheme.primary

// Use
context.colors.primary
```

## Need Help?

- Check [ARCHITECTURE.md](ARCHITECTURE.md) for detailed architecture guide
- See [README.md](README.md) for quick start guide
- Review example code in `lib/features/home/`

---

**Migration Time Estimate:**
- Small app (< 10 screens): 2-4 hours
- Medium app (10-30 screens): 1-2 days
- Large app (30+ screens): 3-5 days

Take it step by step, test frequently, and don't hesitate to refactor as you go!
