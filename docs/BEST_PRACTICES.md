# 📝 Best Practices

## Code Organization

### DO ✅
- Keep features isolated and self-contained
- Use clear, descriptive names for files and classes
- Follow the established folder structure
- Group related functionality together
- Keep files under 300 lines when possible

### DON'T ❌
- Mix concerns across layers
- Create circular dependencies
- Use generic names like `utils.dart` or `helpers.dart`
- Put everything in one file
- Import from other features

## Clean Architecture

### DO ✅
- Respect the dependency rule (inward only)
- Keep domain layer pure (no Flutter dependencies)
- Use Result type for error handling
- Implement repository contracts in domain
- Keep use cases focused on single responsibility

### DON'T ❌
- Put business logic in widgets
- Access data sources directly from presentation
- Throw exceptions from repositories
- Mix data and domain models
- Skip the use case layer

## Design System

### DO ✅
- Always use design tokens
- Create reusable components
- Support light and dark themes
- Make components responsive
- Document component usage

### DON'T ❌
- Hardcode colors, spacing, or typography
- Create one-off components
- Ignore theme mode
- Assume screen size
- Skip accessibility

## State Management

### DO ✅
- Keep state close to where it's used
- Use immutable state objects
- Handle loading and error states
- Dispose resources properly
- Test state logic

### DON'T ❌
- Use global mutable state
- Forget to handle errors
- Rebuild entire tree unnecessarily
- Mix UI and business logic
- Skip loading states

## Error Handling

### DO ✅
- Use Result type for operations that can fail
- Provide meaningful error messages
- Log errors appropriately
- Show user-friendly error UI
- Handle network errors gracefully

### DON'T ❌
- Swallow exceptions silently
- Show technical errors to users
- Use try-catch everywhere
- Ignore error states
- Crash on errors

## Performance

### DO ✅
- Use const constructors
- Implement proper list builders
- Cache network images
- Lazy load when possible
- Profile before optimizing

### DON'T ❌
- Rebuild widgets unnecessarily
- Load all data at once
- Ignore memory leaks
- Optimize prematurely
- Skip performance testing

## Testing

### DO ✅
- Write tests for business logic
- Test error scenarios
- Use mocks for dependencies
- Keep tests independent
- Aim for 80%+ coverage

### DON'T ❌
- Test implementation details
- Skip edge cases
- Make tests dependent
- Ignore failing tests
- Test framework code

## Code Style

### DO ✅
- Follow Dart style guide
- Use meaningful variable names
- Write self-documenting code
- Add comments for complex logic
- Keep functions small and focused

### DON'T ❌
- Use abbreviations
- Write long functions
- Over-comment obvious code
- Use magic numbers
- Ignore linter warnings

## Git Practices

### DO ✅
- Write clear commit messages
- Make small, focused commits
- Use feature branches
- Review code before merging
- Keep main branch stable

### DON'T ❌
- Commit directly to main
- Make huge commits
- Use vague commit messages
- Skip code reviews
- Commit broken code

## Security

### DO ✅
- Store sensitive data securely
- Validate all user input
- Use HTTPS for API calls
- Implement proper authentication
- Keep dependencies updated

### DON'T ❌
- Hardcode API keys
- Trust user input
- Store passwords in plain text
- Skip input validation
- Ignore security warnings

## Documentation

### DO ✅
- Document public APIs
- Keep README updated
- Add inline comments for complex logic
- Document architecture decisions
- Provide usage examples

### DON'T ❌
- Over-document obvious code
- Let documentation get stale
- Skip API documentation
- Assume everyone knows the context
- Write unclear documentation

## Naming Conventions

### Files
```dart
// Screens
home_screen.dart
product_details_screen.dart

// Widgets
product_card.dart
user_avatar.dart

// Use Cases
get_products_usecase.dart
create_order_usecase.dart

// Repositories
product_repository.dart
product_repository_impl.dart

// Models
product_entity.dart
product_dto.dart
```

### Classes
```dart
// Screens
class HomeScreen extends StatelessWidget {}

// Widgets
class ProductCard extends StatelessWidget {}

// Use Cases
class GetProductsUseCase extends BaseUseCase {}

// Repositories
abstract class ProductRepository {}
class ProductRepositoryImpl implements ProductRepository {}

// Entities
class ProductEntity {}

// DTOs
class ProductDto {}
```

### Variables
```dart
// Use descriptive names
final productList = <Product>[];
final isLoading = false;
final errorMessage = 'Failed to load';

// Not
final list = [];
final flag = false;
final msg = '';
```

## Code Review Checklist

- [ ] Follows clean architecture principles
- [ ] Uses design tokens (no hardcoded values)
- [ ] Handles errors properly
- [ ] Includes tests
- [ ] Responsive design
- [ ] No console logs in production
- [ ] Follows naming conventions
- [ ] Documentation updated
- [ ] No TODO comments
- [ ] Passes all tests
- [ ] No linter warnings

## Common Pitfalls

### 1. Mixing Layers
```dart
// ❌ BAD: Accessing data source from widget
class MyWidget extends StatelessWidget {
  final ApiService api;
  
  Future<void> loadData() async {
    final data = await api.fetchData();
  }
}

// ✅ GOOD: Using use case
class MyWidget extends StatelessWidget {
  final GetDataUseCase useCase;
  
  Future<void> loadData() async {
    final result = await useCase.execute(NoParams());
  }
}
```

### 2. Hardcoding Values
```dart
// ❌ BAD
Container(
  color: Color(0xFF0A84FF),
  padding: EdgeInsets.all(16),
)

// ✅ GOOD
Container(
  color: AppColors.primary,
  padding: AppSpacing.pagePadding,
)
```

### 3. Not Handling Errors
```dart
// ❌ BAD
final data = await api.fetchData();
setState(() => this.data = data);

// ✅ GOOD
final result = await useCase.execute(NoParams());
result.when(
  success: (data) => setState(() => this.data = data),
  failure: (error) => showError(error.message),
);
```

### 4. Ignoring Responsiveness
```dart
// ❌ BAD
Container(width: 400, child: content)

// ✅ GOOD
ResponsiveLayout(
  mobile: MobileLayout(),
  tablet: TabletLayout(),
  desktop: DesktopLayout(),
)
```

## Resources

- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- [Flutter Best Practices](https://flutter.dev/docs/development/best-practices)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Atomic Design](https://bradfrost.com/blog/post/atomic-web-design/)

---

**Remember**: Consistency is more important than perfection. Follow these practices to maintain a clean, maintainable codebase.
