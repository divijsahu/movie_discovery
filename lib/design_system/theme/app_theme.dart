import 'package:flutter/material.dart';
import 'package:flutter_app_template/design_system/tokens/colors.dart';
import 'package:flutter_app_template/design_system/tokens/typography.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.error,
        surface: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.grey900,
        onError: Colors.white,
      ),
      textTheme: const TextTheme(
        displayLarge: AppTypography.displayLarge,
        headlineMedium: AppTypography.headlineMedium,
        bodyLarge: AppTypography.bodyLarge,
        labelSmall: AppTypography.labelSmall,
      ),
      scaffoldBackgroundColor: AppColors.grey50,
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.error,
        surface: AppColors.surface,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onError: Colors.white,
      ),
      textTheme: TextTheme(
        displayLarge: AppTypography.displayLarge.copyWith(color: Colors.white),
        headlineMedium: AppTypography.headlineMedium.copyWith(color: Colors.white),
        bodyLarge: AppTypography.bodyLarge.copyWith(color: Colors.white),
        labelSmall: AppTypography.labelSmall.copyWith(color: Colors.white70),
      ),
      scaffoldBackgroundColor: AppColors.background,
    );
  }
  
  AppTheme._();
}
