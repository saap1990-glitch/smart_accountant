import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../core/services/master_data/master_data_service.dart';

class CashBoxesScreen extends StatefulWidget {
  const CashBoxesScreen({super.key});

  @override
  State<CashBoxesScreen> createState() => _CashBoxesScreenState();
}

class _CashBoxesScreenState extends State<CashBoxesScreen> {
  final _service = GetIt.I<MasterDataService>();
  final _search = TextEditingController();

  List<Map<String, dynamic>> _boxes = [];
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
      final data = await _service.getAllCashBoxes();

      if (!mounted) return;

      setState(() {
        _boxes = data;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() => _loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تعذر تحميل الخزائن')));
    }
  }

  List<Map<String, dynamic>> get _filtered {
    final q = _search.text.trim().toLowerCase();

    if (q.isEmpty) return _boxes;

    return _boxes.where((box) {
      final name = '${box['name'] ?? ''}'.toLowerCase();
      return name.contains(q);
    }).toList();
  }

  Future<void> _addBox() async {
    final controller = TextEditingController();

    try {
      final saved = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('إضافة خزينة'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'اسم الخزينة *',
              hintText: 'مثال: الخزينة الرئيسية',
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
                if (controller.text.trim().isEmpty) {
                  return;
                }

                await _service.createCashBox(name: controller.text.trim());

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

  Future<void> _deleteBox(Map<String, dynamic> box) async {
    final id = box['id'];

    if (id is! int) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الخزينة'),
        content: Text('هل تريد حذف "${box['name'] ?? ''}"؟'),
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
      await _service.deleteCashBox(id);

      if (!mounted) return;

      await _load();
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا يمكن حذف الخزينة المرتبطة بعمليات')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final boxes = _filtered;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الخزائن'),
        actions: [
          IconButton(
            onPressed: _load,
            icon: const Icon(Icons.refresh),
            tooltip: 'تحديث',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addBox,
        icon: const Icon(Icons.add),
        label: const Text('إضافة خزينة'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _search,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: 'بحث في الخزائن',
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
                : boxes.isEmpty
                ? _empty()
                : RefreshIndicator(
                    onRefresh: _load,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100),
                      itemCount: boxes.length,
                      itemBuilder: (_, index) {
                        final box = boxes[index];

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
                              '${box['name'] ?? ''}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: const Text('خزينة نقدية'),
                            trailing: IconButton(
                              tooltip: 'حذف',
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => _deleteBox(box),
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
            'لا توجد خزائن',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _addBox,
            icon: const Icon(Icons.add),
            label: const Text('إضافة أول خزينة'),
          ),
        ],
      ),
    );
  }
}
