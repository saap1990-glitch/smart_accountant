import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../core/services/reports/report_service.dart';
import '../../core/services/targets/target_service.dart';
import '../../core/repositories/ledger_repository.dart';
import 'report_view_screen.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final _reportService = GetIt.I<ReportService>();
  final _ledgerRepo = GetIt.I<LedgerRepository>();
  final _targetService = GetIt.I<TargetService>();

  DateTime _fromDate = DateTime(DateTime.now().year, 1, 1);
  DateTime _toDate = DateTime.now();
  bool _loading = false;

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
          _periodSummary(),
          const SizedBox(height: 16),

          _section('📊 التقارير المالية', [
            _tile('ميزان المراجعة', Icons.balance, () => _showTrialBalance()),
            _tile('قائمة الدخل', Icons.trending_up, () => _showIncomeStatement()),
            _tile('الميزانية العمومية', Icons.account_balance, () => _showBalanceSheet()),
            _tile('الأستاذ العام', Icons.book, () => _showGeneralLedger()),
          ]),
          const SizedBox(height: 8),

          _section('📋 كشوف الحسابات', [
            _tile('كشف العميل', Icons.person, () => _showCustomerStatement()),
            _tile('كشف المورد', Icons.business, () => _showSupplierStatement()),
            _tile('كشف البنك', Icons.account_balance_wallet, () => _showBankStatement()),
            _tile('كشف الصندوق', Icons.money, () => _showCashBoxStatement()),
          ]),

          const SizedBox(height: 8),

          _section('📦 تقارير المخزون', [
            _tile('تقرير المخزون', Icons.inventory, () => _showInventoryReport()),
            _tile('حركة صنف', Icons.swap_horiz, () => _showItemMovement()),
          ]),

          const SizedBox(height: 8),

          _section('💰 تقارير الأرباح', [
            _tile('تقرير الأرباح', Icons.savings, () => _showProfitReport()),
            _tile('أفضل المندوبين', Icons.emoji_events, () => _showTopPerformers()),
          ]),
        ],
      ),
    );
  }

  Widget _periodSummary() {
    return Card(
      color: Colors.teal.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('الفترة: ${_fromDate.day}/${_fromDate.month}/${_fromDate.year} - ${_toDate.day}/${_toDate.month}/${_toDate.year}'),
            const Icon(Icons.date_range, color: Colors.teal),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.only(bottom: 4), child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal))),
        ...children,
      ],
    );
  }

  Widget _tile(String title, IconData icon, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 3),
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  // ========== التقارير الفعلية ==========

  Future<void> _showTrialBalance() async {
    final data = await _reportService.trialBalance(_toDate);
    _openReport('ميزان المراجعة', data, ['account_number', 'account_name', 'debit', 'credit']);
  }

  Future<void> _showIncomeStatement() async {
    final data = await _reportService.incomeStatement(from: _fromDate, to: _toDate);
    _showSummary('قائمة الدخل', data);
  }

  Future<void> _showBalanceSheet() async {
    final data = await _reportService.balanceSheet(_toDate);
    _showSummary('الميزانية العمومية', data);
  }

  Future<void> _showGeneralLedger() async {
    final accounts = await _reportService.getAccounts();
    final accountId = await _selectAccount('اختر الحساب');
    if (accountId != null) {
      final data = await _ledgerRepo.getAccountStatement(accountId: accountId, from: _fromDate, to: _toDate);
      _openReport('الأستاذ العام', data, ['date', 'description', 'debit', 'credit', 'balance']);
    }
  }

  Future<void> _showCustomerStatement() async {
    final customers = GetIt.I<ReportService>().getCustomers();
    final customerId = await _selectEntity('اختر العميل', await customers);
    if (customerId != null) {
      final data = await _reportService.customerStatement(customerId: customerId, from: _fromDate, to: _toDate);
      _openReport('كشف العميل', data, ['date', 'description', 'debit', 'credit', 'balance']);
    }
  }

  Future<void> _showSupplierStatement() async {
    final suppliers = GetIt.I<ReportService>().getSuppliers();
    final supplierId = await _selectEntity('اختر المورد', await suppliers);
    if (supplierId != null) {
      final data = await _reportService.supplierStatement(supplierId: supplierId, from: _fromDate, to: _toDate);
      _openReport('كشف المورد', data, ['date', 'description', 'debit', 'credit', 'balance']);
    }
  }

  Future<void> _showBankStatement() async {
    final banks = GetIt.I<ReportService>().getBanks();
    final bankId = await _selectEntity('اختر البنك', await banks);
    if (bankId != null) {
      final data = await _reportService.bankStatement(bankId: bankId, from: _fromDate, to: _toDate);
      _openReport('كشف البنك', data, ['date', 'description', 'debit', 'credit', 'balance']);
    }
  }

  Future<void> _showCashBoxStatement() async {
    final cashBoxes = GetIt.I<ReportService>().getCashBoxes();
    final cashBoxId = await _selectEntity('اختر الصندوق', await cashBoxes);
    if (cashBoxId != null) {
      final data = await _reportService.cashBoxStatement(cashBoxId: cashBoxId, from: _fromDate, to: _toDate);
      _openReport('كشف الصندوق', data, ['date', 'description', 'debit', 'credit', 'balance']);
    }
  }

  Future<void> _showInventoryReport() async {
    final data = await _reportService.inventoryReport();
    _openReport('تقرير المخزون', data, ['item', 'quantity', 'cost', 'total']);
  }

  Future<void> _showItemMovement() async {
    final items = await _reportService.getItems();
    final itemId = await _selectEntity('اختر الصنف', items);
    if (itemId != null) {
      final data = await _reportService.itemMovementReport(itemId: itemId, from: _fromDate, to: _toDate);
      _openReport('حركة الصنف', data, ['date', 'type', 'quantity', 'price', 'total']);
    }
  }

  Future<void> _showProfitReport() async {
    final data = await _reportService.profitReport(from: _fromDate, to: _toDate);
    _showSummary('تقرير الأرباح', data);
  }

  void _showTopPerformers() {
    final performers = _targetService.topPerformers;
    if (performers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('لا توجد بيانات')));
      return;
    }
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('أفضل المندوبين'),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: performers.asMap().entries.map((e) => ListTile(leading: CircleAvatar(child: Text('${e.key + 1}')), title: Text(e.value.name), trailing: Text('${e.value.monthPercentage.toStringAsFixed(0)}%'))).toList()),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('موافق'))],
      ),
    );
  }

  void _openReport(String title, List<Map<String, dynamic>> data, List<String> columns) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => ReportViewScreen(title: title, data: data, columns: columns)));
  }

  void _showSummary(String title, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: data.entries.map((e) => Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(e.key.toString()), Text(e.value.toString(), style: const TextStyle(fontWeight: FontWeight.bold))]))).toList())),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('موافق'))],
      ),
    );
  }

  Future<int?> _selectAccount(String title) async {
    final accounts = await _reportService.getAccounts();
    return _selectEntity(title, accounts);
  }

  Future<int?> _selectEntity(String title, List<Map<String, dynamic>> entities) async {
    if (entities.isEmpty) return null;
    final selected = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: entities.length,
            itemBuilder: (_, i) => ListTile(
              title: Text(entities[i]['name_ar'] ?? entities[i]['name'] ?? entities[i]['number'] ?? ''),
              subtitle: entities[i]['number'] != null ? Text(entities[i]['number']) : null,
              onTap: () => Navigator.pop(ctx, entities[i]['id'] as int?),
            ),
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء'))],
      ),
    );
    return selected;
  }

  void _selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(context: context, firstDate: DateTime(2020), lastDate: DateTime(2030), initialDateRange: DateTimeRange(start: _fromDate, end: _toDate));
    if (picked != null) setState(() { _fromDate = picked.start; _toDate = picked.end; });
  }
}
