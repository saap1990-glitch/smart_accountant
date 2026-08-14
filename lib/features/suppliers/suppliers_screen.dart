import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../core/services/master_data/master_data_service.dart';
import '../../core/services/accounting/accounting_link_service.dart';
import '../../core/database/app_database.dart';

class SuppliersScreen extends StatefulWidget {
  const SuppliersScreen({super.key});
  @override
  State<SuppliersScreen> createState() => _SuppliersScreenState();
}

class _SuppliersScreenState extends State<SuppliersScreen> {
  final _dataService = GetIt.I<MasterDataService>();
  final _linkService = GetIt.I<AccountingLinkService>();
  List<Map<String, dynamic>> _suppliers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final suppliers = await _dataService.getAllSuppliers();
    for (var s in suppliers) {
      final accountId = await _linkService.getLinkedAccount('suppliers', 'Supplier', s['id'].toString());
      s['account_id'] = accountId;
      s['balance'] = 0;
    }
    setState(() { _suppliers = suppliers; _loading = false; });
  }

  void _showForm({Map<String, dynamic>? existing}) {
    final nameCtrl = TextEditingController(text: existing?['name'] ?? '');
    final phoneCtrl = TextEditingController(text: existing?['phone'] ?? '');
    final addressCtrl = TextEditingController(text: existing?['address'] ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existing != null ? 'تعديل مورد' : 'إضافة مورد جديد'),
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
                await _dataService.updateSupplier(existing['id'] as int, name: nameCtrl.text, phone: phoneCtrl.text, address: addressCtrl.text);
              } else {
                await _dataService.createSupplier(name: nameCtrl.text, phone: phoneCtrl.text, address: addressCtrl.text);
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
      appBar: AppBar(title: const Text('الموردين'), actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})]),
      floatingActionButton: FloatingActionButton(onPressed: () => _showForm(), child: const Icon(Icons.add)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _suppliers.isEmpty
              ? const Center(child: Text('لا يوجد موردين'))
              : ListView.builder(
                  itemCount: _suppliers.length,
                  itemBuilder: (ctx, index) {
                    final s = _suppliers[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(backgroundColor: Colors.orange.withOpacity(0.1), child: const Icon(Icons.business, color: Colors.orange)),
                        title: Text(s['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (s['phone'] != null) Text('📞 ${s['phone']}'),
                            if (s['address'] != null) Text('📍 ${s['address']}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showForm(existing: s)),
                            IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () async {
                              await _dataService.deleteSupplier(s['id'] as int);
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
