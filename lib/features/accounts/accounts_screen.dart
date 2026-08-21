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
  final _service = GetIt.I<MasterDataService>();
  final _ledgerRepo = GetIt.I<LedgerRepository>();
  final _search = TextEditingController();

  List<Map<String, dynamic>> _accounts = [];
  Map<int, double> _balances = {};
  bool _loading = true;
  String _type = 'all';
  String _status = 'all';

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
    setState(() => _loading = true);
    try {
      final data = await _service.getAllAccounts();
      // جلب الأرصدة للحسابات النهائية
      final balances = <int, double>{};
      for (final account in data) {
        final id = int.tryParse('${account['id']}');
        if (id != null) {
          balances[id] = await _ledgerRepo.getBalance(id);
        }
      }
      if (!mounted) return;
      setState(() {
        _accounts = data;
        _balances = balances;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('تعذر تحميل الحسابات: $e')));
    }
  }

  List<Map<String, dynamic>> get _filtered {
    final q = _search.text.trim().toLowerCase();
    return _accounts.where((a) {
      final number = '${a['number'] ?? ''}'.toLowerCase();
      final name = '${a['name_ar'] ?? a['name_en'] ?? ''}'.toLowerCase();
      final type = '${a['type'] ?? ''}'.toLowerCase();
      final active = a['is_active'] != false;

      final searchOk = q.isEmpty || number.contains(q) || name.contains(q);
      final typeOk = _type == 'all' || type == _type;
      final statusOk =
          _status == 'all' ||
          (_status == 'active' && active) ||
          (_status == 'inactive' && !active);
      return searchOk && typeOk && statusOk;
    }).toList();
  }

  String _typeName(String type) {
    switch (type) {
      case 'asset':
        return 'الأصول';
      case 'liability':
        return 'الخصوم';
      case 'expense':
        return 'المصروفات';
      case 'revenue':
        return 'الإيرادات';
      default:
        return type;
    }
  }

  IconData _icon(String type) {
    switch (type) {
      case 'asset':
        return Icons.account_balance;
      case 'liability':
        return Icons.payments;
      case 'expense':
        return Icons.trending_down;
      case 'revenue':
        return Icons.trending_up;
      default:
        return Icons.account_tree;
    }
  }

  Future<void> _open([Map<String, dynamic>? account]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AccountDetailScreen(account: account)),
    );
    if (mounted) await _load();
  }

  @override
  Widget build(BuildContext context) {
    final accounts = _filtered;
    return Scaffold(
      appBar: AppBar(
        title: const Text('دليل الحسابات'),
        actions: [
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _open(),
        icon: const Icon(Icons.add),
        label: const Text('حساب جديد'),
      ),
      body: Column(
        children: [
          _filters(),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : accounts.isEmpty
                ? const Center(child: Text('لا توجد حسابات مطابقة'))
                : RefreshIndicator(
                    onRefresh: _load,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 90),
                      itemCount: accounts.length,
                      itemBuilder: (_, i) => _accountTile(accounts[i]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _filters() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          TextField(
            controller: _search,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'بحث برقم أو اسم الحساب',
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
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _type,
                  decoration: const InputDecoration(
                    labelText: 'النوع',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('كل الأنواع')),
                    DropdownMenuItem(value: 'asset', child: Text('الأصول')),
                    DropdownMenuItem(value: 'liability', child: Text('الخصوم')),
                    DropdownMenuItem(
                      value: 'expense',
                      child: Text('المصروفات'),
                    ),
                    DropdownMenuItem(
                      value: 'revenue',
                      child: Text('الإيرادات'),
                    ),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => _type = v);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _status,
                  decoration: const InputDecoration(
                    labelText: 'الحالة',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('الكل')),
                    DropdownMenuItem(value: 'active', child: Text('نشطة')),
                    DropdownMenuItem(value: 'inactive', child: Text('موقوفة')),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => _status = v);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _accountTile(Map<String, dynamic> account) {
    final type = '${account['type'] ?? ''}';
    final active = account['is_active'] != false;
    final level = int.tryParse('${account['level'] ?? 1}') ?? 1;
    final id = int.tryParse('${account['id']}');
    final balance = id != null ? _balances[id] ?? 0 : 0;
    final number = '${account['number'] ?? ''}';
    final name = '${account['name_ar'] ?? account['name_en'] ?? ''}';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        onTap: () => _open(account),
        contentPadding: EdgeInsets.only(left: 16, right: 8 + level * 8),
        leading: Icon(_icon(type)),
        title: Text(
          '$number  $name',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${_typeName(type)} • المستوى $level'),
            if (id != null && account['accepts_posting'] == true)
              Text('الرصيد: ${balance.toStringAsFixed(2)} ريال'),
          ],
        ),
        trailing: Icon(
          active ? Icons.check_circle_outline : Icons.pause_circle_outline,
        ),
      ),
    );
  }
}
