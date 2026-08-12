import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../core/services/backup/backup_service.dart';
import '../../core/services/subscription/subscription_service.dart';
import '../../core/services/templates/activity_templates.dart';
import 'privacy_screen.dart';
import 'terms_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final backup = GetIt.I<BackupService>();
    final sub = GetIt.I<SubscriptionService>();
    final templates = GetIt.I<ActivityTemplates>();

    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: ListView(
        children: [
          // إعدادات دليل الحسابات
          _section('إعدادات دليل الحسابات', [
            ListTile(
              leading: const Icon(Icons.account_tree, color: Colors.teal),
              title: const Text('قوالب الأنشطة'),
              subtitle: const Text('اختيار قالب حسابات مناسب لنشاطك'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showTemplateDialog(context, templates),
            ),
            ListTile(
              leading: const Icon(Icons.format_list_numbered, color: Colors.teal),
              title: const Text('طريقة ترقيم الحسابات'),
              subtitle: const Text('تخصيص نمط أرقام الحسابات'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.layers, color: Colors.teal),
              title: const Text('عدد المستويات'),
              subtitle: const Text('تحديد عمق شجرة الحسابات'),
              onTap: () {},
            ),
          ]),
          const Divider(),

          // بيانات
          _section('البيانات والنسخ', [
            ListTile(
              leading: const Icon(Icons.backup, color: Colors.blue),
              title: const Text('نسخ احتياطي'),
              onTap: () => backup.shareBackup(),
            ),
            ListTile(
              leading: const Icon(Icons.restore, color: Colors.blue),
              title: const Text('استعادة النسخة'),
              onTap: () {},
            ),
          ]),
          const Divider(),

          // الاشتراك
          _section('الاشتراك', [
            ListTile(
              leading: const Icon(Icons.subscriptions, color: Colors.purple),
              title: Text(sub.isActive ? 'الاشتراك نشط (${sub.daysLeft} يوم متبقي)' : 'الاشتراك منتهي'),
              trailing: sub.isActive
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : const Icon(Icons.warning, color: Colors.red),
            ),
          ]),
          const Divider(),

          // قانوني
          _section('قانوني', [
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
          ]),
        ],
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
        ),
        ...children,
      ],
    );
  }

  void _showTemplateDialog(BuildContext context, ActivityTemplates templates) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('اختر قالب النشاط'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: templates.templates.entries.map((entry) {
              final t = entry.value;
              return ListTile(
                leading: Icon(
                  _getTemplateIcon(t['icon']),
                  color: Colors.teal,
                ),
                title: Text(t['name']),
                subtitle: Text(t['description']),
                onTap: () async {
                  Navigator.pop(ctx);
                  await templates.applyTemplate(entry.key);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('تم تطبيق قالب: ${t['name']}')),
                  );
                },
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
        ],
      ),
    );
  }

  IconData _getTemplateIcon(String name) {
    switch (name) {
      case 'store': return Icons.store;
      case 'shopping_cart': return Icons.shopping_cart;
      case 'medical_services': return Icons.medical_services;
      case 'currency_exchange': return Icons.currency_exchange;
      case 'construction': return Icons.construction;
      case 'miscellaneous_services': return Icons.miscellaneous_services;
      case 'restaurant': return Icons.restaurant;
      case 'factory': return Icons.factory;
      default: return Icons.account_balance;
    }
  }
}
