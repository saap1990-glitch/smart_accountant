import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../core/services/inventory/inventory_count_service.dart';
import '../../../core/services/master_data/master_data_service.dart';

class InventoryCountScreen extends StatefulWidget {
  const InventoryCountScreen({super.key});

  @override
  State<InventoryCountScreen> createState() => _InventoryCountScreenState();
}

class _InventoryCountScreenState extends State<InventoryCountScreen> {
  final _countService = GetIt.I<InventoryCountService>();
  final _dataService = GetIt.I<MasterDataService>();

  List<Map<String, dynamic>> _warehouses = [];
  List<Map<String, dynamic>> _items = [];
  String? _selectedWarehouseId;
  final List<Map<String, dynamic>> _countItems = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final warehouses = await _dataService.getAllWarehouses();
    final items = await _dataService.getAllItems();
    setState(() {
      _warehouses = warehouses;
      _items = items;
    });
  }

  void _addItemToCount(Map<String, dynamic> item) {
    setState(() {
      _countItems.add({
        'itemId': item['id'],
        'itemName': item['name'],
        'expectedQty': '0',
        'actualQty': '0',
      });
    });
  }

  Future<void> _performCount() async {
    if (_selectedWarehouseId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اختر المخزن أولاً')));
      return;
    }
    if (_countItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('أضف أصنافاً للجرد')));
      return;
    }

    final result = await _countService.performCount(
      warehouseId: int.parse(_selectedWarehouseId!),
      items: _countItems,
      notes: 'جرد ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
    );

    if (mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('نتيجة الجرد'),
          content: Text('التسويات: ${result['adjustments']}\nإجمالي الفرق: ${result['totalDifference']}\nرقم التسوية: ${result['number'] ?? '-'}'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('موافق'))],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الجرد الفعلي')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'المخزن'),
            value: _selectedWarehouseId,
            items: _warehouses.map((w) => DropdownMenuItem(value: w['id'].toString(), child: Text(w['name'] ?? ''))).toList(),
            onChanged: (v) => setState(() => _selectedWarehouseId = v),
          ),
          const SizedBox(height: 16),
          const Text('إضافة أصناف للجرد:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ..._items.map((item) => ListTile(
            leading: const Icon(Icons.inventory),
            title: Text(item['name'] ?? ''),
            trailing: IconButton(icon: const Icon(Icons.add_circle, color: Colors.teal), onPressed: () => _addItemToCount(item)),
          )),
          const Divider(),
          if (_countItems.isNotEmpty) ...[
            const Text('أصناف الجرد:', style: TextStyle(fontWeight: FontWeight.bold)),
            ..._countItems.asMap().entries.map((entry) {
              final idx = entry.key;
              final item = entry.value;
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(flex: 3, child: Text(item['itemName'] ?? '')),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(labelText: 'المتوقع', isDense: true),
                          keyboardType: TextInputType.number,
                          onChanged: (v) => setState(() => _countItems[idx]['expectedQty'] = v),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(labelText: 'الفعلي', isDense: true),
                          keyboardType: TextInputType.number,
                          onChanged: (v) => setState(() => _countItems[idx]['actualQty'] = v),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.check_circle),
            label: const Text('تنفيذ الجرد'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
            onPressed: _performCount,
          ),
        ],
      ),
    );
  }
}
