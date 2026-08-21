import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../features/auth/login_screen.dart';
import '../features/dashboard/main_screen.dart';

class SmartAccountantApp extends StatelessWidget {
  const SmartAccountantApp({super.key, this.showLogin = true});
  final bool showLogin;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'المحاسب الذكي',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: showLogin ? const LoginScreen() : const MainScreen(),
    );
  }
}
