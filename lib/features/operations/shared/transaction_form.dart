import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../core/services/operations/operation_service.dart';
import '../../../core/services/master_data/master_data_service.dart';
import '../../../core/services/accounting/accounting_link_service.dart';
import '../../../core/engine/accounting/transaction_context.dart';
import '../../../core/engine/accounting/transaction_result.dart';
import '../../../core/errors/result.dart';

class TransactionForm extends StatefulWidget {
  final String title;
  final TransactionType transactionType;
  final OperationService operationService;
  final String amountLabel;
  final String sourceLabel;
  final List<String> sourceTypes;
  final String? debitAccountPrefix;
  final String? creditAccountPrefix;
  final bool showMultiLines;
  final bool showItems;
  final bool showDestination;
  final bool showCurrencyExchange;
  final bool isInventory;

  const TransactionForm({
    super.key,
    required this.title,
    required this.transactionType,
    required this.operationService,
    required this.amountLabel,
    required this.sourceLabel,
    required this.sourceTypes,
    this.debitAccountPrefix,
    this.creditAccountPrefix,
    this.showMultiLines = false,
    this.showItems = false,
    this.showDestination = false,
    this.showCurrencyExchange = false,
    this.isInventory = false,
  });

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();

  final _dataService = GetIt.I<MasterDataService>();
  final _linkService = GetIt.I<AccountingLinkService>();

  DateTime _selectedDate = DateTime.now();
  double _amount = 0;

  String? _selectedSourceType;
  String? _selectedEntityId;
  String? _selectedDestinationEntityId;

  String _currencyCode = 'YER';
  double _exchangeRate = 1.0;

  String _statusText = '';

  List<Map<String, dynamic>> _sources = [];
  List<Map<String, dynamic>> _destinations = [];

  int? _sourceAccountId;
  int? _destinationAccountId;

  @override
  void initState() {
    super.initState();
    _loadSources();
  }

  Future<void> _loadSources() async {
    final List<Map<String, dynamic>> data = [];

    for (final type in widget.sourceTypes) {
      switch (type.toLowerCase()) {
        case 'صندوق':
        case 'cash':
          data.addAll(
            (await _dataService.getAllCashBoxes()).map(
              (e) => {
                'id': e['id'],
                'name': e['name'],
                'type': 'cash_boxes',
                'entityType': 'CashBox',
              },
            ),
          );
          break;

        case 'بنك':
        case 'bank':
          data.addAll(
            (await _dataService.getAllBanks()).map(
              (e) => {
                'id': e['id'],
                'name': e['name'],
                'type': 'banks',
                'entityType': 'Bank',
              },
            ),
          );
          break;

        case 'محفظة':
        case 'wallet':
          data.addAll(
            (await _dataService.getAllWallets()).map(
              (e) => {
                'id': e['id'],
                'name': e['name'],
                'type': 'wallets',
                'entityType': 'Wallet',
              },
            ),
          );
          break;

        case 'عميل':
        case 'customer':
          data.addAll(
            (await _dataService.getAllCustomers()).map(
              (e) => {
                'id': e['id'],
                'name': e['name'],
                'type': 'customers',
                'entityType': 'Customer',
              },
            ),
          );
          break;

        case 'مورد':
        case 'supplier':
          data.addAll(
            (await _dataService.getAllSuppliers()).map(
              (e) => {
                'id': e['id'],
                'name': e['name'],
                'type': 'suppliers',
                'entityType': 'Supplier',
              },
            ),
          );
          break;
      }
    }

    if (!mounted) return;

    setState(() {
      _sources = data;
      _destinations = List<Map<String, dynamic>>.from(data);
    });
  }

  Future<int?> _resolveAccount(Map<String, dynamic>? entity) async {
    if (entity == null) return null;

    final id = entity['id'];
    final module = entity['type'];
    final entityType = entity['entityType'];

    if (id == null || module == null || entityType == null) {
      return null;
    }

    return _linkService.getLinkedAccount(module, entityType, id.toString());
  }

  Future<void> _selectSource(String? value) async {
    if (value == null) return;

    final entity = _sources.firstWhere(
      (e) => '${e['type']}:${e['id']}' == value,
      orElse: () => {},
    );

    final accountId = await _resolveAccount(entity);

    if (!mounted) return;

    setState(() {
      _selectedEntityId = value;
      _sourceAccountId = accountId;
    });
  }

