import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reports = [
      'كشف الحساب',
      'دفتر الأستاذ',
      'ميزان المراجعة',
      'قائمة الدخل',
      'الميزانية العمومية',
      'تقرير المخزون',
      'تقارير العملات',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('التقارير'),
      ),
      body: ListView.builder(
        itemCount: reports.length,
        itemBuilder: (_, index) {
          return ListTile(
            leading: const Icon(Icons.analytics),
            title: Text(reports[index]),
            onTap: () {},
          );
        },
      ),
    );
  }
}
