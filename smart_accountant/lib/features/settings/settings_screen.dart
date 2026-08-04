import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final options = [
      'بيانات الشركة',
      'العملة والإعدادات المالية',
      'اللغة والمظهر',
      'إعدادات الحسابات',
      'النسخ الاحتياطي والاستعادة',
      'الأمان',
      'ترقيم المستندات',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
      ),
      body: ListView.builder(
        itemCount: options.length,
        itemBuilder: (_, index) {
          return ListTile(
            leading: const Icon(Icons.settings),
            title: Text(options[index]),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {},
          );
        },
      ),
    );
  }
}
