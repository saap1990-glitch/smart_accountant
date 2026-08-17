import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../core/services/reports/report_service.dart';

class ReportViewScreen extends StatefulWidget {
  final String type;

  const ReportViewScreen({super.key, required this.type});

  @override
  State<ReportViewScreen> createState() => _ReportViewScreenState();
}

class _ReportViewScreenState extends State<ReportViewScreen> {
  final ReportService _service = GetIt.I<ReportService>();

  DateTime _from = DateTime.now();
  DateTime _to = DateTime.now();

  int? _accountId;
  int? _itemId;

  List<Map<String, dynamic>> _accounts = [];
  List<Map<String, dynamic>> _items = [];

  dynamic _data;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSources();
  }

  String get _title {
    switch (widget.type) {
      case 'general':
        return 'دفتر الأستاذ العام';
      case 'trial':
        return 'ميزان المراجعة';
      case 'income':
        return 'قائمة الدخل';
      case 'balance':
        return 'الميزانية العمومية';
      case 'cash':
        return 'التدفقات النقدية';
      case 'profit':
        return 'تقرير الأرباح';
      case 'inventory':
        return 'تقرير المخزون';
      case 'item':
        return 'حركة الصنف';
      default:
        return 'التقرير';
    }
  }

  IconData get _icon {
    switch (widget.type) {
      case 'trial':
        return Icons.account_balance;
      case 'income':
      case 'profit':
        return Icons.trending_up;
      case 'balance':
        return Icons.balance;
      case 'cash':
        return Icons.payments;
      case 'inventory':
        return Icons.inventory_2;
      case 'item':
        return Icons.swap_vert;
      default:
        return Icons.description;
    }
  }

  Future<void> _loadSources() async {
    try {
      final accounts = await _service.getAccounts();
      final items = await _service.getItems();

      if (!mounted) return;

      setState(() {
        _accounts = accounts;
        _items = items;
      });

      if (!_needsAccount && !_needsItem) {
        await _loadReport();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString());
      }
    }
  }

  bool get _needsAccount => widget.type == 'general';

  bool get _needsItem => widget.type == 'item';

  Future<void> _loadReport() async {
    if (_needsAccount && _accountId == null) {
      setState(() => _error = 'اختر الحساب أولاً');
      return;
    }

    if (_needsItem && _itemId == null) {
      setState(() => _error = 'اختر الصنف أولاً');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      dynamic result;

      switch (widget.type) {
        case 'general':
          result = await _service.generalLedger(
            accountId: _accountId!,
            from: _from,
            to: _to,
          );
          break;

        case 'trial':
          result = await _service.trialBalance(_to);
          break;

        case 'income':
          result = await _service.incomeStatement(from: _from, to: _to);
          break;

        case 'balance':
          result = await _service.balanceSheet(_to);
          break;

        case 'cash':
          result = await _service.cashFlow(from: _from, to: _to);
          break;

        case 'profit':
          result = await _service.profitReport(from: _from, to: _to);
          break;

        case 'inventory':
          result = await _service.inventoryReport();
          break;

        case 'item':
          result = await _service.itemMovementReport(
            itemId: _itemId!,
            from: _from,
            to: _to,
          );
          break;

        default:
          throw Exception('نوع التقرير غير معروف');
      }

      if (!mounted) return;

      setState(() {
        _data = result;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _pickDate(bool from) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: from ? _from : _to,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('ar'),
    );

    if (selected == null) return;

    setState(() {
      if (from) {
        _from = selected;
      } else {
        _to = selected;
      }
    });
  }

  String _date(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }

  String _money(dynamic value) {
    if (value == null) return '0.00';

    if (value is num) {
      return value.toStringAsFixed(2);
    }

    return double.tryParse(value.toString())?.toStringAsFixed(2) ??
        value.toString();
  }

  String _text(dynamic value) {
    return value?.toString() ?? '';
  }

  Widget _selector<T>({
    required String label,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: items,
      onChanged: onChanged,
    );
  }

  Widget _filters() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickDate(true),
                    icon: const Icon(Icons.date_range),
                    label: Text('من ${_date(_from)}'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickDate(false),
                    icon: const Icon(Icons.event),
                    label: Text('إلى ${_date(_to)}'),
                  ),
                ),
              ],
            ),
            if (_needsAccount) ...[
              const SizedBox(height: 12),
              _selector<int>(
                label: 'الحساب',
                value: _accountId,
                items: _accounts
                    .map((account) {
                      final id = int.tryParse('${account['id']}');
                      return DropdownMenuItem<int>(
                        value: id,
                        child: Text(
                          '${account['number'] ?? ''} - ${account['name_ar'] ?? account['name_en'] ?? ''}',
                        ),
                      );
                    })
                    .where((e) => e.value != null)
                    .toList(),
                onChanged: (value) {
                  setState(() => _accountId = value);
                },
              ),
            ],
            if (_needsItem) ...[
              const SizedBox(height: 12),
              _selector<int>(
                label: 'الصنف',
                value: _itemId,
                items: _items
                    .map((item) {
                      final id = int.tryParse('${item['id']}');
                      return DropdownMenuItem<int>(
                        value: id,
                        child: Text('${item['name'] ?? ''}'),
                      );
                    })
                    .where((e) => e.value != null)
                    .toList(),
                onChanged: (value) {
                  setState(() => _itemId = value);
                },
              ),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _loading ? null : _loadReport,
                icon: const Icon(Icons.search),
                label: const Text('عرض التقرير'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMap(Map<String, dynamic> map) {
    return Column(
      children: map.entries
          .where((e) => e.value is! List && e.value is! Map)
          .map(
            (e) => Card(
              child: ListTile(
                title: Text(e.key),
                trailing: Text(
                  e.value is num ? _money(e.value) : _text(e.value),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildList(List list) {
    if (list.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Center(child: Text('لا توجد بيانات لهذا التقرير')),
        ),
      );
    }

    return Column(
      children: list.map((row) {
        if (row is! Map) {
          return Card(child: ListTile(title: Text(_text(row))));
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: row.entries
                  .where((e) => e.value is! List && e.value is! Map)
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              e.key,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              e.value is num ? _money(e.value) : _text(e.value),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _reportBody() {
    if (_data == null) {
      return const SizedBox.shrink();
    }

    if (_data is Map<String, dynamic>) {
      return _buildMap(_data);
    }

    if (_data is List) {
      return _buildList(_data);
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(_text(_data)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_title),
          centerTitle: true,
          leading: Icon(_icon),
        ),
        body: RefreshIndicator(
          onRefresh: _loadReport,
          child: ListView(
            padding: const EdgeInsets.all(14),
            children: [
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      CircleAvatar(radius: 28, child: Icon(_icon, size: 30)),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _title,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Text('${_date(_from)} → ${_date(_to)}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _filters(),
              const SizedBox(height: 16),
              if (_loading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: CircularProgressIndicator(),
                  ),
                ),
              if (_error != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              if (!_loading && _error == null) _reportBody(),
            ],
          ),
        ),
      ),
    );
  }
}
