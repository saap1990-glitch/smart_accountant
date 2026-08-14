import 'package:flutter/material.dart';
import '../../../core/services/operations/operation_service.dart';
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
  DateTime _selectedDate = DateTime.now();
  double _amount = 0;
  String? _selectedSourceType;
  String? _selectedEntityId;
  String? _selectedDestinationEntityId;
  String? _currencyCode = 'YER';
  double _exchangeRate = 1.0;
  List<Map<String, dynamic>> _items = [];
  String _statusText = '';

  Future<void> _submit(bool isDraft) async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final items = <JournalItem>[];

    if (widget.showMultiLines) {
      // For journal, we need at least two lines; simplified for now
      items.add(JournalItem(accountId: 1, debit: _amount));
      items.add(JournalItem(accountId: 2, credit: _amount));
    } else if (widget.showItems) {
      // For invoices/inventory
      double total = 0;
      for (var item in _items) {
        total += (item['quantity'] as double) * (item['price'] as double);
      }
      if (widget.transactionType == TransactionType.sale) {
        items.add(JournalItem(accountId: 1, debit: total)); // customer
        items.add(JournalItem(accountId: 41, credit: total)); // sales revenue
      } else if (widget.transactionType == TransactionType.purchase) {
        items.add(JournalItem(accountId: 113, debit: total)); // inventory
        items.add(JournalItem(accountId: 2, credit: total)); // supplier/cash
      } else if (widget.isInventory) {
        items.add(JournalItem(accountId: 113, debit: _amount));
        items.add(JournalItem(accountId: 4, credit: _amount)); // adjustment
      }
    } else {
      // Simple receipt/payment/transfer
      if (widget.debitAccountPrefix != null) {
        items.add(JournalItem(accountId: int.tryParse(widget.debitAccountPrefix!) ?? 1, debit: _amount));
      }
      if (widget.creditAccountPrefix != null) {
        items.add(JournalItem(accountId: int.tryParse(widget.creditAccountPrefix!) ?? 2, credit: _amount));
      } else {
        // default placeholder
        items.add(JournalItem(accountId: 1, debit: _amount));
        items.add(JournalItem(accountId: 2, credit: _amount));
      }
    }

    Result<TransactionResult> result;
    if (isDraft) {
      result = await widget.operationService.saveDraft(
        type: widget.transactionType,
        date: _selectedDate,
        items: items,
        currencyCode: _currencyCode,
        exchangeRate: _exchangeRate,
        reference: widget.title,
      );
    } else {
      result = await widget.operationService.execute(
        type: widget.transactionType,
        date: _selectedDate,
        items: items,
        currencyCode: _currencyCode,
        exchangeRate: _exchangeRate,
        reference: widget.title,
      );
    }

    switch (result) {
      case Success(data: final res):
        setState(() => _statusText = res.message ?? 'تم بنجاح');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.message ?? 'تم بنجاح')));
        break;
      case Failure(exception: final e):
        setState(() => _statusText = e.message);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Date picker
              ListTile(
                title: Text('التاريخ: ${_selectedDate.toLocal()}'.split(' ')[0]),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (date != null) setState(() => _selectedDate = date);
                },
              ),
              // Amount
              TextFormField(
                decoration: InputDecoration(labelText: widget.amountLabel),
                keyboardType: TextInputType.number,
                onSaved: (v) => _amount = double.tryParse(v ?? '0') ?? 0,
                validator: (v) => (double.tryParse(v ?? '') == null) ? 'أدخل رقماً' : null,
              ),
              SizedBox(height: 10),
              // Source type selection (if applicable)
              if (widget.sourceTypes.isNotEmpty)
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'نوع ${widget.sourceLabel}'),
                  value: _selectedSourceType,
                  items: widget.sourceTypes.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => setState(() => _selectedSourceType = v),
                ),
              // Additional fields could be added here dynamically (entity pickers, currency, etc.)
              SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _submit(false),
                    child: Text('ترحيل'),
                  ),
                  SizedBox(width: 10),
                  OutlinedButton(
                    onPressed: () => _submit(true),
                    child: Text('حفظ كمسودة'),
                  ),
                ],
              ),
              if (_statusText.isNotEmpty) Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(_statusText, style: TextStyle(color: Colors.green)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
