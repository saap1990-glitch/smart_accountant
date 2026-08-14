import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../core/services/operations/operation_service.dart';
import '../../../core/services/master_data/master_data_service.dart';
import '../../../core/services/numbering/number_generator.dart';
import '../../../core/services/pdf/pdf_service.dart';
import '../../../core/engine/accounting/transaction_context.dart';
import '../../../core/errors/result.dart';
import 'widgets/item_card_widget.dart';

enum PaymentMode { cash, bank, credit }

class OperationConfig {
  final String title;
  final TransactionType transactionType;
  final bool showPaymentMode;
  final bool showCustomer;
  final bool showSupplier;
  final bool showItems;
  final bool showCashSource;
  final bool showBankSource;
  final bool showWarehouse;
  final bool showDestinationWarehouse;
  final bool showCreditAccount;
  final bool showDebitAccount;
  final bool showInvoiceNumber;
  final bool isReturn;
  final bool isInventoryOut;
  final bool isInventoryIn;
  final bool showPrice;
  final bool showFreeQty;

  const OperationConfig({
    required this.title,
    required this.transactionType,
    this.showPaymentMode = false,
    this.showCustomer = false,
    this.showSupplier = false,
    this.showItems = false,
    this.showCashSource = false,
    this.showBankSource = false,
    this.showWarehouse = false,
    this.showDestinationWarehouse = false,
    this.showCreditAccount = false,
    this.showDebitAccount = false,
    this.showInvoiceNumber = false,
    this.isReturn = false,
    this.isInventoryOut = false,
    this.isInventoryIn = false,
    this.showPrice = true,
    this.showFreeQty = true,
  });
}

class SmartOperationForm extends StatefulWidget {
  final OperationConfig config;
  const SmartOperationForm({super.key, required this.config});

  @override
  State<SmartOperationForm> createState() => _SmartOperationFormState();
}

class _SmartOperationFormState extends State<SmartOperationForm> {
  final _opService = GetIt.I<OperationService>();
  final _dataService = GetIt.I<MasterDataService>();
  final _numberGen = GetIt.I<NumberGenerator>();

  DateTime _selectedDate = DateTime.now();
  String? _operationNumber;
  String _statusText = '';

