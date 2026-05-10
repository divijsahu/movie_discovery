import 'package:flutter/material.dart';
import 'package:flutter_app_template/design_system/atoms/buttons/primary_button.dart';
import 'package:flutter_app_template/design_system/layouts/responsive_layout.dart';
import 'package:flutter_app_template/design_system/tokens/spacing.dart';
import 'package:flutter_app_template/shared/extensions/context_extensions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter App Template'),
        centerTitle: true,
      ),
      body: ResponsiveLayout(
        mobile: _MobileLayout(),
        tablet: _TabletLayout(),
        desktop: _DesktopLayout(),
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.pagePadding,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.rocket_launch, size: 80, color: context.colors.primary),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Welcome to Flutter App Template!',
              style: context.textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'A modern enterprise architecture with clean code principles',
              style: context.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              label: 'Get Started',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _TabletLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: _MobileLayout(),
      ),
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: _MobileLayout(),
      ),
    );
  }
}
