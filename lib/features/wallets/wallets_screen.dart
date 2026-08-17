import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../core/services/master_data/master_data_service.dart';

class WalletsScreen extends StatefulWidget {
  const WalletsScreen({super.key});

  @override
  State<WalletsScreen> createState() => _WalletsScreenState();
}

class _WalletsScreenState extends State<WalletsScreen> {
  final _service = GetIt.I<MasterDataService>();
  final _search = TextEditingController();

  List<Map<String, dynamic>> _wallets = [];
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
      final data = await _service.getAllWallets();

      if (!mounted) return;

      setState(() {
        _wallets = data;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() => _loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تعذر تحميل المحافظ')));
    }
  }

  List<Map<String, dynamic>> get _filtered {
    final q = _search.text.trim().toLowerCase();

    if (q.isEmpty) return _wallets;

    return _wallets.where((wallet) {
      final name = '${wallet['name'] ?? ''}'.toLowerCase();
      return name.contains(q);
    }).toList();
  }

  Future<void> _addWallet() async {
    final controller = TextEditingController();

    try {
      final saved = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('إضافة محفظة إلكترونية'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'اسم المحفظة *',
              hintText: 'مثال: جوالي',
              prefixIcon: Icon(Icons.account_balance_wallet),
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('إلغاء'),
            ),
            FilledButton.icon(
              onPressed: () async {
                final name = controller.text.trim();

                if (name.isEmpty) return;

                await _service.createWallet(name: name);

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
      controller.dispose();
    }
  }

  Future<void> _deleteWallet(Map<String, dynamic> wallet) async {
    final id = wallet['id'];

    if (id is! int) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف المحفظة'),
        content: Text('هل تريد حذف "${wallet['name'] ?? ''}"؟'),
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
      await _service.deleteWallet(id);

      if (!mounted) return;

      await _load();
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا يمكن حذف المحفظة المرتبطة بعمليات')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final wallets = _filtered;

    return Scaffold(
      appBar: AppBar(
        title: const Text('المحافظ الإلكترونية'),
        actions: [
          IconButton(
            onPressed: _load,
            tooltip: 'تحديث',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addWallet,
        icon: const Icon(Icons.add),
        label: const Text('إضافة محفظة'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _search,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: 'بحث في المحافظ',
                hintText: 'مثال: جوالي أو فلوسك...',
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
                : wallets.isEmpty
                ? _empty()
                : RefreshIndicator(
                    onRefresh: _load,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100),
                      itemCount: wallets.length,
                      itemBuilder: (_, index) {
                        final wallet = wallets[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.account_balance_wallet),
                            ),
                            title: Text(
                              '${wallet['name'] ?? ''}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: const Text('محفظة إلكترونية'),
                            trailing: IconButton(
                              tooltip: 'حذف',
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => _deleteWallet(wallet),
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
          const Icon(Icons.account_balance_wallet_outlined, size: 64),
          const SizedBox(height: 12),
          const Text(
            'لا توجد محافظ إلكترونية',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _addWallet,
            icon: const Icon(Icons.add),
            label: const Text('إضافة أول محفظة'),
          ),
        ],
      ),
    );
  }
}
