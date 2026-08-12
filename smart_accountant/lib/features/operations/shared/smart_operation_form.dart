import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../core/services/operations/operation_service.dart';
import '../../../core/services/master_data/master_data_service.dart';
import '../../../core/engine/accounting/transaction_context.dart';
import '../../../core/engine/accounting/transaction_result.dart';
import '../../../core/errors/result.dart';
import 'widgets/item_card_widget.dart';

class OperationConfig {
  final String title;
  final TransactionType transactionType;
  final String numberPrefix;
  final bool showPaymentType;
  final bool showCustomer;
  final bool showSupplier;
  final bool showItems;
  final bool showCashSource;
  final bool showMultiLines;
  final bool showDestination;
  final bool isInventory;
  final bool isReturn;
  final bool showFreeColumn;
  final bool showPriceColumn;
  final bool showWarehouse;
  final String? debitAccountHint;
  final String? creditAccountHint;

  const OperationConfig({
    required this.title,
    required this.transactionType,
    this.numberPrefix = '',
    this.showPaymentType = false,
    this.showCustomer = false,
    this.showSupplier = false,
    this.showItems = false,
    this.showCashSource = false,
    this.showMultiLines = false,
    this.showDestination = false,
    this.isInventory = false,
    this.isReturn = false,
    this.showFreeColumn = true,
    this.showPriceColumn = true,
    this.showWarehouse = false,
    this.debitAccountHint,
    this.creditAccountHint,
  });
}

class SmartOperationForm extends StatefulWidget {
  final OperationConfig config;
  const SmartOperationForm({super.key, required this.config});

  @override
  State<SmartOperationForm> createState() => _SmartOperationFormState();
}

class _SmartOperationFormState extends State<SmartOperationForm> {
  final _formKey = GlobalKey<FormState>();
  final _opService = GetIt.I<OperationService>();
  final _dataService = GetIt.I<MasterDataService>();

  DateTime _selectedDate = DateTime.now();
  String? _paymentType;
  String? _selectedCustomerId;
  String? _selectedSupplierId;
  String? _selectedCashSourceType;
  String? _selectedCashSourceId;
  String? _selectedWarehouseId;
  double _totalAmount = 0;
  String _statusText = '';
  String? _generatedNumber;

  final List<ItemCardEntry> _items = [];
  List<Map<String, dynamic>> _customers = [];
  List<Map<String, dynamic>> _suppliers = [];
  List<Map<String, dynamic>> _allItems = [];
  List<Map<String, dynamic>> _banks = [];
  List<Map<String, dynamic>> _cashBoxes = [];
  List<Map<String, dynamic>> _wallets = [];
  List<Map<String, dynamic>> _exchangeCompanies = [];
  List<Map<String, dynamic>> _warehouses = [];

  @override
  void initState() {
    super.initState();
    _loadMasterData();
  }

  Future<void> _loadMasterData() async {
    final customers = await _dataService.getAllCustomers();
    final suppliers = await _dataService.getAllSuppliers();
    final items = await _dataService.getAllItems();
    final banks = await _dataService.getAllBanks();
    final cashBoxes = await _dataService.getAllCashBoxes();
    final wallets = await _dataService.getAllWallets();
    final exchange = await _dataService.getAllExchangeCompanies();
    final warehouses = await _dataService.getAllWarehouses();
    if (!mounted) return;
    setState(() {
      _customers = customers;
      _suppliers = suppliers;
      _allItems = items;
      _banks = banks;
      _cashBoxes = cashBoxes;
      _wallets = wallets;
      _exchangeCompanies = exchange;
      _warehouses = warehouses;
    });
  }

  List<JournalItem> _buildItems() {
    final items = <JournalItem>[];
    final double amount = _totalAmount;
    if (widget.config.showMultiLines) {
      items.add(JournalItem(accountId: 1, debit: amount));
      items.add(JournalItem(accountId: 2, credit: amount));
      return items;
    }
    if (widget.config.showItems && _items.isNotEmpty) {
      double total = 0;
      for (var item in _items) {
        total += item.quantity * item.price;
      }
      if (widget.config.transactionType == TransactionType.sale) {
        items.add(JournalItem(accountId: 1, debit: total));
        items.add(JournalItem(accountId: 41, credit: total));
      } else if (widget.config.transactionType == TransactionType.purchase) {
        items.add(JournalItem(accountId: 113, debit: total));
        items.add(JournalItem(accountId: 2, credit: total));
      } else if (widget.config.isReturn) {
        items.add(JournalItem(accountId: 41, debit: total));
        items.add(JournalItem(accountId: 1, credit: total));
      }
      return items;
    }
    if (widget.config.showCashSource) {
      items.add(JournalItem(accountId: 112, debit: widget.config.transactionType == TransactionType.receipt ? amount : 0));
      items.add(JournalItem(accountId: 112, credit: widget.config.transactionType == TransactionType.payment ? amount : 0));
    } else {
      items.add(JournalItem(accountId: 1, debit: amount));
      items.add(JournalItem(accountId: 2, credit: amount));
    }
    return items;
  }

