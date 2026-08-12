import 'package:flutter/material.dart';
import 'core/di/service_locator.dart';
import 'core/services/accounting/accounting_link_service.dart';
import 'core/auth/auth_service.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/login_screen.dart';
import 'features/dashboard/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await setupServiceLocator();
    final linkService = sl<AccountingLinkService>();
    await linkService.seedDefaultAccounts();
  } catch (e) {
    runApp(MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.red,
        body: Center(
          child: Text('خطأ في التهيئة: $e',
              style: const TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ),
    ));
    return;
  }

  final auth = sl<AuthService>();
  final remembered = await auth.isSessionRemembered();

  runApp(SmartAccountantApp(showLogin: !remembered));
}

class SmartAccountantApp extends StatelessWidget {
  final bool showLogin;
  const SmartAccountantApp({super.key, this.showLogin = true});

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
