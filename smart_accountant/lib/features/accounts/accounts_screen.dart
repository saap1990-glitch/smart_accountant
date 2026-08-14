import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../core/services/master_data/master_data_service.dart';
import 'account_detail_screen.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  final _dataService = GetIt.I<MasterDataService>();

  List<Map<String, dynamic>> _allAccounts = [];
  Map<int?, List<Map<String, dynamic>>> _tree = {};
  Set<int> _expandedNodes = {};
  String _searchQuery = '';
  String? _filterType;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    setState(() => _loading = true);
    final accounts = await _dataService.getAllAccounts();
    setState(() {
      _allAccounts = accounts;
      _buildTree();
      _loading = false;
      for (var acc in accounts) {
        if (acc['level'] == 1) _expandedNodes.add(acc['id'] as int);
      }
    });
  }

  void _buildTree() {
    _tree.clear();
    for (var acc in _allAccounts) {
      final parentId = acc['parent_id'] as int?;
      _tree.putIfAbsent(parentId, () => []).add(acc);
    }
  }

  List<Map<String, dynamic>> _getChildren(int? parentId) {
    List<Map<String, dynamic>> children = _tree[parentId] ?? [];
    if (_searchQuery.isNotEmpty) {
      children = children.where((c) => (c['name_ar'] ?? '').toString().contains(_searchQuery) || (c['number'] ?? '').toString().contains(_searchQuery)).toList();
    }
    if (_filterType != null) {
      children = children.where((c) => c['type'] == _filterType).toList();
    }
    return children;
  }

  Color _getColor(String? type) {
    switch (type) {
      case 'asset': return Colors.green;
      case 'liability': return Colors.red;
      case 'expense': return Colors.orange;
      case 'revenue': return Colors.blue;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('دليل الحسابات'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: () => _showAddForm()),
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (v) => setState(() => _filterType = v == 'all' ? null : v),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'all', child: Text('الكل')),
              PopupMenuItem(value: 'asset', child: Text('الأصول')),
              PopupMenuItem(value: 'liability', child: Text('الخصوم')),
              PopupMenuItem(value: 'expense', child: Text('المصروفات')),
              PopupMenuItem(value: 'revenue', child: Text('الإيرادات')),
            ],
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    decoration: const InputDecoration(hintText: 'بحث عن حساب...', prefixIcon: Icon(Icons.search), isDense: true),
                    onChanged: (v) => setState(() => _searchQuery = v),
                  ),
                ),
                Expanded(
                  child: _allAccounts.isEmpty
                      ? const Center(child: Text('لا توجد حسابات'))
                      : ListView(
                          children: _buildTreeWidgets(null, 0),
                        ),
                ),
              ],
            ),
    );
  }

  List<Widget> _buildTreeWidgets(int? parentId, int depth) {
    final children = _getChildren(parentId);
    return children.map((account) {
      final id = account['id'] as int;
      final hasChildren = _tree.containsKey(id);
      final isExpanded = _expandedNodes.contains(id);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              if (hasChildren) {
                setState(() { if (isExpanded) { _expandedNodes.remove(id); } else { _expandedNodes.add(id); } });
              }
              // فتح شاشة التفاصيل
              Navigator.push(context, MaterialPageRoute(builder: (_) => AccountDetailScreen(account: account))).then((_) => _loadAccounts());
            },
            child: Container(
              padding: EdgeInsets.only(right: 16.0 + depth * 24.0, left: 8, top: 8, bottom: 8),
              color: _colorWithOpacity(_getColor(account['type'])),
              child: Row(
                children: [
                  Icon(hasChildren ? (isExpanded ? Icons.folder_open : Icons.folder) : Icons.description, color: _getColor(account['type']), size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${account['number']} - ${account['name_ar'] ?? account['name_en'] ?? ''}',
                      style: TextStyle(fontWeight: FontWeight.bold, color: _getColor(account['type'])),
                    ),
                  ),
                  const Icon(Icons.chevron_left, size: 18, color: Colors.grey),
                ],
              ),
            ),
          ),
          if (hasChildren && isExpanded) ..._buildTreeWidgets(id, depth + 1),
        ],
      );
    }).toList();
  }

  Color _colorWithOpacity(Color color) {
    return color.withOpacity(0.03);
  }

  void _showAddForm() {
    final nameArCtrl = TextEditingController();
    String? type = 'asset';
    String? nature = 'debit';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('إضافة حساب جديد'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'نوع الحساب'),
                value: type,
                items: const [
                  DropdownMenuItem(value: 'asset', child: Text('أصل')),
                  DropdownMenuItem(value: 'liability', child: Text('خصم')),
                  DropdownMenuItem(value: 'expense', child: Text('مصروف')),
                  DropdownMenuItem(value: 'revenue', child: Text('إيراد')),
                ],
                onChanged: (v) => setDialogState(() => type = v),
              ),
              const SizedBox(height: 8),
              TextField(controller: nameArCtrl, decoration: const InputDecoration(labelText: 'الاسم العربي *')),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'الطبيعة'),
                value: nature,
                items: const [
                  DropdownMenuItem(value: 'debit', child: Text('مدين 🔻')),
                  DropdownMenuItem(value: 'credit', child: Text('دائن 🔺')),
                ],
                onChanged: (v) => setDialogState(() => nature = v),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
            ElevatedButton(
              onPressed: () async {
                if (nameArCtrl.text.trim().isEmpty) return;
                await _dataService.createAccount(
                  number: '${_allAccounts.length + 1}',
                  nameAr: nameArCtrl.text,
                  nameEn: null,
                  type: type!,
                  nature: nature!,
                  parentId: null,
                  level: 1,
                );
                Navigator.pop(ctx);
                _loadAccounts();
              },
              child: const Text('إضافة'),
            ),
          ],
        ),
      ),
    );
  }
}