  Future<void> _selectDestination(String? value) async {
    if (value == null) return;

    final entity = _destinations.firstWhere(
      (e) => '${e['type']}:${e['id']}' == value,
      orElse: () => {},
    );

    final accountId = await _resolveAccount(entity);

    if (!mounted) return;

    setState(() {
      _selectedDestinationEntityId = value;
      _destinationAccountId = accountId;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    if (_amount <= 0) {
      setState(() => _statusText = 'يجب إدخال مبلغ أكبر من صفر');
      return;
    }

    if (_sourceAccountId == null || _sourceAccountId! <= 0) {
      setState(() => _statusText = 'الحساب المرتبط بالمصدر غير موجود');
      return;
    }

    if (widget.showDestination &&
        (_destinationAccountId == null || _destinationAccountId! <= 0)) {
      setState(() => _statusText = 'يجب اختيار الوجهة والحساب المرتبط بها');
      return;
    }

    final items = <JournalItem>[];

    if (widget.showDestination) {
      items.add(JournalItem(accountId: _destinationAccountId!, debit: _amount));

      items.add(JournalItem(accountId: _sourceAccountId!, credit: _amount));
    } else {
      switch (widget.transactionType) {
        case TransactionType.receipt:
          items.add(JournalItem(accountId: _sourceAccountId!, debit: _amount));
          break;

        case TransactionType.payment:
          items.add(JournalItem(accountId: _sourceAccountId!, credit: _amount));
          break;

        default:
          setState(
            () => _statusText =
                'هذه العملية تحتاج حساب الطرف المقابل قبل الترحيل',
          );
          return;
      }

      setState(
        () => _statusText =
            'لم يتم تحديد حساب الطرف المقابل؛ لم يتم إنشاء قيد ناقص',
      );
      return;
    }

    final result = await widget.operationService.execute(
      type: widget.transactionType,
      date: _selectedDate,
      items: items,
      currencyCode: _currencyCode,
      exchangeRate: _exchangeRate,
      reference: widget.title,
    );

    if (!mounted) return;

    switch (result) {
      case Success(data: final TransactionResult res):
        setState(() => _statusText = res.message ?? 'تم تنفيذ العملية بنجاح');

      case Failure(exception: final e):
        setState(() => _statusText = e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ListTile(
              title: Text('التاريخ: ${_selectedDate.toLocal()}'.split(' ')[0]),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );

                if (date != null) {
                  setState(() => _selectedDate = date);
                }
              },
            ),

            const SizedBox(height: 12),

            TextFormField(
              decoration: InputDecoration(labelText: widget.amountLabel),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (value) {
                final amount = double.tryParse(value ?? '');

                if (amount == null || amount <= 0) {
                  return 'أدخل مبلغًا صحيحًا أكبر من صفر';
                }

                return null;
              },
              onSaved: (value) {
                _amount = double.tryParse(value ?? '') ?? 0;
              },
            ),

            const SizedBox(height: 12),

            if (_sources.isNotEmpty)
              DropdownButtonFormField<String>(
                initialValue: _selectedEntityId,
                decoration: InputDecoration(labelText: widget.sourceLabel),
                items: _sources.map((entity) {
                  final value = '${entity['type']}:${entity['id']}';

                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(entity['name']?.toString() ?? ''),
                  );
                }).toList(),
                onChanged: _selectSource,
                validator: (value) {
                  if (value == null) {
                    return 'يجب اختيار المصدر';
                  }

                  return null;
                },
              ),

            if (widget.showDestination) ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedDestinationEntityId,
                decoration: const InputDecoration(labelText: 'الوجهة'),
                items: _destinations.map((entity) {
                  final value = '${entity['type']}:${entity['id']}';

                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(entity['name']?.toString() ?? ''),
                  );
                }).toList(),
                onChanged: _selectDestination,
                validator: (value) {
                  if (value == null) {
                    return 'يجب اختيار الوجهة';
                  }

                  return null;
                },
              ),
            ],

            if (widget.showCurrencyExchange) ...[
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _currencyCode,
                decoration: const InputDecoration(labelText: 'العملة'),
                onChanged: (value) {
                  _currencyCode = value.trim().isEmpty ? 'YER' : value.trim();
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: '1',
                decoration: const InputDecoration(labelText: 'سعر الصرف'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: (value) {
                  _exchangeRate = double.tryParse(value) ?? 1.0;
                },
              ),
            ],

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.check),
              label: const Text('تنفيذ وترحيل'),
            ),

            if (_statusText.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(_statusText, textAlign: TextAlign.center),
            ],
          ],
        ),
      ),
    );
  }
}
