import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../core/services/master_data/master_data_service.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  final _service = GetIt.I<MasterDataService>();
  final _searchController = TextEditingController();

  List<Map<String, dynamic>> _items = [];
  List<Map<String, dynamic>> _units = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    if (mounted) setState(() => _loading = true);

    try {
      final results = await Future.wait([
        _service.getAllItems(),
        _service.getAllUnits(),
      ]);

      if (!mounted) return;

      setState(() {
        _items = results[0];
        _units = results[1];
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() => _loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر تحميل بيانات الأصناف')),
      );
    }
  }

  List<Map<String, dynamic>> get _filteredItems {
    final query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) return _items;

    return _items.where((item) {
      final name = '${item['name'] ?? ''}'.toLowerCase();
      final unit = '${item['unit'] ?? ''}'.toLowerCase();

      return name.contains(query) || unit.contains(query);
    }).toList();
  }

  Future<void> _showForm({Map<String, dynamic>? existing}) async {
    final name = TextEditingController(text: '${existing?['name'] ?? ''}');

    final cost = TextEditingController(
      text: existing?['cost']?.toString() ?? '',
    );

    final price = TextEditingController(
      text: existing?['price']?.toString() ?? '',
    );

    String? selectedUnit = existing?['unit'];

    if (selectedUnit != null &&
        !_units.any((u) => '${u['name']}' == selectedUnit)) {
      selectedUnit = null;
    }

    try {
      final saved = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                title: Text(
                  existing == null ? 'إضافة صنف جديد' : 'تعديل الصنف',
                ),
                content: SizedBox(
                  width: 450,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: name,
                          autofocus: true,
                          decoration: const InputDecoration(
                            labelText: 'اسم الصنف *',
                            hintText: 'أدخل اسم الصنف',
                            prefixIcon: Icon(Icons.inventory_2),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: selectedUnit,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'وحدة القياس *',
                            prefixIcon: Icon(Icons.straighten),
                            border: OutlineInputBorder(),
                          ),
                          items: _units
                              .map(
                                (unit) => DropdownMenuItem<String>(
                                  value: '${unit['name']}',
                                  child: Text('${unit['name']}'),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setDialogState(() => selectedUnit = value);
                          },
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: cost,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'تكلفة الشراء',
                            prefixIcon: Icon(Icons.shopping_cart),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: price,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'سعر البيع',
                            prefixIcon: Icon(Icons.sell),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        if (_units.isEmpty) ...[
                          const SizedBox(height: 12),
                          const Text(
                            'لا توجد وحدات قياس. أضف وحدة أولًا.',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
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
                      final itemName = name.text.trim();

                      if (itemName.isEmpty) {
                        ScaffoldMessenger.of(dialogContext).showSnackBar(
                          const SnackBar(content: Text('اسم الصنف مطلوب')),
                        );
                        return;
                      }

                      if (selectedUnit == null) {
                        ScaffoldMessenger.of(dialogContext).showSnackBar(
                          const SnackBar(content: Text('اختر وحدة القياس')),
                        );
                        return;
                      }

                      final costValue = double.tryParse(cost.text.trim());

                      final priceValue = double.tryParse(price.text.trim());

                      try {
                        if (existing == null) {
                          await _service.createItem(
                            name: itemName,
                            unit: selectedUnit!,
                            cost: costValue ?? 0,
                            price: priceValue ?? 0,
                          );
                        } else {
                          final id = existing['id'];

                          if (id is! int) {
                            throw Exception('معرف الصنف غير صالح');
                          }

                          await _service.updateItem(
                            id,
                            name: itemName,
                            unit: selectedUnit!,
                            cost: costValue ?? 0,
                            price: priceValue ?? 0,
                          );
                        }

                        if (dialogContext.mounted) {
                          Navigator.pop(dialogContext, true);
                        }
                      } catch (_) {
                        if (!dialogContext.mounted) return;

                        ScaffoldMessenger.of(dialogContext).showSnackBar(
                          const SnackBar(
                            content: Text('تعذر حفظ بيانات الصنف'),
                          ),
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
      name.dispose();
      cost.dispose();
      price.dispose();
    }
  }

  Future<void> _deleteItem(Map<String, dynamic> item) async {
    final id = item['id'];

    if (id is! int) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الصنف'),
        content: Text('هل تريد حذف "${item['name'] ?? ''}"؟'),
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
      await _service.deleteItem(id);

      if (!mounted) return;

      await _load();
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('لا يمكن حذف الصنف لأنه مستخدم في بيانات أخرى'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _filteredItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الأصناف والمخزون'),
        actions: [
          IconButton(
            tooltip: 'تحديث',
            onPressed: _load,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showForm(),
        icon: const Icon(Icons.add),
        label: const Text('إضافة صنف'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: 'بحث ذكي عن صنف',
                hintText: 'الاسم أو الوحدة...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _searchController.clear();
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
                : items.isEmpty
                ? _emptyState()
                : RefreshIndicator(
                    onRefresh: _load,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100),
                      itemCount: items.length,
                      itemBuilder: (_, index) {
                        return _itemCard(items[index]);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _itemCard(Map<String, dynamic> item) {
    final name = '${item['name'] ?? ''}';
    final unit = '${item['unit'] ?? ''}';

    final cost = item['cost'];
    final price = item['price'];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(child: const Icon(Icons.inventory_2)),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              Text('الوحدة: $unit'),
              Text('التكلفة: ${cost ?? 0}'),
              Text('البيع: ${price ?? 0}'),
            ],
          ),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              _showForm(existing: item);
            } else if (value == 'delete') {
              _deleteItem(item);
            }
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'edit', child: Text('تعديل')),
            PopupMenuItem(value: 'delete', child: Text('حذف')),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inventory_2,
            size: 64,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          const Text(
            'لا توجد أصناف',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text('ابدأ بإضافة أصنافك ووحدات القياس الخاصة بها'),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => _showForm(),
            icon: const Icon(Icons.add),
            label: const Text('إضافة أول صنف'),
          ),
        ],
      ),
    );
  }
}
