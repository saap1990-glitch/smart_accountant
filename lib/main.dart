import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'core/services/accounting/system_account_resolver.dart';
import 'core/di/service_locator.dart';
import 'core/services/accounting/accounting_link_service.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await setupServiceLocator();
    final systemResolver = sl<SystemAccountResolver>();
    await systemResolver.ensureAll();
    final linkService = sl<AccountingLinkService>();
    await linkService.seedDefaultAccounts();
  } catch (e) {
    debugPrint('Init error: $e');
  }

  // قراءة الإعدادات المحفوظة
  const storage = FlutterSecureStorage();
  final darkMode = await storage.read(key: 'dark_mode') == 'true';
  final languageCode = await storage.read(key: 'language') ?? 'ar';
  final fontSizeValue =
      double.tryParse(await storage.read(key: 'font_size') ?? '') ?? 16.0;

  runApp(
    SmartAccountantApp(
      darkMode: darkMode,
      fontSize: fontSizeValue,
      languageCode: languageCode,
    ),
  );
}

class SmartAccountantApp extends StatelessWidget {
  const SmartAccountantApp({
    super.key,
    required this.darkMode,
    required this.fontSize,
    required this.languageCode,
  });

  final bool darkMode;
  final double fontSize;
  final String languageCode;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'المحاسب الذكي',
      debugShowCheckedModeBanner: false,
      locale: Locale(languageCode),
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.lightTheme.copyWith(
        textTheme: AppTheme.lightTheme.textTheme.apply(
          fontSizeFactor: fontSize / 16.0,
        ),
      ),
      darkTheme: AppTheme.darkTheme.copyWith(
        textTheme: AppTheme.darkTheme.textTheme.apply(
          fontSizeFactor: fontSize / 16.0,
        ),
      ),
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      home: const LoginScreen(),
    );
  }
}
