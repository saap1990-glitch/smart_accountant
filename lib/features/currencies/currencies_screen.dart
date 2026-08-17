import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../core/services/master_data/master_data_service.dart';

class CurrenciesScreen extends StatefulWidget {
  const CurrenciesScreen({super.key});

  @override
  State<CurrenciesScreen> createState() => _CurrenciesScreenState();
}

class _CurrenciesScreenState extends State<CurrenciesScreen> {
  final _service = GetIt.I<MasterDataService>();
  final _search = TextEditingController();

  List<Map<String, dynamic>> _currencies = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    if (mounted) setState(() => _loading = true);

    try {
      final data = await _service.getAllCurrencies();

      if (!mounted) return;

      setState(() {
        _currencies = data;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() => _loading = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تعذر تحميل العملات')));
    }
  }

  List<Map<String, dynamic>> get _filtered {
    final query = _search.text.trim().toLowerCase();

    if (query.isEmpty) return _currencies;

    return _currencies.where((currency) {
      final code = '${currency['code'] ?? ''}'.toLowerCase();
      final name = '${currency['name'] ?? ''}'.toLowerCase();

      return code.contains(query) || name.contains(query);
    }).toList();
  }

  Future<void> _showForm({Map<String, dynamic>? existing}) async {
    final code = TextEditingController(text: '${existing?['code'] ?? ''}');

    final name = TextEditingController(text: '${existing?['name'] ?? ''}');

    final rate = TextEditingController(
      text: '${existing?['exchange_rate'] ?? 1}',
    );

    bool isDefault = existing?['is_default'] == true;

    try {
      final saved = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (_, setDialogState) {
              return AlertDialog(
                title: Text(existing == null ? 'إضافة عملة' : 'تعديل العملة'),
                content: SizedBox(
                  width: 450,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: code,
                          textCapitalization: TextCapitalization.characters,
                          decoration: const InputDecoration(
                            labelText: 'رمز العملة *',
                            hintText: 'YER',
                            prefixIcon: Icon(Icons.code),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: name,
                          decoration: const InputDecoration(
                            labelText: 'اسم العملة *',
                            hintText: 'ريال يمني',
                            prefixIcon: Icon(Icons.payments),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: rate,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'سعر الصرف *',
                            hintText: '1',
                            prefixIcon: Icon(Icons.sync_alt),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('العملة الافتراضية'),
                          subtitle: const Text('تستخدم كأساس للنظام'),
                          value: isDefault,
                          onChanged: (value) {
                            setDialogState(() => isDefault = value);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext, false),
                    child: const Text('إلغاء'),
                  ),
                  FilledButton.icon(
                    onPressed: () async {
                      final currencyCode = code.text.trim().toUpperCase();

                      final currencyName = name.text.trim();

                      final exchangeRate = double.tryParse(rate.text.trim());

                      if (currencyCode.isEmpty ||
                          currencyName.isEmpty ||
                          exchangeRate == null ||
                          exchangeRate <= 0) {
                        ScaffoldMessenger.of(dialogContext).showSnackBar(
                          const SnackBar(
                            content: Text('تحقق من بيانات العملة وسعر الصرف'),
                          ),
                        );
                        return;
                      }

                      try {
                        if (existing == null) {
                          await _service.createCurrency(
                            code: currencyCode,
                            name: currencyName,
                            exchangeRate: exchangeRate,
                            isDefault: isDefault,
                          );
                        } else {
                          final id = existing['id'];

                          if (id is! int) {
                            throw Exception('معرف العملة غير صالح');
                          }

                          await _service.updateCurrency(
                            id,
                            currencyCode,
                            currencyName,
                            exchangeRate,
                            isDefault: isDefault,
                          );
                        }

                        if (dialogContext.mounted) {
                          Navigator.pop(dialogContext, true);
                        }
                      } catch (_) {
                        if (!dialogContext.mounted) {
                          return;
                        }

                        ScaffoldMessenger.of(dialogContext).showSnackBar(
                          const SnackBar(content: Text('تعذر حفظ العملة')),
                        );
                      }
                    },
                    icon: const Icon(Icons.save),
                    label: Text(existing == null ? 'حفظ' : 'حفظ التعديل'),
                  ),
                ],
              );
            },
          );
        },
      );

      if (saved == true && mounted) {
        await _load();
      }
    } finally {
      code.dispose();
      name.dispose();
      rate.dispose();
    }
  }

  Future<void> _setDefault(Map<String, dynamic> currency) async {
    final id = currency['id'];

    if (id is! int) return;

    try {
      await _service.setDefaultCurrency(id);

      if (!mounted) return;

      await _load();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تعيين العملة الافتراضية')),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر تعيين العملة الافتراضية')),
      );
    }
  }

  Future<void> _delete(Map<String, dynamic> currency) async {
    final id = currency['id'];

    if (id is! int) return;

    if (currency['is_default'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا يمكن حذف العملة الافتراضية')),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف العملة'),
        content: Text('هل تريد حذف "${currency['name'] ?? ''}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _service.deleteCurrency(id);

      if (!mounted) return;

      await _load();
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا يمكن حذف العملة المرتبطة بعمليات')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencies = _filtered;

    return Scaffold(
      appBar: AppBar(
        title: const Text('العملات وأسعار الصرف'),
        actions: [
          IconButton(
            onPressed: _load,
            tooltip: 'تحديث',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showForm(),
        icon: const Icon(Icons.add),
        label: const Text('إضافة عملة'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _search,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: 'بحث عن عملة',
                hintText: 'الرمز أو اسم العملة...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _search.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _search.clear();
                          setState(() {});
                        },
                        icon: const Icon(Icons.clear),
                      ),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : currencies.isEmpty
                ? _empty()
                : RefreshIndicator(
                    onRefresh: _load,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100),
                      itemCount: currencies.length,
                      itemBuilder: (_, index) {
                        return _currencyCard(currencies[index]);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _currencyCard(Map<String, dynamic> currency) {
    final code = '${currency['code'] ?? ''}';

    final name = '${currency['name'] ?? ''}';

    final rate = '${currency['exchange_rate'] ?? 1}';

    final isDefault = currency['is_default'] == true;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            code.length > 3 ? code.substring(0, 3) : code,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            if (isDefault) const Chip(label: Text('افتراضية')),
          ],
        ),
        subtitle: Text('$code  •  سعر الصرف: $rate'),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              _showForm(existing: currency);
            } else if (value == 'default') {
              _setDefault(currency);
            } else if (value == 'delete') {
              _delete(currency);
            }
          },
          itemBuilder: (_) => [
            const PopupMenuItem(value: 'edit', child: Text('تعديل')),
            if (!isDefault)
              const PopupMenuItem(
                value: 'default',
                child: Text('تعيين كافتراضية'),
              ),
            if (!isDefault)
              const PopupMenuItem(value: 'delete', child: Text('حذف')),
          ],
        ),
      ),
    );
  }

  Widget _empty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.currency_exchange, size: 64),
          const SizedBox(height: 12),
          const Text(
            'لا توجد عملات',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => _showForm(),
            icon: const Icon(Icons.add),
            label: const Text('إضافة أول عملة'),
          ),
        ],
      ),
    );
  }
}
