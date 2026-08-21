import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../core/services/reports/report_service.dart';
import 'report_view_screen.dart';
import 'documents_screen.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  ReportService get service => GetIt.I<ReportService>();

  final List<_ReportItem> _reports = const [
    _ReportItem(
      'دفتر الأستاذ العام',
      Icons.menu_book,
      Colors.indigo,
      'general',
    ),
    _ReportItem('ميزان المراجعة', Icons.balance, Colors.teal, 'trial'),
    _ReportItem('قائمة الدخل', Icons.trending_up, Colors.green, 'income'),
    _ReportItem(
      'الميزانية العمومية',
      Icons.account_balance,
      Colors.blue,
      'balance',
    ),
    _ReportItem('التدفقات النقدية', Icons.payments, Colors.orange, 'cash'),
    _ReportItem('الأرباح', Icons.show_chart, Colors.purple, 'profit'),
    _ReportItem('المخزون', Icons.inventory_2, Colors.brown, 'inventory'),
    _ReportItem('حركة الأصناف', Icons.swap_vert, Colors.cyan, 'item'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مركز التقارير'),
        actions: [
          IconButton(
            tooltip: 'المستندات',
            icon: const Icon(Icons.folder_open),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DocumentsScreen()),
              );
            },
          ),
          IconButton(
            tooltip: 'تحديث',
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 420,
          mainAxisExtent: 118,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: _reports.length,
        itemBuilder: (_, i) {
          final r = _reports[i];
          return Card(
            elevation: 1,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReportViewScreen(type: r.type),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 27,
                      backgroundColor: r.color.withValues(alpha: .12),
                      child: Icon(r.icon, color: r.color),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        r.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ReportItem {
  const _ReportItem(this.title, this.icon, this.color, this.type);
  final String title;
  final IconData icon;
  final Color color;
  final String type;
}
