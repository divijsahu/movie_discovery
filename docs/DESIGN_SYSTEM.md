# 🎨 Design System Guide

## Overview

The design system provides a consistent, token-based approach to building UI components. It follows the Atomic Design methodology.

## Design Tokens

### Colors

```dart
// lib/design_system/tokens/colors.dart

// Brand Colors
AppColors.primary          // #0A84FF
AppColors.primaryVariant   // #0066CC
AppColors.secondary        // #30D158
AppColors.accent           // #FF9F0A

// Semantic Colors
AppColors.error            // #FF453A
AppColors.warning          // #FFD60A
AppColors.success          // #30D158
AppColors.info             // #0A84FF

// Neutral Colors
AppColors.grey50           // #F9FAFB
AppColors.grey100          // #F3F4F6
AppColors.grey200          // #E5E7EB
AppColors.grey600          // #4B5563
AppColors.grey900          // #111827

// Dark Theme
AppColors.surface          // #1C1C1E
AppColors.surfaceVariant   // #2C2C2E
AppColors.background       // #000000
```

**Usage:**
```dart
Container(color: AppColors.primary)
```

### Typography

```dart
// lib/design_system/tokens/typography.dart

AppTypography.displayLarge      // 57px, Bold
AppTypography.headlineMedium    // 28px, SemiBold
AppTypography.bodyLarge         // 16px, Regular
AppTypography.labelSmall        // 11px, Medium
```

**Usage:**
```dart
Text('Hello', style: AppTypography.headlineMedium)
```

### Spacing

```dart
// lib/design_system/tokens/spacing.dart

AppSpacing.xxs    // 2.0
AppSpacing.xs     // 4.0
AppSpacing.sm     // 8.0
AppSpacing.md     // 16.0
AppSpacing.lg     // 24.0
AppSpacing.xl     // 32.0
AppSpacing.xxl    // 48.0
AppSpacing.xxxl   // 64.0

// Predefined Insets
AppSpacing.pagePadding   // EdgeInsets.all(16)
AppSpacing.cardPadding   // EdgeInsets.symmetric(h:16, v:8)
```

**Usage:**
```dart
Padding(padding: AppSpacing.pagePadding)
SizedBox(height: AppSpacing.lg)
```

### Breakpoints

```dart
// lib/design_system/tokens/breakpoints.dart

AppBreakpoints.mobile    // 0
AppBreakpoints.tablet    // 600
AppBreakpoints.desktop   // 1024
AppBreakpoints.wide      // 1440
```

**Usage:**
```dart
if (MediaQuery.of(context).size.width >= AppBreakpoints.tablet) {
  // Tablet layout
}
```

## Atomic Components

### Atoms (Basic Components)

#### PrimaryButton
```dart
PrimaryButton(
  label: 'Submit',
  onPressed: () {},
  isLoading: false,
  isFullWidth: true,
  prefixIcon: Icon(Icons.check),
)
```

**Creating New Atoms:**
```dart
// lib/design_system/atoms/buttons/secondary_button.dart
class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  
  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
  });
  
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
```

### Molecules (Composite Components)

Example: InfoCard
```dart
// lib/design_system/molecules/info_card.dart
class InfoCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback? onTap;
  
  const InfoCard({
    super.key,
    required this.title,
    required this.description,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: context.textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.sm),
              Text(description, style: context.textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
```

### Organisms (Complex Components)

Example: AppHeader
```dart
// lib/design_system/organisms/app_header.dart
class AppHeader extends StatelessWidget {
  final String title;
  final List<Widget> actions;
  
  const AppHeader({
    super.key,
    required this.title,
    this.actions = const [],
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.pagePadding,
      color: context.colors.surface,
      child: Row(
        children: [
          Text(title, style: context.textTheme.headlineMedium),
          const Spacer(),
          ...actions,
        ],
      ),
    );
  }
}
```

### Layouts (Responsive Wrappers)

#### ResponsiveLayout
```dart
ResponsiveLayout(
  mobile: MobileWidget(),
  tablet: TabletWidget(),
  desktop: DesktopWidget(),
)
```

**How it works:**
- Shows `mobile` for width < 600
- Shows `tablet` for width >= 600 and < 1024
- Shows `desktop` for width >= 1024
- Falls back to previous breakpoint if not provided

## Context Extensions

```dart
// lib/shared/extensions/context_extensions.dart

// Theme Access
context.theme           // ThemeData
context.colors          // ColorScheme
context.textTheme       // TextTheme

// Navigation
context.navigator       // NavigatorState

// Device Type
context.isMobile        // bool
context.isTablet        // bool
context.isDesktop       // bool
```

**Usage:**
```dart
Text(
  'Hello',
  style: context.textTheme.bodyLarge?.copyWith(
    color: context.colors.primary,
  ),
)

if (context.isDesktop) {
  // Desktop-specific code
}
```

## Theme Configuration

### Light Theme
```dart
AppTheme.light()
```

### Dark Theme
```dart
AppTheme.dark()
```

### Custom Theme Extensions
```dart
// lib/design_system/theme/theme_extensions.dart
@immutable
class AppColorScheme extends ThemeExtension<AppColorScheme> {
  final Color cardSurface;
  final Color divider;
  
  const AppColorScheme({
    required this.cardSurface,
    required this.divider,
  });
  
  @override
  AppColorScheme copyWith({Color? cardSurface, Color? divider}) {
    return AppColorScheme(
      cardSurface: cardSurface ?? this.cardSurface,
      divider: divider ?? this.divider,
    );
  }
  
  @override
  AppColorScheme lerp(AppColorScheme? other, double t) {
    if (other is! AppColorScheme) return this;
    return AppColorScheme(
      cardSurface: Color.lerp(cardSurface, other.cardSurface, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
    );
  }
}
```

## Best Practices

### DO ✅
- Always use design tokens
- Create reusable components
- Follow atomic design hierarchy
- Use context extensions
- Make components responsive
- Document component usage

### DON'T ❌
- Hardcode colors or spacing
- Create one-off components
- Skip responsive considerations
- Ignore theme mode
- Duplicate component logic

## Component Checklist

When creating a new component:

- [ ] Uses design tokens (no hardcoded values)
- [ ] Supports light and dark themes
- [ ] Responsive (works on all screen sizes)
- [ ] Accessible (proper semantics)
- [ ] Documented (with usage examples)
- [ ] Tested (widget tests)
- [ ] Follows naming conventions
- [ ] Placed in correct atomic level

## Examples

### Building a Feature Screen

```dart
class MyFeatureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Feature')),
      body: ResponsiveLayout(
        mobile: _buildMobileLayout(context),
        tablet: _buildTabletLayout(context),
        desktop: _buildDesktopLayout(context),
      ),
    );
  }
  
  Widget _buildMobileLayout(BuildContext context) {
    return Padding(
      padding: AppSpacing.pagePadding,
      child: Column(
        children: [
          Text('Title', style: context.textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.md),
          PrimaryButton(
            label: 'Action',
            onPressed: () {},
          ),
        ],
      ),
    );
  }
  
  Widget _buildTabletLayout(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: _buildMobileLayout(context),
      ),
    );
  }
  
  Widget _buildDesktopLayout(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Row(
          children: [
            Expanded(child: _buildMobileLayout(context)),
            const SizedBox(width: AppSpacing.xl),
            Expanded(child: _buildSidebar(context)),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSidebar(BuildContext context) {
    return Container(
      padding: AppSpacing.pagePadding,
      color: context.colors.surface,
      child: const Text('Sidebar'),
    );
  }
}
```

---

For more examples, see the `lib/features/home/` implementation.
