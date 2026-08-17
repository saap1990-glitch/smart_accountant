import 'package:flutter/material.dart';

import '../../core/di/service_locator.dart';
import '../../core/services/reports/report_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ReportService _reportService = sl<ReportService>();

  bool _loading = true;
  String? _error;

  Map<String, dynamic> _income = {};
  Map<String, dynamic> _balance = {};
  List<Map<String, dynamic>> _trialBalance = [];

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final now = DateTime.now();
      final from = DateTime(now.year, now.month, 1);
      final to = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

      final results = await Future.wait([
        _reportService.incomeStatement(from: from, to: to),
        _reportService.balanceSheet(now),
        _reportService.trialBalance(now),
      ]);

      if (!mounted) return;

      setState(() {
        _income = results[0] as Map<String, dynamic>;
        _balance = results[1] as Map<String, dynamic>;
        _trialBalance = results[2] as List<Map<String, dynamic>>;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  double _number(dynamic value) {
    if (value == null) return 0;

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString()) ?? 0;
  }

  String _money(dynamic value) {
    return _number(value).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadDashboard,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),

          if (_loading)
            const Padding(
              padding: EdgeInsets.all(40),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_error != null)
            _buildError()
          else ...[
            _buildFinancialSummary(),
            const SizedBox(height: 16),
            _buildQuickActions(context),
            const SizedBox(height: 16),
            _buildAccountingStatus(),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'لوحة التحكم',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'ملخص الوضع المالي والمحاسبي',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'تحديث',
          onPressed: _loading ? null : _loadDashboard,
          icon: const Icon(Icons.refresh),
        ),
      ],
    );
  }

  Widget _buildFinancialSummary() {
    final cards = [
      _Metric(
        title: 'الإيرادات',
        value: _money(_income['revenues']),
        icon: Icons.trending_up,
      ),
      _Metric(
        title: 'المصروفات',
        value: _money(_income['expenses']),
        icon: Icons.trending_down,
      ),
      _Metric(
        title: 'صافي الربح',
        value: _money(_income['net_income']),
        icon: Icons.account_balance_wallet,
      ),
      _Metric(
        title: 'الأصول',
        value: _money(_balance['assets']),
        icon: Icons.account_balance,
      ),
      _Metric(
        title: 'الخصوم',
        value: _money(_balance['liabilities']),
        icon: Icons.payments_outlined,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final columns = width >= 900
            ? 5
            : width >= 600
            ? 3
            : 2;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cards.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: width < 600 ? 1.5 : 1.8,
          ),
          itemBuilder: (_, index) {
            final item = cards[index];

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(item.icon),
                    const Spacer(),
                    Text(
                      item.title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item.value,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      ('بيع', Icons.point_of_sale),
      ('شراء', Icons.shopping_cart),
      ('قبض', Icons.call_received),
      ('دفع', Icons.call_made),
      ('قيد يومي', Icons.menu_book),
      ('تحويل', Icons.swap_horiz),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'العمليات السريعة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: actions.map((action) {
                return OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'سيتم فتح عملية ${action.$1} بعد ربط شاشة العملية.',
                        ),
                      ),
                    );
                  },
                  icon: Icon(action.$2),
                  label: Text(action.$1),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountingStatus() {
    final totalAccounts = _trialBalance.length;

    double debit = 0;
    double credit = 0;

    for (final row in _trialBalance) {
      debit += _number(row['debit']);
      credit += _number(row['credit']);
    }

    final balanced = (debit - credit).abs() < 0.01;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'حالة النظام المحاسبي',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(balanced ? Icons.check_circle : Icons.warning),
              title: const Text('توازن ميزان المراجعة'),
              subtitle: Text(
                balanced
                    ? 'المدين والدائن متساويان'
                    : 'يوجد فرق يحتاج إلى مراجعة',
              ),
              trailing: Text('${_money(debit)} / ${_money(credit)}'),
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.account_tree),
              title: const Text('الحسابات المستخدمة'),
              trailing: Text('$totalAccounts'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.error_outline, size: 42),
            const SizedBox(height: 10),
            const Text(
              'تعذر تحميل بيانات لوحة التحكم',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(_error ?? 'خطأ غير معروف', textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _loadDashboard,
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Metric {
  final String title;
  final String value;
  final IconData icon;

  const _Metric({required this.title, required this.value, required this.icon});
}
