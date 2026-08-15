import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../core/services/operations/operation_service.dart';
import '../../../core/services/master_data/master_data_service.dart';
import '../../../core/services/numbering/number_generator.dart';
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

  // الحسابات المختارة فعلياً
  int? _selectedCreditAccountId;
  int? _selectedDebitAccountId;
  List<Map<String, dynamic>> _postingAccounts = [];

  // مصادر النقد
  int? _selectedCashBoxId;
  int? _selectedCashBoxAccountId;
  List<Map<String, dynamic>> _cashBoxes = [];
  int? _selectedBankAccountId;
  String? _selectedBankSourceType;
  int? _selectedBankSourceId;
  List<Map<String, dynamic>> _banks = [];
  List<Map<String, dynamic>> _wallets = [];
  List<Map<String, dynamic>> _exchangeCompanies = [];

  // العملاء/الموردين
  int? _selectedCustomerId;
  int? _selectedCustomerAccountId;
  List<Map<String, dynamic>> _customers = [];
  int? _selectedSupplierId;
  int? _selectedSupplierAccountId;
  List<Map<String, dynamic>> _suppliers = [];

  // المخازن
  int? _selectedWarehouseId;
  int? _selectedDestWarehouseId;
  List<Map<String, dynamic>> _warehouses = [];

  // الأصناف
  final List<ItemCardEntry> _items = [];
  List<Map<String, dynamic>> _allItems = [];

  // العملة
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

    if (mounted) {
      setState(() {
        _postingAccounts = accounts.where((a) => a['accepts_posting'] == true || a['level'] >= 4).toList();
        _cashBoxes = cashBoxes;
        _banks = banks;
        _wallets = wallets;
        _exchangeCompanies = exchange;
        _customers = customers;
        _suppliers = suppliers;
        _warehouses = warehouses;
        _allItems = items;
        _currencies = [
          {'code': 'YER', 'name': 'ريال يمني'},
          {'code': 'USD', 'name': 'دولار أمريكي'},
          {'code': 'SAR', 'name': 'ريال سعودي'},
        ];
      });
    }
  }

  List<JournalItem> _buildJournalItems() {
    final items = <JournalItem>[];
    final amount = _totalAmount > 0 ? _totalAmount : double.tryParse(_amountCtrl.text) ?? 0;

    // الحساب المدين
    int? debitAccountId = _selectedDebitAccountId;
    // الحساب الدائن
    int? creditAccountId = _selectedCreditAccountId;

    // تحديد الحسابات حسب نوع العملية والوضع المختار
    switch (widget.config.transactionType) {
      case TransactionType.receipt:
        // قبض: الصندوق مدين / الحساب المختار دائن
        debitAccountId = _selectedCashBoxAccountId ?? _selectedBankAccountId;
        creditAccountId = _selectedCreditAccountId ?? _selectedCustomerAccountId;
        break;
      case TransactionType.payment:
        // صرف: الحساب المختار مدين / الصندوق دائن
        debitAccountId = _selectedDebitAccountId ?? _selectedSupplierAccountId;
        creditAccountId = _selectedCashBoxAccountId ?? _selectedBankAccountId;
        break;
      case TransactionType.sale:
        // بيع: العميل/الصندوق مدين / المبيعات دائن
        debitAccountId = _paymentMode == PaymentMode.credit ? _selectedCustomerAccountId : _selectedCashBoxAccountId ?? _selectedBankAccountId;
        creditAccountId = _selectedCreditAccountId;
        break;
      case TransactionType.purchase:
        // شراء: المخزون مدين / المورد/الصندوق دائن
        debitAccountId = _selectedDebitAccountId;
        creditAccountId = _paymentMode == PaymentMode.credit ? _selectedSupplierAccountId : _selectedCashBoxAccountId ?? _selectedBankAccountId;
        break;
      default:
        break;
    }

    if (widget.config.showItems && _items.isNotEmpty) {
      for (var item in _items) {
        final total = item.quantity * item.price;
        if (widget.config.transactionType == TransactionType.sale || widget.config.isReturn && !widget.config.isInventoryIn) {
          items.add(JournalItem(accountId: debitAccountId ?? 0, debit: total));
          items.add(JournalItem(accountId: creditAccountId ?? 0, credit: total));
        } else {
          items.add(JournalItem(accountId: debitAccountId ?? 0, debit: total));
          items.add(JournalItem(accountId: creditAccountId ?? 0, credit: total));
        }
      }
    } else {
      items.add(JournalItem(accountId: debitAccountId ?? 0, debit: amount));
      items.add(JournalItem(accountId: creditAccountId ?? 0, credit: amount));
    }

    return items;
  }

  Future<void> _submit() async {
    if (_totalAmount <= 0 && _items.isEmpty && double.tryParse(_amountCtrl.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('أدخل المبلغ أو أضف أصنافاً')));
      return;
    }

    final items = _buildJournalItems();

    if (items.any((i) => i.accountId <= 0)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('⚠️ اختر جميع الحسابات المطلوبة')));
      return;
    }

    final result = await _opService.execute(
      type: widget.config.transactionType,
      date: _selectedDate,
      items: items,
      reference: _operationNumber ?? widget.config.title,
      currencyCode: _currencyCode,
      exchangeRate: _exchangeRate,
      metadata: {
        'items': _items.map((e) => {'id': e.itemId, 'name': e.itemName, 'quantity': e.quantity, 'price': e.price}).toList(),
        'reference': _operationNumber,
      },
    );

    if (!mounted) return;
    switch (result) {
      case Success(data: final res):
        setState(() { _operationNumber = res.entryNumber; _statusText = '✅ ${res.message} - ${res.entryNumber}'; });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('✅ ${res.entryNumber}'), backgroundColor: Colors.green));
      case Failure(exception: final e):
        setState(() => _statusText = '❌ ${e.message}');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ ${e.message}'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.config.title),
        actions: [if (_operationNumber != null) Center(child: Padding(padding: const EdgeInsets.only(left: 16), child: Text(_operationNumber!, style: const TextStyle(fontWeight: FontWeight.bold))))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_operationNumber != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(color: Colors.teal.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Text('رقم العملية: $_operationNumber', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
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

          // نقدي - صندوق
          if (_paymentMode == PaymentMode.cash && widget.config.showCashSource)
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'اختر الصندوق'),
              value: _selectedCashBoxId?.toString(),
              items: _cashBoxes.map((c) => DropdownMenuItem<String>(value: c['id'].toString(), child: Text(c['name'] ?? ''))).toList(),
              onChanged: (v) async {
                final cashBox = _cashBoxes.firstWhere((c) => c['id'].toString() == v);
                final accountId = await _dataService.getLinkedAccountId('cash_boxes', 'CashBox', v!);
                setState(() { _selectedCashBoxId = int.parse(v); _selectedCashBoxAccountId = accountId; });
              },
            ),

          // بنكي - بنك/محفظة/صرافة
          if (_paymentMode == PaymentMode.bank && widget.config.showBankSource)
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'نوع الحساب'),
              value: _selectedBankSourceType,
              items: const [DropdownMenuItem(value: 'bank', child: Text('بنك')), DropdownMenuItem(value: 'wallet', child: Text('محفظة')), DropdownMenuItem(value: 'exchange', child: Text('شركة صرافة'))],
              onChanged: (v) => setState(() { _selectedBankSourceType = v; _selectedBankAccountId = null; }),
            ),

          if (_selectedBankSourceType == 'bank')
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'اختر البنك'),
              value: _selectedBankSourceId?.toString(),
              items: _banks.map((b) => DropdownMenuItem<String>(value: b['id'].toString(), child: Text(b['name'] ?? ''))).toList(),
              onChanged: (v) async {
                final accountId = await _dataService.getLinkedAccountId('banks', 'Bank', v!);
                setState(() { _selectedBankSourceId = int.parse(v); _selectedBankAccountId = accountId; });
              },
            ),

          // آجل - عميل/مورد
          if (_paymentMode == PaymentMode.credit && widget.config.showCustomer)
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'اختر العميل'),
              value: _selectedCustomerId?.toString(),
              items: _customers.map((c) => DropdownMenuItem<String>(value: c['id'].toString(), child: Text(c['name'] ?? ''))).toList(),
              onChanged: (v) async {
                final accountId = await _dataService.getLinkedAccountId('customers', 'Customer', v!);
                setState(() { _selectedCustomerId = int.parse(v); _selectedCustomerAccountId = accountId; });
              },
            ),
          if (_paymentMode == PaymentMode.credit && widget.config.showSupplier)
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'اختر المورد'),
              value: _selectedSupplierId?.toString(),
              items: _suppliers.map((s) => DropdownMenuItem<String>(value: s['id'].toString(), child: Text(s['name'] ?? ''))).toList(),
              onChanged: (v) async {
                final accountId = await _dataService.getLinkedAccountId('suppliers', 'Supplier', v!);
                setState(() { _selectedSupplierId = int.parse(v); _selectedSupplierAccountId = accountId; });
              },
            ),

          // الحساب المدين
          if (widget.config.showDebitAccount)
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'الحساب المدين'),
              value: _selectedDebitAccountId?.toString(),
              items: _postingAccounts.map((a) => DropdownMenuItem<String>(value: a['id'].toString(), child: Text('${a['number']} - ${a['name_ar'] ?? a['name_en']}'))).toList(),
              onChanged: (v) => setState(() => _selectedDebitAccountId = int.parse(v!)),
            ),

          // الحساب الدائن
          if (widget.config.showCreditAccount)
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'الحساب الدائن'),
              value: _selectedCreditAccountId?.toString(),
              items: _postingAccounts.map((a) => DropdownMenuItem<String>(value: a['id'].toString(), child: Text('${a['number']} - ${a['name_ar'] ?? a['name_en']}'))).toList(),
              onChanged: (v) => setState(() => _selectedCreditAccountId = int.parse(v!)),
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
