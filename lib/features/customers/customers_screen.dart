import 'package:flutter/material.dart';

import '../../core/di/service_locator.dart';
import '../../core/services/master_data/master_data_service.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final MasterDataService _service = sl<MasterDataService>();
  final TextEditingController _search = TextEditingController();

  List<Map<String, dynamic>> _customers = [];
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
      final data = await _service.getAllCustomers();

      if (!mounted) return;

      setState(() {
        _customers = data;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => _loading = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('فشل تحميل العملاء')));
    }
  }

  List<Map<String, dynamic>> get _filtered {
    final q = _search.text.trim().toLowerCase();

    if (q.isEmpty) return _customers;

    return _customers.where((customer) {
      final name = '${customer['name'] ?? ''}'.toLowerCase();
      final phone = '${customer['phone'] ?? ''}'.toLowerCase();
      final address = '${customer['address'] ?? ''}'.toLowerCase();

      return name.contains(q) || phone.contains(q) || address.contains(q);
    }).toList();
  }

  Future<void> _deleteCustomer(Map<String, dynamic> customer) async {
    final id = customer['id'];

    if (id is! int) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('حذف العميل'),
          content: Text('هل تريد حذف العميل "${customer['name'] ?? ''}"؟'),
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
        );
      },
    );

    if (confirmed != true) return;

    try {
      await _service.deleteCustomer(id);

      if (!mounted) return;

      await _load();

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم حذف العميل')));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تعذر حذف العميل')));
    }
  }

  Future<void> _showForm({Map<String, dynamic>? existing}) async {
    final name = TextEditingController(text: '${existing?['name'] ?? ''}');

    final phone = TextEditingController(text: '${existing?['phone'] ?? ''}');

    final address = TextEditingController(
      text: '${existing?['address'] ?? ''}',
    );

    final formKey = GlobalKey<FormState>();

    try {
      final saved = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text(existing == null ? 'عميل جديد' : 'تعديل العميل'),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: name,
                      decoration: const InputDecoration(
                        labelText: 'اسم العميل',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'أدخل اسم العميل';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: phone,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'رقم الهاتف',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: address,
                      decoration: const InputDecoration(
                        labelText: 'العنوان',
                        prefixIcon: Icon(Icons.location_on),
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
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
                  if (!formKey.currentState!.validate()) return;

                  try {
                    if (existing == null) {
                      await _service.createCustomer(
                        name: name.text.trim(),
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
                        throw Exception('معرف العميل غير صالح');
                      }

                      await _service.updateCustomer(
                        id,
                        name: name.text.trim(),
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
                    if (dialogContext.mounted) {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        const SnackBar(content: Text('تعذر حفظ بيانات العميل')),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.save),
                label: const Text('حفظ'),
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

  @override
  Widget build(BuildContext context) {
    final customers = _filtered;

    return Scaffold(
      appBar: AppBar(
        title: const Text('العملاء'),
        actions: [
          IconButton(
            tooltip: 'تحديث',
            onPressed: _loading ? null : _load,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showForm(),
        icon: const Icon(Icons.person_add),
        label: const Text('عميل جديد'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _search,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: 'بحث',
                hintText: 'اسم العميل أو الهاتف أو العنوان',
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
                : customers.isEmpty
                ? RefreshIndicator(
                    onRefresh: _load,
                    child: ListView(
                      children: const [
                        SizedBox(height: 180),
                        Center(child: Text('لا يوجد عملاء')),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _load,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                        bottom: 100,
                      ),
                      itemCount: customers.length,
                      itemBuilder: (context, index) {
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
    final name = '${customer['name'] ?? 'بدون اسم'}';
    final phone = customer['phone'];
    final address = customer['address'];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (phone != null && '$phone'.trim().isNotEmpty)
              Text('الهاتف: $phone'),
            if (address != null && '$address'.trim().isNotEmpty)
              Text('العنوان: $address'),
            const Text(
              'الحساب المحاسبي مرتبط تلقائياً',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        isThreeLine: true,
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              _showForm(existing: customer);
            } else if (value == 'delete') {
              _deleteCustomer(customer);
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'edit',
              child: ListTile(leading: Icon(Icons.edit), title: Text('تعديل')),
            ),
            PopupMenuItem(
              value: 'delete',
              child: ListTile(leading: Icon(Icons.delete), title: Text('حذف')),
            ),
          ],
        ),
      ),
    );
  }
}
