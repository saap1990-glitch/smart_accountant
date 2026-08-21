import 'package:flutter/material.dart';
import '../../../core/services/accounting/system_account_resolver.dart';
import 'package:get_it/get_it.dart';
import '../../../core/services/operations/operation_service.dart';
import '../../../core/services/master_data/master_data_service.dart';
import '../../../core/services/numbering/number_generator.dart';
import '../../../core/engine/accounting/transaction_context.dart';
import '../../../core/errors/result.dart';
import '../../../core/services/pdf/pdf_service.dart';

class JournalEntryLine {
  JournalEntryLine({
    this.accountId,
    this.accountName,
    this.accountNumber,
    this.debit = 0,
    this.credit = 0,
    this.description,
  });
  int? accountId;
  String? accountName;
  String? accountNumber;
  double debit;
  double credit;
  String? description;
}

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _opService = GetIt.I<OperationService>();
  final _systemResolver = GetIt.I<SystemAccountResolver>();
  final _dataService = GetIt.I<MasterDataService>();
  final _numberGen = GetIt.I<NumberGenerator>();

  DateTime _selectedDate = DateTime.now();
  final _descriptionCtrl = TextEditingController();
  final _referenceCtrl = TextEditingController();
  String _currencyCode = 'YER';
  double _exchangeRate = 1.0;
  String? _generatedNumber;
  String _statusText = '';

  final List<JournalEntryLine> _lines = [];
  List<Map<String, dynamic>> _accounts = [];
  List<Map<String, dynamic>> _currencies = [];

  @override
  void initState() {
    super.initState();
    _addLine();
    _loadData();
  }

  Future<void> _loadData() async {
    final accounts = await _dataService.getAllAccounts();
    if (mounted) {
      setState(() {
        _accounts = accounts;
        _currencies = [
          {'code': 'YER', 'name': 'ريال يمني'},
          {'code': 'USD', 'name': 'دولار أمريكي'},
          {'code': 'SAR', 'name': 'ريال سعودي'},
        ];
      });
    }
  }

  void _addLine() {
    setState(() {
      _lines.add(JournalEntryLine());
    });
  }

  void _removeLine(int index) {
    if (_lines.length > 2) {
      setState(() {
        _lines.removeAt(index);
      });
    }
  }

  double get _totalDebit => _lines.fold(0, (sum, line) => sum + line.debit);
  double get _totalCredit => _lines.fold(0, (sum, line) => sum + line.credit);
  double get _difference => (_totalDebit - _totalCredit).abs();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    // التحقق من توازن القيد
    if (_difference > 0.001) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '⚠️ القيد غير متوازن! الفرق: ${_difference.toStringAsFixed(2)}',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_totalDebit == 0 && _totalCredit == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ لا يمكن أن تكون جميع المبالغ صفراً'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final items = _lines.where((l) => l.accountId != null).map((line) {
      return JournalItem(
        accountId: line.accountId!,
        debit: line.debit,
        credit: line.credit,
        description: line.description,
      );
    }).toList();

    final result = await _opService.execute(
      type: TransactionType.journal,
      date: _selectedDate,
      items: items,
      reference: '${_referenceCtrl.text} - ${_descriptionCtrl.text}',
      currencyCode: _currencyCode,
      exchangeRate: _exchangeRate,
    );

    if (!mounted) return;

    switch (result) {
      case Success(data: final res):
        setState(() {
          _generatedNumber = res.entryNumber;
          _statusText = '✅ تم ترحيل القيد بنجاح - ${res.entryNumber}';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ تم ترحيل القيد: ${res.entryNumber}'),
            backgroundColor: Colors.green,
          ),
        );
      case Failure(exception: final e):
        setState(() => _statusText = '❌ ${e.message}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ ${e.message}'),
            backgroundColor: Colors.red,
          ),
        );
    }
  }

  Future<void> _printJournal() async {
    if (_lines.isEmpty || _totalDebit <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('أضف بنود القيد أولاً')));
      return;
    }
    final pdfService = PdfService();
    await pdfService.printReport(
      reportTitle: 'قيد يومية',
      headers: ['الحساب', 'مدين', 'دائن', 'البيان'],
      rows: _lines
          .map(
            (line) => [
              '${line.accountName ?? ''} (${line.accountNumber ?? ''})',
              line.debit.toString(),
              line.credit.toString(),
              line.description ?? '',
            ],
          )
          .toList(),
    );
  }

  Future<void> _showEntriesList() async {
    final entries = await _opService
        .getAccounts(); // نستخدم getAllEntries من repository
    // عرض قائمة بسيطة بالقيود (يمكن تحسينها لاحقاً)
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      builder: (ctx) => ListView.builder(
        itemCount: entries.length,
        itemBuilder: (_, i) {
          final entry = entries[i];
          return ListTile(
            title: Text(
              '${entry['number'] ?? ''} - ${entry['name_ar'] ?? entry['name_en'] ?? ''}',
            ),
          );
        },
      ),
    );
  }

  Future<void> _saveDraft() async {
    if (_lines.isEmpty) return;
    final items = _lines.where((l) => l.accountId != null).map((line) {
      return JournalItem(
        accountId: line.accountId!,
        debit: line.debit,
        credit: line.credit,
        description: line.description,
      );
    }).toList();
    final result = await _opService.saveDraft(
      type: TransactionType.journal,
      date: _selectedDate,
      items: items,
      reference: _referenceCtrl.text,
      currencyCode: _currencyCode,
      exchangeRate: _exchangeRate,
    );
    if (!mounted) return;
    switch (result) {
      case Success(data: final res):
        setState(() {
          _statusText = '✅ تم الحفظ كمسودة';
        });
      case Failure(exception: final e):
        setState(() {
          _statusText = '❌ ${e.message}';
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قيد يومية'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            tooltip: 'طباعة',
            onPressed: _printJournal,
          ),
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'بحث',
            onPressed: _showEntriesList,
          ),
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'عرض القيود',
            onPressed: _showEntriesList,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // التاريخ
            ListTile(
              title: Text('التاريخ: ${_selectedDate.toLocal()}'.split(' ')[0]),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (date != null && mounted)
                  setState(() => _selectedDate = date);
              },
            ),
            const SizedBox(height: 8),

            // العملة وسعر الصرف
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'العملة'),
                    initialValue: _currencyCode,
                    items: _currencies
                        .map(
                          (c) => DropdownMenuItem<String>(
                            value: c['code'],
                            child: Text('${c['name']}'),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _currencyCode = v!),
                  ),
                ),
                const SizedBox(width: 8),
                if (_currencyCode != 'YER')
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'سعر الصرف'),
                      keyboardType: TextInputType.number,
                      initialValue: '1.0',
                      onChanged: (v) =>
                          _exchangeRate = double.tryParse(v) ?? 1.0,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            // البيان
            TextFormField(
              controller: _descriptionCtrl,
              decoration: const InputDecoration(
                labelText: 'البيان',
                hintText: 'وصف القيد',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 8),

            // رقم المرجع
            TextFormField(
              controller: _referenceCtrl,
              decoration: const InputDecoration(labelText: 'رقم المرجع'),
            ),
            const SizedBox(height: 16),

            // رأس الجدول
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: Colors.teal.withValues(alpha: 0.1),
              child: const Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'الحساب',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'مدين',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'دائن',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'البيان',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 40),
                ],
              ),
            ),

            // أسطر القيد
            ..._lines.asMap().entries.map((entry) {
              final idx = entry.key;
              final line = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    // اختيار الحساب
                    Expanded(
                      flex: 3,
                      child: Autocomplete<Map<String, dynamic>>(
                        displayStringForOption: (option) =>
                            '${option['number']} - ${option['name_ar'] ?? option['name_en']}',
                        optionsBuilder: (textEditingValue) {
                          if (textEditingValue.text.isEmpty)
                            return _accounts.take(20);
                          return _accounts
                              .where(
                                (a) =>
                                    (a['name_ar']?.toString().contains(
                                          textEditingValue.text,
                                        ) ??
                                        false) ||
                                    (a['number']?.toString().contains(
                                          textEditingValue.text,
                                        ) ??
                                        false),
                              )
                              .take(20);
                        },
                        onSelected: (selected) {
                          setState(() {
                            _lines[idx].accountId = selected['id'] as int;
                            _lines[idx].accountName =
                                selected['name_ar'] ?? selected['name_en'];
                            _lines[idx].accountNumber = selected['number'];
                          });
                        },
                        fieldViewBuilder:
                            (context, controller, focusNode, onSubmitted) {
                              return TextField(
                                controller: controller,
                                focusNode: focusNode,
                                decoration: InputDecoration(
                                  hintText: 'بحث عن حساب...',
                                  isDense: true,
                                  suffixText: line.accountNumber ?? '',
                                ),
                                onSubmitted: (v) => onSubmitted(),
                              );
                            },
                      ),
                    ),
                    const SizedBox(width: 4),
                    // مدين
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: '0',
                          isDense: true,
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: line.debit > 0
                            ? line.debit.toString()
                            : '',
                        onChanged: (v) => setState(
                          () => _lines[idx].debit = double.tryParse(v) ?? 0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    // دائن
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: '0',
                          isDense: true,
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: line.credit > 0
                            ? line.credit.toString()
                            : '',
                        onChanged: (v) => setState(
                          () => _lines[idx].credit = double.tryParse(v) ?? 0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    // البيان
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'بيان',
                          isDense: true,
                        ),
                        onChanged: (v) =>
                            setState(() => _lines[idx].description = v),
                      ),
                    ),
                    // حذف
                    IconButton(
                      icon: const Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                        size: 20,
                      ),
                      onPressed: () => _removeLine(idx),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 8),

            // إضافة سطر
            OutlinedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('إضافة سطر'),
              onPressed: _addLine,
            ),

            const SizedBox(height: 12),

            // ملخص الأرصدة
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _difference > 0.001
                    ? Colors.red.withValues(alpha: 0.1)
                    : Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'مدين: ${_totalDebit.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'دائن: ${_totalCredit.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'الفرق: ${_difference.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _difference > 0.001 ? Colors.red : Colors.green,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // أزرار
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.check_circle),
                  label: const Text('ترحيل القيد'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _submit,
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('حفظ كمسودة'),
                  onPressed: _saveDraft,
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.clear),
                  label: const Text('إلغاء'),
                  onPressed: () => _formKey.currentState?.reset(),
                ),
              ],
            ),

            if (_statusText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  _statusText,
                  style: TextStyle(
                    color: _statusText.startsWith('✅')
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (_generatedNumber != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'رقم القيد: $_generatedNumber',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
