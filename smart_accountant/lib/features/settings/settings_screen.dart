import 'package:flutter/material.dart';
import '../../core/services/backup/backup_service.dart';
import '../../core/services/subscription/subscription_service.dart';
import 'package:get_it/get_it.dart';
import 'privacy_screen.dart';
import 'terms_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final backup = GetIt.I<BackupService>();
    final sub = GetIt.I<SubscriptionService>();

    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.backup),
            title: const Text('نسخ احتياطي'),
            onTap: () => backup.shareBackup(),
          ),
          ListTile(
            leading: const Icon(Icons.restore),
            title: const Text('استعادة النسخة'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('سياسة الخصوصية'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyScreen())),
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('شروط الاستخدام'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsScreen())),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.subscriptions),
            title: Text(sub.isActive ? 'الاشتراك نشط (${sub.daysLeft} يوم)' : 'الاشتراك منتهي'),
          ),
        ],
      ),
    );
  }
}
