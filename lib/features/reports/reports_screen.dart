import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../core/services/reports/report_service.dart';
import '../../core/services/targets/target_service.dart';
import '../../core/services/inventory/item_movement_service.dart';
import 'report_view_screen.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final _reportService = GetIt.I<ReportService>();
  final _targetService = GetIt.I<TargetService>();
  final _movementService = GetIt.I<ItemMovementService>();

  DateTime _fromDate = DateTime(DateTime.now().year, 1, 1);
  DateTime _toDate = DateTime.now();
  String? _selectedItemName;
  String? _selectedCustomerId;
  String? _selectedSupplierId;
  String? _selectedWarehouseId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التقارير'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () => _selectDateRange(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ملخص الفترة
          _PeriodSummary(from: _fromDate, to: _toDate),
          const SizedBox(height: 16),

          // التقارير المالية
          _section('📊 التقارير المالية', [
            _reportTile('الأستاذ العام', Icons.book, () async {
              final data = await _reportService.generalLedger(accountId: 1, from: _fromDate, to: _toDate);
              _openReport('الأستاذ العام', data, ['date', 'description', 'debit', 'credit', 'balance']);
            }),
            _reportTile('ميزان المراجعة', Icons.balance, () async {
              final data = await _reportService.trialBalance(_toDate);
              _openReport('ميزان المراجعة', data, ['account_number', 'account_name', 'debit', 'credit']);
            }),
            _reportTile('قائمة الدخل', Icons.trending_up, () => _showIncomeStatement()),
            _reportTile('الميزانية العمومية', Icons.account_balance, () => _showBalanceSheet()),
            _reportTile('التدفقات النقدية', Icons.money, () => _showCashFlow()),
          ]),

          const SizedBox(height: 8),

          // كشوف الحسابات
          _section('📋 كشوف الحسابات', [
            _reportTile('كشف العميل', Icons.person, () async {
              final data = await _reportService.customerStatement(customerId: 1, from: _fromDate, to: _toDate);
              _openReport('كشف العميل', data, ['date', 'description', 'debit', 'credit', 'balance']);
            }),
            _reportTile('كشف المورد', Icons.business, () async {
              final data = await _reportService.supplierStatement(supplierId: 1, from: _fromDate, to: _toDate);
              _openReport('كشف المورد', data, ['date', 'description', 'debit', 'credit', 'balance']);
            }),
            _reportTile('كشف البنك', Icons.account_balance, () async {
              final data = await _reportService.bankStatement(bankId: 1, from: _fromDate, to: _toDate);
              _openReport('كشف البنك', data, ['date', 'description', 'debit', 'credit', 'balance']);
            }),
            _reportTile('كشف الصندوق', Icons.money, () async {
              final data = await _reportService.cashBoxStatement(cashBoxId: 1, from: _fromDate, to: _toDate);
              _openReport('كشف الصندوق', data, ['date', 'description', 'debit', 'credit', 'balance']);
            }),
            _reportTile('كشف المحفظة', Icons.wallet, () async {
              final data = await _reportService.walletStatement(walletId: 1, from: _fromDate, to: _toDate);
              _openReport('كشف المحفظة', data, ['date', 'description', 'debit', 'credit', 'balance']);
            }),
            _reportTile('كشف شركة الصرافة', Icons.currency_exchange, () async {
              final data = await _reportService.exchangeCompanyStatement(companyId: 1, from: _fromDate, to: _toDate);
              _openReport('كشف شركة الصرافة', data, ['date', 'description', 'debit', 'credit', 'balance']);
            }),
          ]),

          const SizedBox(height: 8),

          // تقارير المخزون
          _section('📦 تقارير المخزون', [
            _reportTile('تقرير المخزون', Icons.inventory, () async {
              final data = await _reportService.inventoryReport();
              _openReport('تقرير المخزون', data, ['item', 'quantity', 'cost', 'total']);
            }),
            _reportTile('حركة صنف', Icons.swap_horiz, () => _showItemMovement()),
            _reportTile('الأصناف الراكدة', Icons.hourglass_empty, () {}),
            _reportTile('الأصناف القريبة من النفاد', Icons.warning_amber, () {}),
          ]),

          const SizedBox(height: 8),

          // تقارير المندوبين والأهداف
          _section('🎯 تقارير المندوبين والأهداف', [
            _reportTile('تقرير الأرباح', Icons.savings, () => _showProfitReport()),
            _reportTile('أفضل المندوبين', Icons.emoji_events, () => _showTopPerformers()),
            _reportTile('الأهداف والتارجت', Icons.track_changes, () {}),
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
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal)),
        ),
        ...children,
      ],
    );
  }

  Widget _reportTile(String title, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.teal.withOpacity(0.1),
          child: Icon(icon, color: Colors.teal, size: 22),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _openReport(String title, List<Map<String, dynamic>> data, List<String> columns) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReportViewScreen(title: title, data: data, columns: columns),
      ),
    );
  }

  void _showIncomeStatement() async {
    final data = await _reportService.incomeStatement(from: _fromDate, to: _toDate);
    _showSummaryDialog('قائمة الدخل', data);
  }

  void _showBalanceSheet() async {
    final data = await _reportService.balanceSheet(_toDate);
    _showSummaryDialog('الميزانية العمومية', data);
  }

  void _showCashFlow() async {
    final data = await _reportService.cashFlow(from: _fromDate, to: _toDate);
    _showSummaryDialog('التدفقات النقدية', data);
  }

  void _showProfitReport() async {
    final data = await _reportService.profitReport(from: _fromDate, to: _toDate);
    _showSummaryDialog('تقرير الأرباح', data);
  }

  void _showItemMovement() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حركة صنف'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'اسم الصنف'),
                onChanged: (v) => _selectedItemName = v,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  if (_selectedItemName != null && _selectedItemName!.isNotEmpty) {
                    final card = _movementService.getItemCard(_selectedItemName!);
                    Navigator.pop(ctx);
                    _showSummaryDialog('حركة صنف: $_selectedItemName', card);
                  }
                },
                child: const Text('عرض الحركة'),
              ),
            ],
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء'))],
      ),
    );
  }

  void _showTopPerformers() {
    final performers = _targetService.topPerformers;
    if (performers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('لا توجد بيانات مندوبين بعد')));
      return;
    }
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(children: [Icon(Icons.emoji_events, color: Colors.amber), SizedBox(width: 8), Text('أفضل المندوبين')]),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: performers.asMap().entries.map((entry) {
              final t = entry.value;
              final rank = entry.key + 1;
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: rank == 1 ? Colors.amber : rank == 2 ? Colors.grey.shade400 : Colors.brown.shade300,
                  child: Text(rank.toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                title: Text(t.salespersonName ?? t.name),
                subtitle: Text('${t.achievedMonth.toStringAsFixed(0)} / ${t.monthlyTarget.toStringAsFixed(0)} ريال'),
                trailing: Text('${t.monthPercentage.toStringAsFixed(0)}%', style: TextStyle(fontWeight: FontWeight.bold, color: t.monthPercentage >= 100 ? Colors.green : Colors.teal)),
              );
            }).toList(),
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('موافق'))],
      ),
    );
  }

  void _showSummaryDialog(String title, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: data.entries.map((e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(e.key.toString(), style: const TextStyle(color: Colors.grey)),
                  Text(e.value.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            )).toList(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('موافق')),
          TextButton.icon(
            icon: const Icon(Icons.share),
            label: const Text('مشاركة'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('جاري المشاركة...')));
            },
          ),
        ],
      ),
    );
  }

  void _selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: DateTimeRange(start: _fromDate, end: _toDate),
    );
    if (picked != null) {
      setState(() {
        _fromDate = picked.start;
        _toDate = picked.end;
      });
    }
  }
}

// ودجة ملخص الفترة
class _PeriodSummary extends StatelessWidget {
  final DateTime from;
  final DateTime to;
  const _PeriodSummary({required this.from, required this.to});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.teal.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('الفترة المحددة', style: TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 4),
                Text('${from.day}/${from.month}/${from.year} - ${to.day}/${to.month}/${to.year}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const Icon(Icons.date_range, color: Colors.teal, size: 40),
          ],
        ),
      ),
    );
  }
}
