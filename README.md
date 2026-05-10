# 🚀 Flutter App Template - 2026 Enterprise Architecture

[![Flutter Version](https://img.shields.io/badge/Flutter-3.4.4+-blue.svg)](https://flutter.dev/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/divijsahu/flutter-app-template/pulls)

A production-ready Flutter app template following 2026 enterprise architecture principles with clean code, modular design system, and scalable structure. Perfect for starting new projects or learning best practices.

## ✨ Features

- 🏗️ **Clean Architecture** - Domain-driven design with clear separation of concerns
- 🎨 **Design System** - Token-based design with atoms, molecules, and organisms
- 📱 **Responsive** - Mobile, tablet, and desktop layouts out of the box
- 🎯 **Type-Safe** - Result types for robust error handling
- ⚡ **Performance** - Optimized with Flutter best practices
- 🧪 **Testable** - Every layer independently testable
- 📚 **Well Documented** - Comprehensive guides and examples
- 🔧 **Production Ready** - Battle-tested architecture patterns

## 🎯 Who Is This For?

- **Startups** building scalable Flutter apps
- **Enterprise teams** needing maintainable architecture
- **Solo developers** wanting best practices
- **Students** learning Flutter architecture
- **Teams** requiring consistent code structure

## 📁 Project Structure

```
lib/
├── core/                      # Core infrastructure
│   ├── base/                  # Base classes (UseCase, etc.)
│   ├── errors/                # Failure types
│   ├── network/               # Result type, network utilities
│   └── constants/             # App-wide constants
│
├── design_system/             # Design tokens & components
│   ├── tokens/                # Colors, typography, spacing, breakpoints
│   ├── theme/                 # Theme configuration
│   ├── atoms/                 # Basic UI components (buttons, inputs)
│   ├── molecules/             # Composite components
│   ├── organisms/             # Complex components
│   └── layouts/               # Layout components (responsive)
│
├── shared/                    # Shared across features
│   ├── extensions/            # Context, String extensions
│   ├── helpers/               # Snackbar, dialog helpers
│   └── widgets/               # Reusable widgets
│
├── features/                  # Feature modules
│   └── home/
│       ├── data/              # Data sources, DTOs, repositories
│       ├── domain/            # Entities, use cases, contracts
│       └── presentation/      # Screens, widgets, providers
│
└── app/                       # App configuration
    └── app.dart               # Root app widget
```

## 🚀 Quick Start

### 1. Use This Template

Click the **"Use this template"** button at the top of this repository, or:

```bash
# Clone the repository
git clone https://github.com/divijsahu/flutter-app-template.git your-app-name
cd your-app-name

# Remove git history and start fresh
rm -rf .git
git init
git add .
git commit -m "Initial commit from template"
```

### 2. Setup Your Project

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Run tests
flutter test

# Check for issues
flutter analyze
```

### 3. Customize

1. **Update app name** in `pubspec.yaml`
2. **Change package name**: `flutter pub run change_app_package_name:main com.yourcompany.yourapp`
3. **Update constants** in `lib/core/constants/app_constants.dart`
4. **Customize theme** in `lib/design_system/tokens/`
5. **Add your features** in `lib/features/`

## 📖 Documentation

### Quick Guides
- **[Architecture Guide](docs/ARCHITECTURE.md)** - Detailed architecture breakdown
- **[Design System Guide](docs/DESIGN_SYSTEM.md)** - Using design tokens and components
- **[Feature Development](docs/FEATURE_DEVELOPMENT.md)** - Adding new features
- **[Testing Guide](docs/TESTING.md)** - Writing tests

### Reference
- **[Enterprise Architecture](docs/ENTERPRISE_ARCHITECTURE.md)** - Full enterprise patterns
- **[Best Practices](docs/BEST_PRACTICES.md)** - Coding standards and conventions

## 🎨 Design System Usage

### Using Design Tokens

```dart
// Colors
Container(color: AppColors.primary)

// Spacing
Padding(padding: AppSpacing.pagePadding)

// Typography
Text('Hello', style: AppTypography.headlineMedium)

// Breakpoints
if (MediaQuery.of(context).size.width >= AppBreakpoints.tablet) {
  // Tablet layout
}
```

### Using Components

```dart
// Primary Button
PrimaryButton(
  label: 'Submit',
  onPressed: () {},
  isLoading: false,
)

// Responsive Layout
ResponsiveLayout(
  mobile: MobileWidget(),
  tablet: TabletWidget(),
  desktop: DesktopWidget(),
)
```

### Using Context Extensions

```dart
// Access theme
context.colors.primary
context.textTheme.bodyLarge

// Check device type
if (context.isMobile) { }
if (context.isTablet) { }
if (context.isDesktop) { }
```

## 🏗️ Architecture Principles

### 1. Feature Isolation
Each feature is self-contained with its own data, domain, and presentation layers.

### 2. Dependency Rule
```
Presentation → Domain ← Data
```
Domain knows nothing about other layers.

### 3. Result Type
Use `Result<T>` for error handling:
```dart
Future<Result<User>> login(String email, String password) async {
  try {
    final user = await api.login(email, password);
    return Success(user);
  } catch (e) {
    return Failure(NetworkFailure());
  }
}
```

### 4. Use Cases
Business logic lives in use cases:
```dart
class LoginUseCase extends BaseUseCase<User, LoginParams> {
  @override
  Future<Result<User>> execute(LoginParams params) {
    // Business logic here
  }
}
```

## 🔧 Adding a New Feature

```bash
# Create feature structure
mkdir -p lib/features/your_feature/{data,domain,presentation}/{datasources,models,repositories,entities,usecases,screens,widgets,providers}
```

Follow the clean architecture pattern:
1. **Domain**: Define entities and use cases
2. **Data**: Implement repositories and data sources
3. **Presentation**: Build UI with screens and widgets

See [Feature Development Guide](docs/FEATURE_DEVELOPMENT.md) for detailed steps.

## 📦 Recommended Packages

```yaml
dependencies:
  # State Management
  flutter_riverpod: ^2.5.0
  
  # Networking
  dio: ^5.4.0
  
  # Local Storage
  shared_preferences: ^2.2.0
  hive_flutter: ^1.1.0
  
  # Routing
  go_router: ^13.0.0
  
  # Code Generation
  freezed: ^2.4.0
  json_serializable: ^6.7.0
```

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## 📝 Best Practices

### DO ✅
- Use design tokens for all visual properties
- Follow clean architecture layers
- Use Result type for error handling
- Keep features isolated
- Use context extensions for common operations
- Make layouts responsive
- Write tests for business logic

### DON'T ❌
- Hardcode colors, spacing, or text
- Import from other features
- Throw exceptions in repositories
- Skip error handling
- Assume screen size
- Put business logic in widgets
- Repeat code across features

## 🌟 What's Included

### Core Infrastructure
- ✅ Base classes for UseCase and Repository
- ✅ Result type for error handling
- ✅ Failure types (Network, Server, Validation, etc.)
- ✅ App constants and configuration

### Design System
- ✅ Design tokens (colors, typography, spacing, breakpoints)
- ✅ Light and dark themes
- ✅ Atomic components (buttons, inputs, text)
- ✅ Responsive layouts
- ✅ Context extensions

### Example Feature
- ✅ Home feature with clean architecture
- ✅ Responsive home screen
- ✅ Example of proper layer separation

### Documentation
- ✅ Architecture guide
- ✅ Design system guide
- ✅ Feature development guide
- ✅ Testing guide
- ✅ Best practices

## 🔄 Updates and Maintenance

This template is actively maintained. To get updates:

```bash
# Add template as upstream
git remote add template https://github.com/divijsahu/flutter-app-template.git

# Fetch updates
git fetch template

# Merge updates (resolve conflicts if any)
git merge template/main --allow-unrelated-histories
```

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) first.

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Clean Architecture by Robert C. Martin
- Atomic Design by Brad Frost
- Flutter community for best practices

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/divijsahu/flutter-app-template/issues)
- **Discussions**: [GitHub Discussions](https://github.com/divijsahu/flutter-app-template/discussions)
- **Email**: your.email@example.com

## 🗺️ Roadmap

- [ ] Add authentication feature example
- [ ] Add API integration example
- [ ] Add state management examples (Riverpod, Bloc)
- [ ] Add routing example with GoRouter
- [ ] Add form validation examples
- [ ] Add animation examples
- [ ] Add testing examples for all layers
- [ ] Add CI/CD workflow examples

---

**Built with ❤️ using Flutter and 2026 Enterprise Architecture principles.**

**Star ⭐ this repo if you find it helpful!**
