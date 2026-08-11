import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static const Map<String, Map<String, String>> _translations = {
    'ar': {
      'app_name': 'المحاسب الذكي',
      'dashboard': 'لوحة التحكم',
      'accounts': 'الحسابات',
      'customers': 'العملاء',
      'suppliers': 'الموردين',
      'inventory': 'المخزون',
      'sales': 'المبيعات',
      'purchases': 'المشتريات',
      'reports': 'التقارير',
      'settings': 'الإعدادات',
      'dark_mode': 'الوضع الليلي',
      'light_mode': 'الوضع النهاري',
      'language': 'اللغة',
      'backup': 'نسخ احتياطي',
      'restore': 'استعادة',
      'privacy': 'سياسة الخصوصية',
      'terms': 'شروط الاستخدام',
      'subscription': 'الاشتراك',
      'logout': 'تسجيل الخروج',
    },
    'en': {
      'app_name': 'Smart Accountant',
      'dashboard': 'Dashboard',
      'accounts': 'Accounts',
      'customers': 'Customers',
      'suppliers': 'Suppliers',
      'inventory': 'Inventory',
      'sales': 'Sales',
      'purchases': 'Purchases',
      'reports': 'Reports',
      'settings': 'Settings',
      'dark_mode': 'Dark Mode',
      'light_mode': 'Light Mode',
      'language': 'Language',
      'backup': 'Backup',
      'restore': 'Restore',
      'privacy': 'Privacy Policy',
      'terms': 'Terms of Use',
      'subscription': 'Subscription',
      'logout': 'Logout',
    },
  };

  String? get(String key) {
    return _translations[locale.languageCode]?[key] ?? _translations['en']![key];
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['ar', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
