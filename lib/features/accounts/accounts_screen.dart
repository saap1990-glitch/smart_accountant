import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../core/services/master_data/master_data_service.dart';
import '../../core/repositories/ledger_repository.dart';
import 'account_detail_screen.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  final _dataService = GetIt.I<MasterDataService>();
  final _ledgerRepo = GetIt.I<LedgerRepository>();

  List<Map<String, dynamic>> _allAccounts = [];
  Map<int?, List<Map<String, dynamic>>> _tree = {};
  Set<int> _expandedNodes = {};
  Map<int, double> _balances = {};
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
    final balances = <int, double>{};
    for (var acc in accounts) {
      final accId = acc['id'] as int;
      try {
        balances[accId] = await _ledgerRepo.getBalance(accId);
      } catch (_) {
        balances[accId] = 0;
      }
    }
    setState(() {
      _allAccounts = accounts;
      _balances = balances;
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

  bool _isPostingAccount(Map<String, dynamic> acc) {
    return acc['level'] >= 4 || acc['accepts_posting'] == true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('دليل الحسابات'),
        actions: [
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
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadAccounts),
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
                // ملخص الأرصدة
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(color: Colors.teal.withOpacity(0.05), borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('الأصول: ${_getTypeTotal('asset').toStringAsFixed(0)}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                      Text('الخصوم: ${_getTypeTotal('liability').toStringAsFixed(0)}', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      Text('المصروفات: ${_getTypeTotal('expense').toStringAsFixed(0)}', style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                      Text('الإيرادات: ${_getTypeTotal('revenue').toStringAsFixed(0)}', style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Expanded(
                  child: _allAccounts.isEmpty
                      ? const Center(child: Text('لا توجد حسابات'))
                      : ListView(children: _buildTreeWidgets(null, 0)),
                ),
              ],
            ),
    );
  }

  double _getTypeTotal(String type) {
    return _allAccounts.where((a) => a['type'] == type).fold(0.0, (sum, a) => sum + (_balances[a['id']] ?? 0).abs());
  }

  List<Widget> _buildTreeWidgets(int? parentId, int depth) {
    final children = _getChildren(parentId);
    return children.map((account) {
      final id = account['id'] as int;
      final hasChildren = _tree.containsKey(id);
      final isExpanded = _expandedNodes.contains(id);
      final balance = _balances[id] ?? 0;
      final isPosting = _isPostingAccount(account);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              if (hasChildren) {
                setState(() { if (isExpanded) { _expandedNodes.remove(id); } else { _expandedNodes.add(id); } });
              }
              Navigator.push(context, MaterialPageRoute(builder: (_) => AccountDetailScreen(account: account))).then((_) => _loadAccounts());
            },
            child: Container(
              padding: EdgeInsets.only(right: 16.0 + depth * 24.0, left: 8, top: 6, bottom: 6),
              color: _getColor(account['type']).withOpacity(0.02),
              child: Row(
                children: [
                  Icon(hasChildren ? (isExpanded ? Icons.folder_open : Icons.folder) : Icons.description, color: _getColor(account['type']), size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${account['number']} - ${account['name_ar'] ?? account['name_en'] ?? ''}',
                      style: TextStyle(fontWeight: isPosting ? FontWeight.bold : FontWeight.w500, color: _getColor(account['type'])),
                    ),
                  ),
                  if (isPosting)
                    Text(balance.toStringAsFixed(0), style: TextStyle(fontWeight: FontWeight.bold, color: balance >= 0 ? Colors.green : Colors.red)),
                  const Icon(Icons.chevron_left, size: 16, color: Colors.grey),
                ],
              ),
            ),
          ),
          if (hasChildren && isExpanded) ..._buildTreeWidgets(id, depth + 1),
        ],
      );
    }).toList();
  }
}
