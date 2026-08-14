import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../core/services/master_data/master_data_service.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});
  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  final _dataService = GetIt.I<MasterDataService>();
  List<Map<String, dynamic>> _items = [];
  List<Map<String, dynamic>> _units = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final items = await _dataService.getAllItems();
    final units = await _dataService.getAllUnits();
    setState(() { _items = items; _units = units; _loading = false; });
  }

  void _showForm({Map<String, dynamic>? existing}) {
    final nameCtrl = TextEditingController(text: existing?['name'] ?? '');
    String? selectedUnit = existing?['unit'];
    final costCtrl = TextEditingController(text: existing?['cost']?.toString() ?? '0');
    final priceCtrl = TextEditingController(text: existing?['price']?.toString() ?? '0');

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(existing != null ? 'تعديل صنف' : 'إضافة صنف جديد'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'اسم الصنف *')),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'الوحدة'),
                  value: selectedUnit,
                  items: _units.map((u) => DropdownMenuItem<String>(value: u['name'] as String?, child: Text((u['name'] ?? '') as String))).toList(),
                  onChanged: (v) => setDialogState(() => selectedUnit = v),
                ),
                const SizedBox(height: 8),
                TextField(controller: costCtrl, decoration: const InputDecoration(labelText: 'تكلفة الشراء'), keyboardType: TextInputType.number),
                const SizedBox(height: 8),
                TextField(controller: priceCtrl, decoration: const InputDecoration(labelText: 'سعر البيع'), keyboardType: TextInputType.number),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
            ElevatedButton(
              onPressed: () async {
                if (nameCtrl.text.trim().isEmpty) return;
                if (existing != null) {
                  await _dataService.updateItem(existing['id'] as int, name: nameCtrl.text, unit: selectedUnit ?? '', cost: double.tryParse(costCtrl.text), price: double.tryParse(priceCtrl.text));
                } else {
                  await _dataService.createItem(name: nameCtrl.text, unit: selectedUnit ?? '', cost: double.tryParse(costCtrl.text), price: double.tryParse(priceCtrl.text));
                }
                Navigator.pop(ctx);
                _loadData();
              },
              child: Text(existing != null ? 'حفظ' : 'إضافة'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الأصناف'), actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})]),
      floatingActionButton: FloatingActionButton(onPressed: () => _showForm(), child: const Icon(Icons.add)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? const Center(child: Text('لا يوجد أصناف'))
              : ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (ctx, index) {
                    final item = _items[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(backgroundColor: Colors.blue.withOpacity(0.1), child: const Icon(Icons.inventory, color: Colors.blue)),
                        title: Text(item['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('الوحدة: ${item['unit']} | التكلفة: ${item['cost']} | البيع: ${item['price']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showForm(existing: item)),
                            IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () async {
                              await _dataService.deleteItem(item['id'] as int);
                              _loadData();
                            }),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
