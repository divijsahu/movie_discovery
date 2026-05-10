import 'package:flutter/material.dart';
import 'package:flutter_app_template/core/constants/app_constants.dart';
import 'package:flutter_app_template/design_system/theme/app_theme.dart';
import 'package:flutter_app_template/features/home/presentation/screens/home_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.APP_NAME,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