  Future<void> _submit(bool isDraft) async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    final items = _buildItems();
    Result<TransactionResult> result;
    if (isDraft) {
      result = await _opService.saveDraft(type: widget.config.transactionType, date: _selectedDate, items: items, reference: widget.config.title);
    } else {
      result = await _opService.execute(
        type: widget.config.transactionType,
        date: _selectedDate,
        items: items,
        reference: widget.config.title,
        metadata: {
          'items': _items.map((e) => {'id': e.itemId, 'name': e.itemName, 'quantity': e.quantity, 'price': e.price}).toList(),
          'reference': widget.config.title,
        },
      );
    }
    if (!mounted) return;
    switch (result) {
      case Success(data: final res):
        setState(() {
          _statusText = res.message ?? 'تم بنجاح';
          _generatedNumber = res.entryNumber;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${res.message} - ${res.entryNumber ?? ''}')));
      case Failure(exception: final e):
        setState(() => _statusText = e.message);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.config.title)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ListTile(
              title: Text('التاريخ: ${_selectedDate.toLocal()}'.split(' ')[0]),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime(2020), lastDate: DateTime(2030));
                if (date != null && mounted) setState(() => _selectedDate = date);
              },
            ),
            const SizedBox(height: 10),
            if (widget.config.showPaymentType)
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'نوع الدفع'),
                value: _paymentType,
                items: const [
                  DropdownMenuItem(value: 'cash', child: Text('نقدي')),
                  DropdownMenuItem(value: 'credit', child: Text('آجل')),
                ],
                onChanged: (v) => setState(() => _paymentType = v),
              ),
            const SizedBox(height: 10),
            if (widget.config.showCustomer && _paymentType == 'credit')
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'العميل'),
                value: _selectedCustomerId,
                items: _customers.map((c) => DropdownMenuItem(value: c['id'].toString(), child: Text(c['name'] ?? ''))).toList(),
                onChanged: (v) => setState(() => _selectedCustomerId = v),
              ),
            if (widget.config.showSupplier && _paymentType == 'credit')
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'المورد'),
                value: _selectedSupplierId,
                items: _suppliers.map((s) => DropdownMenuItem(value: s['id'].toString(), child: Text(s['name'] ?? ''))).toList(),
                onChanged: (v) => setState(() => _selectedSupplierId = v),
              ),
            if (widget.config.showCashSource && _paymentType == 'cash') ...[
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'جهة التحصيل/الدفع'),
                value: _selectedCashSourceType,
                items: const [
                  DropdownMenuItem(value: 'cash', child: Text('صندوق')),
                  DropdownMenuItem(value: 'bank', child: Text('بنك')),
                  DropdownMenuItem(value: 'wallet', child: Text('محفظة')),
                  DropdownMenuItem(value: 'exchange', child: Text('شركة صرافة')),
                ],
                onChanged: (v) => setState(() { _selectedCashSourceType = v; _selectedCashSourceId = null; }),
              ),
              if (_selectedCashSourceType == 'cash')
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'اختر الصندوق'),
                  value: _selectedCashSourceId,
                  items: _cashBoxes.map((c) => DropdownMenuItem(value: c['id'].toString(), child: Text(c['name'] ?? ''))).toList(),
                  onChanged: (v) => setState(() => _selectedCashSourceId = v),
                ),
              if (_selectedCashSourceType == 'bank')
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'اختر البنك'),
                  value: _selectedCashSourceId,
                  items: _banks.map((b) => DropdownMenuItem(value: b['id'].toString(), child: Text(b['name'] ?? ''))).toList(),
                  onChanged: (v) => setState(() => _selectedCashSourceId = v),
                ),
              if (_selectedCashSourceType == 'wallet')
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'اختر المحفظة'),
                  value: _selectedCashSourceId,
                  items: _wallets.map((w) => DropdownMenuItem(value: w['id'].toString(), child: Text(w['name'] ?? ''))).toList(),
                  onChanged: (v) => setState(() => _selectedCashSourceId = v),
                ),
              if (_selectedCashSourceType == 'exchange')
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'اختر شركة الصرافة'),
                  value: _selectedCashSourceId,
                  items: _exchangeCompanies.map((e) => DropdownMenuItem(value: e['id'].toString(), child: Text(e['name'] ?? ''))).toList(),
                  onChanged: (v) => setState(() => _selectedCashSourceId = v),
                ),
            ],
            const SizedBox(height: 10),
            if (widget.config.showWarehouse)
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'المخزن'),
                value: _selectedWarehouseId,
                items: _warehouses.map((w) => DropdownMenuItem(value: w['id'].toString(), child: Text(w['name'] ?? ''))).toList(),
                onChanged: (v) => setState(() => _selectedWarehouseId = v),
              ),
            if (!widget.config.showItems)
              TextFormField(
                decoration: InputDecoration(labelText: 'المبلغ'),
                keyboardType: TextInputType.number,
                onChanged: (v) => _totalAmount = double.tryParse(v) ?? 0,
              ),
            if (widget.config.showItems) ...[
              const SizedBox(height: 16),
              ItemCardWidget(
                items: _items,
                availableItems: _allItems,
                showFreeColumn: widget.config.showFreeColumn,
                showPriceColumn: widget.config.showPriceColumn,
                onChanged: (items) {
                  double total = 0;
                  for (var item in items) { total += item.quantity * item.price; }
                  setState(() => _totalAmount = total);
                },
              ),
            ],
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(icon: const Icon(Icons.save), label: const Text('مسودة'), onPressed: () => _submit(true)),
                ElevatedButton.icon(
                  icon: const Icon(Icons.check_circle),
                  label: const Text('ترحيل'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                  onPressed: () => _submit(false),
                ),
                OutlinedButton.icon(icon: const Icon(Icons.clear), label: const Text('إلغاء'), onPressed: () => _formKey.currentState?.reset()),
              ],
            ),
            if (_statusText.isNotEmpty)
              Padding(padding: const EdgeInsets.only(top: 10), child: Text(_statusText, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
            if (_generatedNumber != null)
              Padding(padding: const EdgeInsets.only(top: 5), child: Text('رقم العملية: $_generatedNumber', style: const TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }
}
