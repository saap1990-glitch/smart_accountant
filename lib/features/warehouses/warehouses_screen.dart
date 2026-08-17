import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../core/services/master_data/master_data_service.dart';

class WarehousesScreen extends StatefulWidget {
  const WarehousesScreen({super.key});

  @override
  State<WarehousesScreen> createState() => _WarehousesScreenState();
}

class _WarehousesScreenState extends State<WarehousesScreen> {
  final _service = GetIt.I<MasterDataService>();
  final _search = TextEditingController();

  List<Map<String, dynamic>> _warehouses = [];
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
      final data = await _service.getAllWarehouses();

      if (!mounted) return;

      setState(() {
        _warehouses = data;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() => _loading = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تعذر تحميل المستودعات')));
    }
  }

  List<Map<String, dynamic>> get _filtered {
    final q = _search.text.trim().toLowerCase();

    if (q.isEmpty) return _warehouses;

    return _warehouses.where((w) {
      return [
        w['name'],
        w['code'],
        w['location'],
        w['address'],
      ].any((v) => '${v ?? ''}'.toLowerCase().contains(q));
    }).toList();
  }

  Future<void> _showForm({Map<String, dynamic>? existing}) async {
    final name = TextEditingController(text: '${existing?['name'] ?? ''}');
    final code = TextEditingController(text: '${existing?['code'] ?? ''}');
    final location = TextEditingController(
      text: '${existing?['location'] ?? ''}',
    );
    final address = TextEditingController(
      text: '${existing?['address'] ?? ''}',
    );
    final notes = TextEditingController(text: '${existing?['notes'] ?? ''}');

    bool active = existing?['is_active'] != false;

    try {
      final result = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                title: Text(
                  existing == null ? 'إضافة مستودع' : 'تعديل المستودع',
                ),
                content: SingleChildScrollView(
                  child: SizedBox(
                    width: 480,
                    child: Column(
                      children: [
                        TextField(
                          controller: name,
                          decoration: const InputDecoration(
                            labelText: 'اسم المستودع *',
                            prefixIcon: Icon(Icons.warehouse),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: code,
                          decoration: const InputDecoration(
                            labelText: 'رمز المستودع',
                            prefixIcon: Icon(Icons.tag),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: location,
                          decoration: const InputDecoration(
                            labelText: 'الموقع',
                            prefixIcon: Icon(Icons.location_on_outlined),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: address,
                          decoration: const InputDecoration(
                            labelText: 'العنوان',
                            prefixIcon: Icon(Icons.place_outlined),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: notes,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'ملاحظات',
                            prefixIcon: Icon(Icons.notes),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('المستودع نشط'),
                          value: active,
                          onChanged: (v) {
                            setDialogState(() => active = v);
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
                    icon: const Icon(Icons.save),
                    label: const Text('حفظ'),
                    onPressed: () async {
                      if (name.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('اسم المستودع مطلوب')),
                        );
                        return;
                      }

                      try {
                        if (existing == null) {
                          await _service.createWarehouse(
                            name: name.text.trim(),
                            code: code.text.trim().isEmpty
                                ? null
                                : code.text.trim(),
                            location: location.text.trim().isEmpty
                                ? null
                                : location.text.trim(),
                            address: address.text.trim().isEmpty
                                ? null
                                : address.text.trim(),
                            notes: notes.text.trim().isEmpty
                                ? null
                                : notes.text.trim(),
                            isActive: active,
                          );
                        } else {
                          await _service.updateWarehouse(
                            existing['id'] as int,
                            name: name.text.trim(),
                            code: code.text.trim().isEmpty
                                ? null
                                : code.text.trim(),
                            location: location.text.trim().isEmpty
                                ? null
                                : location.text.trim(),
                            address: address.text.trim().isEmpty
                                ? null
                                : address.text.trim(),
                            notes: notes.text.trim().isEmpty
                                ? null
                                : notes.text.trim(),
                            isActive: active,
                          );
                        }

                        if (dialogContext.mounted) {
                          Navigator.pop(dialogContext, true);
                        }
                      } catch (_) {
                        if (!dialogContext.mounted) return;

                        ScaffoldMessenger.of(dialogContext).showSnackBar(
                          const SnackBar(content: Text('تعذر حفظ المستودع')),
                        );
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
      );

      if (result == true && mounted) {
        await _load();
      }
    } finally {
      name.dispose();
      code.dispose();
      location.dispose();
      address.dispose();
      notes.dispose();
    }
  }

  Future<void> _delete(Map<String, dynamic> warehouse) async {
    final id = warehouse['id'];

    if (id is! int) return;

    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف المستودع'),
        content: Text('هل تريد حذف "${warehouse['name'] ?? ''}"؟'),
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

    if (ok != true) return;

    try {
      await _service.deleteWarehouse(id);

      if (!mounted) return;

      await _load();
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('لا يمكن حذف المستودع لأنه مرتبط ببيانات أخرى'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final warehouses = _filtered;

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المستودعات'),
        actions: [
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showForm(),
        icon: const Icon(Icons.add),
        label: const Text('إضافة مستودع'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _search,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: 'بحث ذكي',
                hintText: 'اسم، رمز، موقع أو عنوان...',
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
                : warehouses.isEmpty
                ? const Center(child: Text('لا توجد مستودعات'))
                : RefreshIndicator(
                    onRefresh: _load,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100),
                      itemCount: warehouses.length,
                      itemBuilder: (_, index) {
                        return _warehouseCard(warehouses[index]);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _warehouseCard(Map<String, dynamic> warehouse) {
    final active = warehouse['is_active'] != false;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(active ? Icons.warehouse : Icons.warehouse_outlined),
        ),
        title: Text(
          '${warehouse['name'] ?? ''}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${warehouse['code'] ?? 'بدون رمز'}'
          '${warehouse['location'] == null ? '' : ' • ${warehouse['location']}'}'
          '\n${active ? 'نشط' : 'متوقف'}',
        ),
        isThreeLine: true,
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              _showForm(existing: warehouse);
            } else {
              _delete(warehouse);
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
}
