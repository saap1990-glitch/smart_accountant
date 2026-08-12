import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/services/reports/report_service.dart';
import '../../core/services/targets/target_service.dart';
import '../../core/services/notifications/notification_service.dart';
import 'widgets/animated_counter.dart';
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

  Map<String, dynamic> _income = {};
  Map<String, dynamic> _balance = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
    // فحص التنبيهات
    _notificationService.checkDeadlines();
    final target = _targetService.overallTarget;
    if (target.monthlyTarget > 0) {
      _notificationService.checkTargetAchievement(
        target.achievedMonth,
        target.monthlyTarget,
        'الشهري',
      );
    }
  }

  Future<void> _loadData() async {
    final income = await _reportService.incomeStatement(
      from: DateTime(DateTime.now().year, DateTime.now().month, 1),
      to: DateTime.now(),
    );
    final balance = await _reportService.balanceSheet(DateTime.now());
    if (mounted) {
      setState(() {
        _income = income;
        _balance = balance;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
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
            Text(
              'مرحباً بك! 👋',
              style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // بطاقات الملخص (متحركة)
            Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    title: 'الإيرادات',
                    value: double.tryParse(_income['revenues']?.toString() ?? '0') ?? 0,
                    color: Colors.teal,
                    icon: Icons.trending_up,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SummaryCard(
                    title: 'المصروفات',
                    value: double.tryParse(_income['expenses']?.toString() ?? '0') ?? 0,
                    color: Colors.red,
                    icon: Icons.trending_down,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    title: 'صافي الربح',
                    value: double.tryParse(_income['net_income']?.toString() ?? '0') ?? 0,
                    color: Colors.blue,
                    icon: Icons.savings,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SummaryCard(
                    title: 'الأصول',
                    value: double.tryParse(_balance['assets']?.toString() ?? '0') ?? 0,
                    color: Colors.purple,
                    icon: Icons.account_balance,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // الهدف الشهري
            if (target.monthlyTarget > 0) ...[
              Text('🎯 الهدف الشهري', style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),
              TargetGauge(target: target),
              const SizedBox(height: 24),
            ],

            // رسم بياني للإيرادات
            Text('📊 أداء الإيرادات', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: (double.tryParse(_income['revenues']?.toString() ?? '0') ?? 1000) * 1.5,
                  barGroups: [
                    _makeBarGroup(0, 'يوليو', 12000, Colors.teal),
                    _makeBarGroup(1, 'أغسطس', 15000, Colors.teal),
                    _makeBarGroup(2, 'سبتمبر', 18000, Colors.teal),
                    _makeBarGroup(3, 'أكتوبر', 22000, Colors.teal),
                    _makeBarGroup(4, 'نوفمبر', 25000, Colors.teal),
                    _makeBarGroup(5, 'ديسمبر', double.tryParse(_income['revenues']?.toString() ?? '0') ?? 28000, Colors.orange),
                  ],
                  titlesData: const FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // أفضل المندوبين
            if (_targetService.topPerformers.isNotEmpty) ...[
              Text('🏆 أفضل المندوبين', style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),
              ..._targetService.topPerformers.map((t) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.teal,
                  child: Text('${t.monthPercentage.toInt()}%', style: const TextStyle(color: Colors.white, fontSize: 12)),
                ),
                title: Text(t.salespersonName ?? t.name),
                subtitle: LinearProgressIndicator(
                  value: t.monthPercentage / 100,
                  color: t.monthPercentage >= 100 ? Colors.green : Colors.teal,
                ),
                trailing: Text('${t.achievedMonth.toInt()} / ${t.monthlyTarget.toInt()}'),
              )),
            ],
          ],
        ),
      ),
    );
  }

  BarChartGroupData _makeBarGroup(int x, String label, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 20,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
        ),
      ],
    );
  }
}

// بطاقة ملخص متحركة
class _SummaryCard extends StatelessWidget {
  final String title;
  final double value;
  final Color color;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
                Icon(icon, color: color, size: 20),
              ],
            ),
            const SizedBox(height: 8),
            AnimatedCounter(
              value: value,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
