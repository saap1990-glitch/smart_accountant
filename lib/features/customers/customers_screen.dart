import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../core/services/master_data/master_data_service.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final _service = GetIt.I<MasterDataService>();
  final _searchController = TextEditingController();

  List<Map<String, dynamic>> _customers = [];
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
      final data = await _service.getAllCustomers();

      if (!mounted) return;

      setState(() {
        _customers = data;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() => _loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر تحميل بيانات العملاء')),
      );
    }
  }

  List<Map<String, dynamic>> get _filtered {
    final query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) return _customers;

    return _customers.where((customer) {
      final name = '${customer['name'] ?? ''}'.toLowerCase();
      final phone = '${customer['phone'] ?? ''}'.toLowerCase();
      final address = '${customer['address'] ?? ''}'.toLowerCase();

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
            title: Text(existing == null ? 'إضافة عميل' : 'تعديل العميل'),
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
                        labelText: 'اسم العميل *',
                        prefixIcon: Icon(Icons.person),
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
                  final customerName = name.text.trim();

                  if (customerName.isEmpty) {
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      const SnackBar(content: Text('اسم العميل مطلوب')),
                    );
                    return;
                  }

                  try {
                    final phoneValue = phone.text.trim().isEmpty
                        ? null
                        : phone.text.trim();

                    final addressValue = address.text.trim().isEmpty
                        ? null
                        : address.text.trim();

                    if (existing == null) {
                      await _service.createCustomer(
                        name: customerName,
                        phone: phoneValue,
                        address: addressValue,
                      );
                    } else {
                      final id = existing['id'];

                      if (id is! int) {
                        throw Exception('معرف العميل غير صالح');
                      }

                      await _service.updateCustomer(
                        id,
                        name: customerName,
                        phone: phoneValue,
                        address: addressValue,
                      );
                    }

                    if (dialogContext.mounted) {
                      Navigator.pop(dialogContext, true);
                    }
                  } catch (_) {
                    if (!dialogContext.mounted) return;

                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      const SnackBar(content: Text('تعذر حفظ بيانات العميل')),
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

  Future<void> _deleteCustomer(Map<String, dynamic> customer) async {
    final id = customer['id'];

    if (id is! int) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف العميل'),
        content: Text('هل تريد حذف "${customer['name'] ?? ''}"؟'),
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
      await _service.deleteCustomer(id);

      if (!mounted) return;

      await _load();
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('لا يمكن حذف العميل لأنه مرتبط ببيانات أخرى'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final customers = _filtered;

    return Scaffold(
      appBar: AppBar(
        title: const Text('العملاء'),
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
        label: const Text('إضافة عميل'),
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
                : customers.isEmpty
                ? _emptyState()
                : RefreshIndicator(
                    onRefresh: _load,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100),
                      itemCount: customers.length,
                      itemBuilder: (_, index) {
                        return _customerCard(customers[index]);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _customerCard(Map<String, dynamic> customer) {
    final name = '${customer['name'] ?? ''}';
    final phone = '${customer['phone'] ?? ''}';
    final address = '${customer['address'] ?? ''}';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
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
              _showForm(existing: customer);
            } else if (value == 'delete') {
              _deleteCustomer(customer);
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
            Icons.people_outline,
            size: 64,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          const Text(
            'لا يوجد عملاء',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text('أضف العملاء لإدارة المبيعات والحسابات'),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => _showForm(),
            icon: const Icon(Icons.person_add),
            label: const Text('إضافة أول عميل'),
          ),
        ],
      ),
    );
  }
}
