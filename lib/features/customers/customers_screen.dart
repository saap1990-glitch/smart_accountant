import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../core/services/master_data/master_data_service.dart';
import '../../core/services/accounting/accounting_link_service.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});
  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final _dataService = GetIt.I<MasterDataService>();
  final _linkService = GetIt.I<AccountingLinkService>();
  List<Map<String, dynamic>> _customers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final customers = await _dataService.getAllCustomers();
    for (var c in customers) {
      final accountId = await _linkService.getLinkedAccount('customers', 'Customer', c['id'].toString());
      c['account_id'] = accountId;
      c['balance'] = 0;
    }
    setState(() { _customers = customers; _loading = false; });
  }

  void _showForm({Map<String, dynamic>? existing}) {
    final nameCtrl = TextEditingController(text: existing?['name'] ?? '');
    final phoneCtrl = TextEditingController(text: existing?['phone'] ?? '');
    final addressCtrl = TextEditingController(text: existing?['address'] ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existing != null ? 'تعديل عميل' : 'إضافة عميل جديد'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'الاسم *')),
              const SizedBox(height: 8),
              TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'رقم الهاتف'), keyboardType: TextInputType.phone),
              const SizedBox(height: 8),
              TextField(controller: addressCtrl, decoration: const InputDecoration(labelText: 'العنوان'), maxLines: 2),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () async {
              if (nameCtrl.text.trim().isEmpty) return;
              if (existing != null) {
                await _dataService.updateCustomer(existing['id'] as int, name: nameCtrl.text, phone: phoneCtrl.text, address: addressCtrl.text);
              } else {
                await _dataService.createCustomer(name: nameCtrl.text, phone: phoneCtrl.text, address: addressCtrl.text);
              }
              Navigator.pop(ctx);
              _loadData();
            },
            child: Text(existing != null ? 'حفظ' : 'إضافة'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('العملاء'), actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})]),
      floatingActionButton: FloatingActionButton(onPressed: () => _showForm(), child: const Icon(Icons.add)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _customers.isEmpty
              ? const Center(child: Text('لا يوجد عملاء'))
              : ListView.builder(
                  itemCount: _customers.length,
                  itemBuilder: (ctx, index) {
                    final c = _customers[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(backgroundColor: Colors.teal.withOpacity(0.1), child: const Icon(Icons.person, color: Colors.teal)),
                        title: Text(c['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (c['phone'] != null) Text('📞 ${c['phone']}'),
                            if (c['address'] != null) Text('📍 ${c['address']}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showForm(existing: c)),
                            IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () async {
                              await _dataService.deleteCustomer(c['id'] as int);
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