  PaymentMode? _paymentMode;
  String? _selectedCreditAccountId;
  String? _selectedDebitAccountId;
  List<Map<String, dynamic>> _accounts = [];
  String? _selectedCashBoxId;
  List<Map<String, dynamic>> _cashBoxes = [];
  List<Map<String, dynamic>> _banks = [];
  List<Map<String, dynamic>> _wallets = [];
  List<Map<String, dynamic>> _exchangeCompanies = [];
  String? _selectedCustomerId;
  String? _selectedSupplierId;
  List<Map<String, dynamic>> _customers = [];
  List<Map<String, dynamic>> _suppliers = [];
  String? _selectedWarehouseId;
  String? _selectedDestWarehouseId;
  List<Map<String, dynamic>> _warehouses = [];
  final List<ItemCardEntry> _items = [];
  List<Map<String, dynamic>> _allItems = [];
  String _currencyCode = 'YER';
  double _exchangeRate = 1.0;
  List<Map<String, dynamic>> _currencies = [];
  final _invoiceNumberCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _referenceCtrl = TextEditingController();
  double _totalAmount = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
    _generateNumber();
  }

  Future<void> _generateNumber() async {
    final number = await _numberGen.generate(widget.config.transactionType.name);
    if (mounted) setState(() => _operationNumber = number);
  }

  Future<void> _loadData() async {
    final accounts = await _dataService.getAllAccounts();
    final cashBoxes = await _dataService.getAllCashBoxes();
    final banks = await _dataService.getAllBanks();
    final wallets = await _dataService.getAllWallets();
    final exchange = await _dataService.getAllExchangeCompanies();
    final customers = await _dataService.getAllCustomers();
    final suppliers = await _dataService.getAllSuppliers();
    final warehouses = await _dataService.getAllWarehouses();
    final items = await _dataService.getAllItems();
    final currencies = await _dataService.getAllCurrencies();

    if (mounted) {
      setState(() {
        _accounts = accounts;
        _cashBoxes = cashBoxes;
        _banks = banks;
        _wallets = wallets;
        _exchangeCompanies = exchange;
        _customers = customers;
        _suppliers = suppliers;
        _warehouses = warehouses;
        _allItems = items;
        _currencies = currencies.isEmpty ? [{'code': 'YER', 'name': 'ريال يمني'}, {'code': 'USD', 'name': 'دولار أمريكي'}, {'code': 'SAR', 'name': 'ريال سعودي'}] : currencies;
      });
    }
  }

  Future<void> _submit() async {
    final amount = _totalAmount > 0 ? _totalAmount : double.tryParse(_amountCtrl.text) ?? 0;
    final items = <JournalItem>[];

    if (widget.config.showItems && _items.isNotEmpty) {
      for (var item in _items) {
        final total = item.quantity * item.price;
        items.add(widget.config.transactionType == TransactionType.sale ? JournalItem(accountId: 1, debit: total) : JournalItem(accountId: 2, credit: total));
      }
    } else {
      if (widget.config.transactionType == TransactionType.receipt) {
        items.add(JournalItem(accountId: 112, debit: amount));
      } else if (widget.config.transactionType == TransactionType.payment) {
        items.add(JournalItem(accountId: 112, credit: amount));
      } else {
        items.add(JournalItem(accountId: 1, debit: amount));
        items.add(JournalItem(accountId: 2, credit: amount));
      }
    }

    final result = await _opService.execute(
      type: widget.config.transactionType,
      date: _selectedDate,
      items: items, exchangeRate: _exchangeRate,
      reference: _operationNumber ?? widget.config.title,
      currencyCode: _currencyCode,
    );

    if (!mounted) return;
    switch (result) {
      case Success(data: final res):
        setState(() { _operationNumber = res.entryNumber; _statusText = '✅ ${res.message}'; });
      case Failure(exception: final e):
        setState(() => _statusText = '❌ ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.config.title),
        actions: [
          if (_operationNumber != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(_operationNumber!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // رقم العملية
          if (_operationNumber != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(color: Colors.teal.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Text('رقم العملية: $_operationNumber', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.teal)),
            ),

          ListTile(
            title: Text('التاريخ: ${_selectedDate.toLocal()}'.split(' ')[0]),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final date = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime(2020), lastDate: DateTime(2030));
              if (date != null && mounted) setState(() => _selectedDate = date);
            },
          ),
          const SizedBox(height: 8),

          if (_currencies.isNotEmpty)
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'العملة'),
              value: _currencyCode,
              items: _currencies.map((c) => DropdownMenuItem<String>(value: c['code'] as String?, child: Text('${c['name']} (${c['code']})'))).toList(),
              onChanged: (v) => setState(() => _currencyCode = v!),
            ),
          const SizedBox(height: 8),

          if (widget.config.showPaymentMode)
            Row(children: [
              if (widget.config.showCashSource) Expanded(child: _modeBtn('نقدي', PaymentMode.cash, Icons.money, Colors.green)),
              if (widget.config.showBankSource) ...[const SizedBox(width: 8), Expanded(child: _modeBtn('بنكي', PaymentMode.bank, Icons.account_balance, Colors.blue))],
              if (widget.config.showCustomer || widget.config.showSupplier) ...[const SizedBox(width: 8), Expanded(child: _modeBtn('آجل', PaymentMode.credit, Icons.schedule, Colors.orange))],
            ]),
          const SizedBox(height: 12),

          if (widget.config.showCreditAccount)
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'الحساب الدائن'),
              value: _selectedCreditAccountId,
              items: _accounts.map((a) => DropdownMenuItem<String>(value: a['id'].toString(), child: Text('${a['number']} - ${a['name_ar'] ?? a['name_en']}'))).toList(),
              onChanged: (v) => setState(() => _selectedCreditAccountId = v),
            ),

          if (widget.config.showDebitAccount)
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'الحساب المدين'),
              value: _selectedDebitAccountId,
              items: _accounts.map((a) => DropdownMenuItem<String>(value: a['id'].toString(), child: Text('${a['number']} - ${a['name_ar'] ?? a['name_en']}'))).toList(),
              onChanged: (v) => setState(() => _selectedDebitAccountId = v),
            ),

          if (widget.config.showInvoiceNumber)
            TextFormField(controller: _invoiceNumberCtrl, decoration: const InputDecoration(labelText: 'رقم الفاتورة المرجعية')),

          if (_paymentMode == PaymentMode.cash && widget.config.showCashSource)
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'اختر الصندوق'),
              value: _selectedCashBoxId,
              items: _cashBoxes.map((c) => DropdownMenuItem<String>(value: c['id'].toString(), child: Text(c['name'] ?? ''))).toList(),
              onChanged: (v) => setState(() => _selectedCashBoxId = v),
            ),

          if (widget.config.showWarehouse)
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: widget.config.isInventoryOut ? 'المخزن المراد الصرف منه' : 'المخزن'),
              value: _selectedWarehouseId,
              items: _warehouses.map((w) => DropdownMenuItem<String>(value: w['id'].toString(), child: Text(w['name'] ?? ''))).toList(),
              onChanged: (v) => setState(() => _selectedWarehouseId = v),
            ),

          if (widget.config.showDestinationWarehouse)
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'المخزن المستلم'),
              value: _selectedDestWarehouseId,
              items: _warehouses.map((w) => DropdownMenuItem<String>(value: w['id'].toString(), child: Text(w['name'] ?? ''))).toList(),
              onChanged: (v) => setState(() => _selectedDestWarehouseId = v),
            ),

          const SizedBox(height: 8),
          TextFormField(controller: _descriptionCtrl, decoration: const InputDecoration(labelText: 'البيان'), maxLines: 2),
          const SizedBox(height: 8),
          TextFormField(controller: _referenceCtrl, decoration: const InputDecoration(labelText: 'رقم المرجع')),
          if (!widget.config.showItems)
            TextFormField(controller: _amountCtrl, decoration: const InputDecoration(labelText: 'المبلغ'), keyboardType: TextInputType.number),

          if (widget.config.showItems) ...[
            const SizedBox(height: 12),
            ItemCardWidget(items: _items, availableItems: _allItems, showPriceColumn: widget.config.showPrice, showFreeColumn: widget.config.showFreeQty, onChanged: (items) { double total = 0; for (var item in items) { total += item.quantity * item.price; } setState(() => _totalAmount = total); }),
          ],

          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.check_circle),
            label: const Text('حفظ وترحيل'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
            onPressed: _submit,
          ),
          if (_statusText.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 12), child: Text(_statusText, style: TextStyle(color: _statusText.startsWith('✅') ? Colors.green : Colors.red, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _modeBtn(String label, PaymentMode mode, IconData icon, Color color) {
    final selected = _paymentMode == mode;
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      style: ElevatedButton.styleFrom(backgroundColor: selected ? color : Colors.grey.shade200, foregroundColor: selected ? Colors.white : Colors.black, padding: const EdgeInsets.symmetric(vertical: 8)),
      onPressed: () => setState(() => _paymentMode = selected ? null : mode),
    );
  }
}

extension SmartOperationFormPrint on _SmartOperationFormState {
  Future<void> _printOperation() async {
    final pdfService = GetIt.I<PdfService>();
    await pdfService.printInvoice(
      title: widget.config.title,
      number: _operationNumber ?? '-',
      date: '${_selectedDate.toLocal()}'.split(' ')[0],
      customerName: _selectedCustomerId ?? '',
      items: _items.map((e) => {'name': e.itemName, 'quantity': e.quantity, 'price': e.price}).toList(),
      total: _totalAmount,
      notes: _descriptionCtrl.text,
    );
  }
}
