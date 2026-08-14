import 'package:flutter/material.dart';
import 'core/di/service_locator.dart';
import 'core/services/accounting/accounting_link_service.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await setupServiceLocator();
    final linkService = sl<AccountingLinkService>();
    await linkService.seedDefaultAccounts();
  } catch (e) {
    debugPrint('Init error: $e');
  }

  runApp(const SmartAccountantApp());
}

class SmartAccountantApp extends StatelessWidget {
  const SmartAccountantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'المحاسب الذكي',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const LoginScreen(),
    );
  }
}
