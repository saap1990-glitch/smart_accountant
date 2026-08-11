import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/services/reports/report_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _reportService = GetIt.I<ReportService>();
  Map<String, dynamic> _income = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final income = await _reportService.incomeStatement(
      from: DateTime(2026, 1, 1),
      to: DateTime(2026, 12, 31),
    );
    setState(() {
      _income = income;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('لوحة التحكم')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // بطاقات ملخص
                Row(
                  children: [
                    _SummaryCard(title: 'الإيرادات', value: _income['revenues']?.toString() ?? '0', color: Colors.teal),
                    const SizedBox(width: 12),
                    _SummaryCard(title: 'المصروفات', value: _income['expenses']?.toString() ?? '0', color: Colors.red),
                  ],
                ),
                const SizedBox(height: 12),
                _SummaryCard(title: 'صافي الدخل', value: _income['net_income']?.toString() ?? '0', color: Colors.blue),
                const SizedBox(height: 24),

                // رسم بياني بسيط
                const Text('أداء آخر 6 أشهر', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: BarChart(
                    BarChartData(
                      barGroups: [
                        _bar(0, 'يناير', 5000),
                        _bar(1, 'فبراير', 8000),
                        _bar(2, 'مارس', 12000),
                        _bar(3, 'أبريل', 7000),
                        _bar(4, 'مايو', 10000),
                        _bar(5, 'يونيو', 15000),
                      ],
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              const names = ['ي', 'ف', 'م', 'أ', 'م', 'ي'];
                              return Text(names[value.toInt()]);
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  BarChartGroupData _bar(int x, String label, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [BarChartRodData(toY: y, color: Colors.teal)],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  const _SummaryCard({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: color.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(value, style: TextStyle(fontSize: 24, color: color)),
            ],
          ),
        ),
      ),
    );
  }
}
