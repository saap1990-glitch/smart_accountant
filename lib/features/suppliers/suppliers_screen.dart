import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../core/services/master_data/master_data_service.dart';

class SuppliersScreen extends StatefulWidget {
  const SuppliersScreen({super.key});

  @override
  State<SuppliersScreen> createState() => _SuppliersScreenState();
}

class _SuppliersScreenState extends State<SuppliersScreen> {
  final _service = GetIt.I<MasterDataService>();
  final _searchController = TextEditingController();

  List<Map<String, dynamic>> _suppliers = [];
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
      final data = await _service.getAllSuppliers();

      if (!mounted) return;

      setState(() {
        _suppliers = data;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() => _loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر تحميل بيانات الموردين')),
      );
    }
  }

  List<Map<String, dynamic>> get _filtered {
    final query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) return _suppliers;

    return _suppliers.where((supplier) {
      final name = '${supplier['name'] ?? ''}'.toLowerCase();
      final phone = '${supplier['phone'] ?? ''}'.toLowerCase();
      final address = '${supplier['address'] ?? ''}'.toLowerCase();

      return name.contains(query) ||
          phone.contains(query) ||
          address.contains(query);
    }).toList();
  }

  Future<void> _showForm({Map<String, dynamic>? existing}) async {
    final name = TextEditingController(text: '${existing?['name'] ?? ''}');

    final phone = TextEditingController(text: '${existing?['phone'] ?? ''}');

    final address = TextEditingController(
      text: '${existing?['address'] ?? ''}',
    );

    try {
      final saved = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text(existing == null ? 'إضافة مورد' : 'تعديل المورد'),
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
                        labelText: 'اسم المورد *',
                        prefixIcon: Icon(Icons.business),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: phone,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'رقم الهاتف',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: address,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'العنوان',
                        prefixIcon: Icon(Icons.location_on),
                        border: OutlineInputBorder(),
                      ),
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
                  final supplierName = name.text.trim();

                  if (supplierName.isEmpty) {
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      const SnackBar(content: Text('اسم المورد مطلوب')),
                    );
                    return;
                  }

                  try {
                    if (existing == null) {
                      await _service.createSupplier(
                        name: supplierName,
                        phone: phone.text.trim().isEmpty
                            ? null
                            : phone.text.trim(),
                        address: address.text.trim().isEmpty
                            ? null
                            : address.text.trim(),
                      );
                    } else {
                      final id = existing['id'];

                      if (id is! int) {
                        throw Exception('معرف المورد غير صالح');
                      }

                      await _service.updateSupplier(
                        id,
                        name: supplierName,
                        phone: phone.text.trim().isEmpty
                            ? null
                            : phone.text.trim(),
                        address: address.text.trim().isEmpty
                            ? null
                            : address.text.trim(),
                      );
                    }

                    if (dialogContext.mounted) {
                      Navigator.pop(dialogContext, true);
                    }
                  } catch (_) {
                    if (!dialogContext.mounted) return;

                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      const SnackBar(content: Text('تعذر حفظ بيانات المورد')),
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

      if (saved == true && mounted) {
        await _load();
      }
    } finally {
      name.dispose();
      phone.dispose();
      address.dispose();
    }
  }

  Future<void> _deleteSupplier(Map<String, dynamic> supplier) async {
    final id = supplier['id'];

    if (id is! int) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف المورد'),
        content: Text('هل تريد حذف "${supplier['name'] ?? ''}"؟'),
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
      await _service.deleteSupplier(id);

      if (!mounted) return;

      await _load();
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('لا يمكن حذف المورد لأنه مرتبط ببيانات أخرى'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final suppliers = _filtered;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الموردون'),
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
        icon: const Icon(Icons.person_add),
        label: const Text('إضافة مورد'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: 'بحث ذكي',
                hintText: 'الاسم أو الهاتف أو العنوان...',
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
                : suppliers.isEmpty
                ? _emptyState()
                : RefreshIndicator(
                    onRefresh: _load,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100),
                      itemCount: suppliers.length,
                      itemBuilder: (_, index) {
                        return _supplierCard(suppliers[index]);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _supplierCard(Map<String, dynamic> supplier) {
    final name = '${supplier['name'] ?? ''}';
    final phone = '${supplier['phone'] ?? ''}';
    final address = '${supplier['address'] ?? ''}';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.business)),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (phone.isNotEmpty) Text('الهاتف: $phone'),
              if (address.isNotEmpty) Text('العنوان: $address'),
            ],
          ),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              _showForm(existing: supplier);
            } else if (value == 'delete') {
              _deleteSupplier(supplier);
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
            Icons.business,
            size: 64,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          const Text(
            'لا يوجد موردون',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text('أضف الموردين لإدارة المشتريات والحسابات'),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => _showForm(),
            icon: const Icon(Icons.person_add),
            label: const Text('إضافة أول مورد'),
          ),
        ],
      ),
    );
  }
}
