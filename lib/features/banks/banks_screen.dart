import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../core/services/master_data/master_data_service.dart';

class BanksScreen extends StatefulWidget {
  const BanksScreen({super.key});

  @override
  State<BanksScreen> createState() => _BanksScreenState();
}

class _BanksScreenState extends State<BanksScreen> {
  final _service = GetIt.I<MasterDataService>();
  final _search = TextEditingController();

  List<Map<String, dynamic>> _banks = [];
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
      final data = await _service.getAllBanks();

      if (!mounted) return;

      setState(() {
        _banks = data;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() => _loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تعذر تحميل البنوك')));
    }
  }

  List<Map<String, dynamic>> get _filtered {
    final q = _search.text.trim().toLowerCase();

    if (q.isEmpty) return _banks;

    return _banks.where((bank) {
      final name = '${bank['name'] ?? ''}'.toLowerCase();
      final number = '${bank['account_number'] ?? ''}'.toLowerCase();

      return name.contains(q) || number.contains(q);
    }).toList();
  }

  Future<void> _showForm() async {
    final name = TextEditingController();
    final account = TextEditingController();

    try {
      final saved = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('إضافة بنك'),
          content: SizedBox(
            width: 450,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: name,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'اسم البنك *',
                    hintText: 'مثال: بنك الكريمي',
                    prefixIcon: Icon(Icons.account_balance),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: account,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'رقم الحساب',
                    prefixIcon: Icon(Icons.numbers),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('إلغاء'),
            ),
            FilledButton.icon(
              onPressed: () async {
                if (name.text.trim().isEmpty) return;

                await _service.createBank(
                  name: name.text.trim(),
                  accountNumber: account.text.trim().isEmpty
                      ? null
                      : account.text.trim(),
                );

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext, true);
                }
              },
              icon: const Icon(Icons.save),
              label: const Text('حفظ'),
            ),
          ],
        ),
      );

      if (saved == true && mounted) {
        await _load();
      }
    } finally {
      name.dispose();
      account.dispose();
    }
  }

  Future<void> _deleteBank(Map<String, dynamic> bank) async {
    final id = bank['id'];

    if (id is! int) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف البنك'),
        content: Text('هل تريد حذف "${bank['name'] ?? ''}"؟'),
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
      await _service.deleteBank(id);

      if (!mounted) return;

      await _load();
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا يمكن حذف البنك المرتبط بعمليات')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final banks = _filtered;

    return Scaffold(
      appBar: AppBar(
        title: const Text('البنوك'),
        actions: [
          IconButton(
            onPressed: _load,
            tooltip: 'تحديث',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showForm,
        icon: const Icon(Icons.add),
        label: const Text('إضافة بنك'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _search,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: 'بحث في البنوك',
                hintText: 'اسم البنك أو رقم الحساب...',
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
                : banks.isEmpty
                ? _empty()
                : RefreshIndicator(
                    onRefresh: _load,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100),
                      itemCount: banks.length,
                      itemBuilder: (_, index) {
                        final bank = banks[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.account_balance),
                            ),
                            title: Text(
                              '${bank['name'] ?? ''}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              bank['account_number'] == null ||
                                      '${bank['account_number']}'.trim().isEmpty
                                  ? 'لا يوجد رقم حساب'
                                  : 'رقم الحساب: ${bank['account_number']}',
                            ),
                            trailing: IconButton(
                              tooltip: 'حذف',
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => _deleteBank(bank),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _empty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.account_balance_outlined, size: 64),
          const SizedBox(height: 12),
          const Text(
            'لا توجد بنوك',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _showForm,
            icon: const Icon(Icons.add),
            label: const Text('إضافة أول بنك'),
          ),
        ],
      ),
    );
  }
}
