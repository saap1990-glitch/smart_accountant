import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/services/reports/report_service.dart';
import '../../core/services/targets/target_service.dart';
import '../../core/services/notifications/notification_service.dart';
import 'widgets/notification_bell.dart';
import 'widgets/target_gauge.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _reportService = GetIt.I<ReportService>();
  final _targetService = GetIt.I<TargetService>();
  final _notificationService = GetIt.I<NotificationService>();

  bool _loading = true;
  bool _hasData = false;
  Map<String, dynamic> _income = {};
  Map<String, dynamic> _balance = {};

  @override
  void initState() {
    super.initState();
    _loadData();
    _notificationService.checkDeadlines();
  }

  Future<void> _loadData() async {
    try {
      final income = await _reportService.incomeStatement(
        from: DateTime(DateTime.now().year, DateTime.now().month, 1),
        to: DateTime.now(),
      );
      final balance = await _reportService.balanceSheet(DateTime.now());

      if (mounted) {
        setState(() {
          _income = income;
          _balance = balance;
          _hasData = true;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasData = false;
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('لوحة التحكم'), actions: const [NotificationBell()]),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final target = _targetService.overallTarget;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة التحكم'),
        actions: const [NotificationBell()],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // رسالة ترحيبية
            Text('مرحباً بك! 👋', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}', style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 20),

            if (!_hasData) ...[
              // شاشة الترحيب الجذابة للمستخدم الجديد
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF006D5B), Color(0xFF4ED9B2)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.auto_awesome, size: 60, color: Colors.white),
                    const SizedBox(height: 16),
                    const Text('ابدأ رحلتك المحاسبية', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 8),
                    const Text('أضف أول عملية لبدء تتبع أرباحك ومصروفاتك', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _quickAction('فاتورة بيع', Icons.point_of_sale, Colors.white),
                        _quickAction('سند قبض', Icons.arrow_downward, Colors.white),
                        _quickAction('قيد يومية', Icons.book, Colors.white),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ] else ...[
              // البطاقات الملخصة
              Row(
                children: [
                  Expanded(child: _summaryCard('الإيرادات', _income['revenues'] ?? '0', Colors.teal, Icons.trending_up)),
                  const SizedBox(width: 12),
                  Expanded(child: _summaryCard('المصروفات', _income['expenses'] ?? '0', Colors.red, Icons.trending_down)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _summaryCard('صافي الربح', _income['net_income'] ?? '0', Colors.blue, Icons.savings)),
                  const SizedBox(width: 12),
                  Expanded(child: _summaryCard('الأصول', _balance['assets'] ?? '0', Colors.purple, Icons.account_balance)),
                ],
              ),
              const SizedBox(height: 24),
            ],

            // الهدف الشهري
            if (target.monthlyTarget > 0) ...[
              const Text('🎯 الهدف الشهري', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TargetGauge(target: target),
              const SizedBox(height: 16),
            ],

            // رسم بياني
            if (_hasData) ...[
              const Text('📊 أداء الإيرادات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    barGroups: List.generate(6, (i) => BarChartGroupData(
                      x: i,
                      barRods: [BarChartRodData(toY: (i + 1) * 3000, color: Colors.teal, width: 20, borderRadius: const BorderRadius.vertical(top: Radius.circular(6)))],
                    )),
                    titlesData: const FlTitlesData(show: false),
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _summaryCard(String title, String value, Color color, IconData icon) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
              Icon(icon, color: color, size: 20),
            ]),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _quickAction(String label, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 50, height: 50,
          decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(14)),
          child: Icon(icon, color: color, size: 26),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}
