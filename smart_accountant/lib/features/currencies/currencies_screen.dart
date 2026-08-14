import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../core/services/master_data/master_data_service.dart';

class CurrenciesScreen extends StatefulWidget {
  const CurrenciesScreen({super.key});

  @override
  State<CurrenciesScreen> createState() => _CurrenciesScreenState();
}

class _CurrenciesScreenState extends State<CurrenciesScreen> {
  final _dataService = GetIt.I<MasterDataService>();
  List<Map<String, dynamic>> _currencies = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrencies();
  }

  Future<void> _loadCurrencies() async {
    setState(() => _loading = true);
    var currencies = await _dataService.getAllCurrencies();
    if (currencies.isEmpty) {
      await _dataService.createCurrency(code: 'YER', name: 'ريال يمني', exchangeRate: 1.0, isDefault: true);
      await _dataService.createCurrency(code: 'USD', name: 'دولار أمريكي', exchangeRate: 1400.0);
      await _dataService.createCurrency(code: 'SAR', name: 'ريال سعودي', exchangeRate: 370.0);
      currencies = await _dataService.getAllCurrencies();
    }
    setState(() { _currencies = currencies; _loading = false; });
  }

  void _showAddForm() {
    final codeCtrl = TextEditingController();
    final nameCtrl = TextEditingController();
    final rateCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إضافة عملة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: codeCtrl, decoration: const InputDecoration(labelText: 'الرمز (EUR)')),
            const SizedBox(height: 8),
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'الاسم (يورو)')),
            const SizedBox(height: 8),
            TextField(controller: rateCtrl, decoration: const InputDecoration(labelText: 'سعر الصرف مقابل الريال اليمني'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () async {
              if (codeCtrl.text.isNotEmpty && nameCtrl.text.isNotEmpty) {
                await _dataService.createCurrency(code: codeCtrl.text.toUpperCase(), name: nameCtrl.text, exchangeRate: double.tryParse(rateCtrl.text) ?? 1.0);
                Navigator.pop(ctx);
                _loadCurrencies();
              }
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  void _showEditForm(Map<String, dynamic> currency) {
    final nameCtrl = TextEditingController(text: currency['name']);
    final rateCtrl = TextEditingController(text: currency['exchange_rate']?.toString() ?? '1.0');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('تحديث ${currency['code']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'الاسم')),
            const SizedBox(height: 8),
            TextField(controller: rateCtrl, decoration: const InputDecoration(labelText: 'سعر الصرف مقابل الريال اليمني'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () async {
              await _dataService.updateCurrency(currency['id'] as int, currency['code'] as String, nameCtrl.text, double.tryParse(rateCtrl.text) ?? 1.0);
              Navigator.pop(ctx);
              _loadCurrencies();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ تم التحديث')));
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('العملات')),
      floatingActionButton: FloatingActionButton(onPressed: _showAddForm, child: const Icon(Icons.add)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: _currencies.map((c) {
                final isDefault = c['is_default'] == true;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: isDefault ? const BorderSide(color: Colors.teal, width: 2) : BorderSide.none),
                  child: ListTile(
                    leading: CircleAvatar(backgroundColor: isDefault ? Colors.teal : Colors.grey.shade200, child: Text(c['code']?.toString().substring(0, 1) ?? '?', style: TextStyle(color: isDefault ? Colors.white : Colors.black, fontWeight: FontWeight.bold))),
                    title: Text(c['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('الرمز: ${c['code']}'),
                        Text('سعر الصرف: ${c['exchange_rate'] ?? '1.0'} ريال'),
                        if (isDefault) const Text('⭐ العملة الافتراضية', style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isDefault)
                          IconButton(icon: const Icon(Icons.star_border, color: Colors.teal), tooltip: 'تعيين كافتراضي', onPressed: () async {
                            await _dataService.setDefaultCurrency(c['id'] as int);
                            _loadCurrencies();
                          }),
                        IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showEditForm(c)),
                        if (!isDefault)
                          IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () async {
                            await _dataService.deleteCurrency(c['id'] as int);
                            _loadCurrencies();
                          }),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }
}
