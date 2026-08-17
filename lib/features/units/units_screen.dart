import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../core/services/master_data/master_data_service.dart';

class UnitsScreen extends StatefulWidget {
  const UnitsScreen({super.key});

  @override
  State<UnitsScreen> createState() => _UnitsScreenState();
}

class _UnitsScreenState extends State<UnitsScreen> {
  final _service = GetIt.I<MasterDataService>();
  final _search = TextEditingController();

  List<Map<String, dynamic>> _units = [];
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
      final data = await _service.getAllUnits();

      if (!mounted) return;

      setState(() {
        _units = data;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() => _loading = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تعذر تحميل الوحدات')));
    }
  }

  List<Map<String, dynamic>> get _filtered {
    final query = _search.text.trim().toLowerCase();

    if (query.isEmpty) return _units;

    return _units.where((unit) {
      final name = '${unit['name'] ?? ''}'.toLowerCase();
      final abbreviation = '${unit['abbreviation'] ?? ''}'.toLowerCase();

      return name.contains(query) || abbreviation.contains(query);
    }).toList();
  }

  Future<void> _addUnit() async {
    final name = TextEditingController();
    final abbreviation = TextEditingController();

    try {
      final saved = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('إضافة وحدة قياس'),
            content: SizedBox(
              width: 420,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: name,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'اسم الوحدة *',
                      hintText: 'مثال: قطعة، كرتون، كيلو',
                      prefixIcon: Icon(Icons.straighten),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: abbreviation,
                    decoration: const InputDecoration(
                      labelText: 'الاختصار',
                      hintText: 'مثال: كجم، م، حبة',
                      prefixIcon: Icon(Icons.short_text),
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
                  if (name.text.trim().isEmpty) {
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      const SnackBar(content: Text('اسم الوحدة مطلوب')),
                    );
                    return;
                  }

                  try {
                    await _service.createUnit(
                      name: name.text.trim(),
                      abbreviation: abbreviation.text.trim().isEmpty
                          ? null
                          : abbreviation.text.trim(),
                    );

                    if (dialogContext.mounted) {
                      Navigator.pop(dialogContext, true);
                    }
                  } catch (_) {
                    if (!dialogContext.mounted) return;

                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      const SnackBar(content: Text('تعذر حفظ الوحدة')),
                    );
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
      abbreviation.dispose();
    }
  }

  Future<void> _deleteUnit(Map<String, dynamic> unit) async {
    final id = unit['id'];

    if (id is! int) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الوحدة'),
        content: Text('هل تريد حذف "${unit['name'] ?? ''}"؟'),
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
      await _service.deleteUnit(id);

      if (!mounted) return;

      await _load();
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('لا يمكن حذف الوحدة لأنها مستخدمة في بيانات أخرى'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final units = _filtered;

    return Scaffold(
      appBar: AppBar(
        title: const Text('وحدات القياس'),
        actions: [
          IconButton(
            onPressed: _load,
            tooltip: 'تحديث',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addUnit,
        icon: const Icon(Icons.add),
        label: const Text('إضافة وحدة'),
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
                hintText: 'اسم الوحدة أو الاختصار...',
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
                : units.isEmpty
                ? _emptyState()
                : RefreshIndicator(
                    onRefresh: _load,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100),
                      itemCount: units.length,
                      itemBuilder: (_, index) {
                        return _unitCard(units[index]);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _unitCard(Map<String, dynamic> unit) {
    final name = '${unit['name'] ?? ''}';
    final abbreviation = '${unit['abbreviation'] ?? ''}';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(child: const Icon(Icons.straighten)),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          abbreviation.isEmpty ? 'بدون اختصار' : 'الاختصار: $abbreviation',
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'delete') {
              _deleteUnit(unit);
            }
          },
          itemBuilder: (_) => const [
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
            Icons.straighten,
            size: 64,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          const Text(
            'لا توجد وحدات قياس',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text('أضف الوحدات التي تستخدمها في الأصناف'),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _addUnit,
            icon: const Icon(Icons.add),
            label: const Text('إضافة أول وحدة'),
          ),
        ],
      ),
    );
  }
}
