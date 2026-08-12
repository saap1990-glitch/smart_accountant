import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../core/services/master_data/master_data_service.dart';
import '../../core/services/accounting/accounting_link_service.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  final _dataService = GetIt.I<MasterDataService>();
  final _linkService = GetIt.I<AccountingLinkService>();

  List<Map<String, dynamic>> _allAccounts = [];
  Map<int?, List<Map<String, dynamic>>> _tree = {};
  Set<int> _expandedNodes = {};
  String _searchQuery = '';
  String? _filterType;
  int? _selectedAccountId;
  Map<String, dynamic>? _selectedAccount;

  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAccounts();
    // توسيع الحسابات الرئيسية تلقائياً
    Future.delayed(const Duration(milliseconds: 300), () {
      _expandMainAccounts();
    });
  }

  void _expandMainAccounts() {
    setState(() {
      for (var acc in _allAccounts) {
        if (acc['level'] == 1) {
          _expandedNodes.add(acc['id'] as int);
        }
      }
    });
  }

  Future<void> _loadAccounts() async {
    final accounts = await _dataService.getAllAccounts();
    setState(() {
      _allAccounts = accounts;
      _buildTree();
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
      children = children.where((c) =>
        (c['name_ar'] ?? '').toString().contains(_searchQuery) ||
        (c['number'] ?? '').toString().contains(_searchQuery)
      ).toList();
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

  String _getTypeName(String? type) {
    switch (type) {
      case 'asset': return 'أصل';
      case 'liability': return 'خصم';
      case 'expense': return 'مصروف';
      case 'revenue': return 'إيراد';
      default: return type ?? '-';
    }
  }

  void _selectAccount(Map<String, dynamic> account) {
    setState(() {
      _selectedAccountId = account['id'] as int;
      _selectedAccount = account;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('دليل الحسابات'),
        actions: [
          // زر المعالج الذكي
          IconButton(
            icon: const Icon(Icons.auto_fix_high),
            tooltip: 'معالج إنشاء حساب',
            onPressed: () => _showWizard(),
          ),
          // زر إضافة سريعة
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'إضافة حساب',
            onPressed: () => _showAddDialog(null),
          ),
          // فلترة
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            tooltip: 'فلترة',
            onSelected: (v) => setState(() => _filterType = v == 'all' ? null : v),
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'all', child: Text('الكل')),
              const PopupMenuItem(value: 'asset', child: Text('الأصول')),
              const PopupMenuItem(value: 'liability', child: Text('الخصوم')),
              const PopupMenuItem(value: 'expense', child: Text('المصروفات')),
              const PopupMenuItem(value: 'revenue', child: Text('الإيرادات')),
            ],
          ),
          // تحديث
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'تحديث',
            onPressed: _loadAccounts,
          ),
          // تصدير
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'تصدير',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('جاري التصدير...')));
            },
          ),
        ],
      ),
      body: Row(
        children: [
          // الشجرة
          Expanded(
            flex: 7,
            child: Column(
              children: [
                // شريط البحث مع إحصائيات سريعة
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: 'بحث سريع...',
                            prefixIcon: Icon(Icons.search),
                            isDense: true,
                          ),
                          onChanged: (v) => setState(() => _searchQuery = v),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('${_allAccounts.length} حساب', style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: _buildTreeWidgets(null, 0),
                  ),
                ),
              ],
            ),
          ),
          // لوحة التفاصيل
          if (_selectedAccount != null)
            Expanded(
              flex: 3,
              child: _buildDetailPanel(),
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
                setState(() {
                  if (isExpanded) {
                    _expandedNodes.remove(id);
                  } else {
                    _expandedNodes.add(id);
                  }
                });
              }
              _selectAccount(account);
            },
            child: Container(
              color: _selectedAccountId == id ? Colors.teal.withOpacity(0.1) : null,
              padding: EdgeInsets.only(right: 16.0 + depth * 24.0, left: 8, top: 6, bottom: 6),
              child: Row(
                children: [
                  Icon(
                    hasChildren
                        ? (isExpanded ? Icons.folder_open : Icons.folder)
                        : Icons.description,
                    color: _getColor(account['type']),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${account['number']} - ${account['name_ar'] ?? account['name_en'] ?? ''}',
                      style: TextStyle(fontWeight: FontWeight.bold, color: _getColor(account['type'])),
                    ),
                  ),
                  // وسوم صغيرة
                  if (account['is_system'] == true)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4)),
                      child: const Text('نظام', style: TextStyle(fontSize: 10)),
                    ),
                ],
              ),
            ),
          ),
          if (hasChildren && isExpanded)
            ..._buildTreeWidgets(id, depth + 1),
        ],
      );
    }).toList();
  }

  Widget _buildDetailPanel() {
    final acc = _selectedAccount!;
    return Container(
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey.shade300)),
      ),
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Text('تفاصيل الحساب', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _getColor(acc['type']))),
          const Divider(),
          _detailRow('رقم الحساب', acc['number']?.toString()),
          _detailRow('الاسم العربي', acc['name_ar']?.toString()),
          _detailRow('الاسم الإنجليزي', acc['name_en']?.toString()),
          _detailRow('النوع', _getTypeName(acc['type'])),
          _detailRow('الطبيعة', acc['nature'] == 'debit' ? 'مدين' : 'دائن'),
          _detailRow('المستوى', acc['level']?.toString()),
          _detailRow('الحالة', acc['is_active'] == true ? 'نشط' : 'موقوف'),
          _detailRow('يقبل الترحيل', acc['accepts_posting'] == true ? 'نعم' : 'لا'),
          const Divider(),
          const Text('العمليات', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _actionButton('إضافة فرعي', Icons.add, () => _showAddDialog(acc)),
              _actionButton('تعديل', Icons.edit, () {}),
              _actionButton('إيقاف', Icons.block, () {}),
              _actionButton('كشف حساب', Icons.receipt_long, () {}),
              _actionButton('الأستاذ', Icons.book, () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton(String label, IconData icon, VoidCallback onPressed) {
    return OutlinedButton.icon(
      icon: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      onPressed: onPressed,
    );
  }

  Widget _detailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // ========== معالج إنشاء الحساب الذكي ==========
  void _showWizard() {
    String? step1Type; // أصل، خصم، مصروف، إيراد
    String? step2Category; // عميل، مورد، بنك، صندوق، محفظة، صرافة، مصروف، إيراد، مخزن، آخر
    final nameCtrl = TextEditingController();
    bool acceptsPosting = true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.auto_fix_high, color: Colors.teal),
                SizedBox(width: 8),
                Text('معالج إنشاء حساب'),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // الخطوة 1: نوع الحساب
                  const Text('الخطوة 1: ما نوع الحساب؟', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'نوع الحساب'),
                    value: step1Type,
                    items: const [
                      DropdownMenuItem(value: 'asset', child: Text('أصل')),
                      DropdownMenuItem(value: 'liability', child: Text('خصم')),
                      DropdownMenuItem(value: 'expense', child: Text('مصروف')),
                      DropdownMenuItem(value: 'revenue', child: Text('إيراد')),
                    ],
                    onChanged: (v) => setDialogState(() {
                      step1Type = v;
                      step2Category = null;
                    }),
                  ),
                  const SizedBox(height: 16),

                  // الخطوة 2: تصنيف الحساب
                  if (step1Type != null) ...[
                    const Text('الخطوة 2: ما تصنيف الحساب؟', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'التصنيف'),
                      value: step2Category,
                      items: _getCategoryItems(step1Type!),
                      onChanged: (v) => setDialogState(() => step2Category = v),
                    ),
                  ],
                  const SizedBox(height: 16),

                  // الخطوة 3: الاسم
                  if (step2Category != null) ...[
                    const Text('الخطوة 3: ما اسم الحساب؟', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(labelText: 'الاسم'),
                    ),
                    const SizedBox(height: 8),
                    CheckboxListTile(
                      title: const Text('يقبل الترحيل'),
                      value: acceptsPosting,
                      onChanged: (v) => setDialogState(() => acceptsPosting = v!),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
              if (step2Category != null && nameCtrl.text.isNotEmpty)
                ElevatedButton(
                  onPressed: () async {
                    final parentSystemCode = _getParentSystemCode(step1Type!, step2Category!);
                    // هنا نستخدم AccountingLinkService لإنشاء الحساب
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('سيتم إنشاء الحساب تحت: $parentSystemCode باسم: ${nameCtrl.text}')),
                    );
                    Navigator.pop(ctx);
                    _loadAccounts();
                  },
                  child: const Text('إنشاء'),
                ),
            ],
          );
        },
      ),
    );
  }

  List<DropdownMenuItem<String>> _getCategoryItems(String type) {
    switch (type) {
      case 'asset':
        return const [
          DropdownMenuItem(value: 'customer', child: Text('عميل')),
          DropdownMenuItem(value: 'bank', child: Text('بنك')),
          DropdownMenuItem(value: 'cash_box', child: Text('صندوق')),
          DropdownMenuItem(value: 'wallet', child: Text('محفظة إلكترونية')),
          DropdownMenuItem(value: 'exchange', child: Text('شركة صرافة')),
          DropdownMenuItem(value: 'inventory', child: Text('مخزون')),
          DropdownMenuItem(value: 'fixed_asset', child: Text('أصل ثابت')),
          DropdownMenuItem(value: 'other_asset', child: Text('أصل آخر')),
        ];
      case 'liability':
        return const [
          DropdownMenuItem(value: 'supplier', child: Text('مورد')),
          DropdownMenuItem(value: 'loan', child: Text('قرض')),
          DropdownMenuItem(value: 'other_liability', child: Text('التزام آخر')),
        ];
      case 'expense':
        return const [
          DropdownMenuItem(value: 'salary', child: Text('رواتب')),
          DropdownMenuItem(value: 'rent', child: Text('إيجار')),
          DropdownMenuItem(value: 'electricity', child: Text('كهرباء')),
          DropdownMenuItem(value: 'water', child: Text('مياه')),
          DropdownMenuItem(value: 'phone', child: Text('اتصالات')),
          DropdownMenuItem(value: 'fuel', child: Text('وقود')),
          DropdownMenuItem(value: 'maintenance', child: Text('صيانة')),
          DropdownMenuItem(value: 'advertising', child: Text('دعاية وإعلان')),
          DropdownMenuItem(value: 'other_expense', child: Text('مصروف آخر')),
        ];
      case 'revenue':
        return const [
          DropdownMenuItem(value: 'sales', child: Text('مبيعات')),
          DropdownMenuItem(value: 'services', child: Text('خدمات')),
          DropdownMenuItem(value: 'other_revenue', child: Text('إيراد آخر')),
        ];
      default:
        return [];
    }
  }

  String _getParentSystemCode(String type, String category) {
    switch (category) {
      case 'customer': return 'customer_parent';
      case 'supplier': return 'supplier_parent';
      case 'bank': return 'bank_default';
      case 'cash_box': return 'cash_default';
      case 'wallet': return 'wallet_parent';
      case 'exchange': return 'exchange_parent';
      case 'inventory': return 'inventory_default';
      case 'sales': return 'sales_default';
      case 'other_expense': case 'salary': case 'rent': case 'electricity': case 'water': case 'phone': case 'fuel': case 'maintenance': case 'advertising': return 'expense_default';
      default: return 'cash_default';
    }
  }

  // ========== إضافة حساب يدوي ==========
  void _showAddDialog(Map<String, dynamic>? parent) {
    final nameArCtrl = TextEditingController();
    final nameEnCtrl = TextEditingController();
    String? selectedType = parent?['type'] ?? 'asset';
    String? selectedNature = parent?['nature'] ?? 'debit';
    bool acceptsPosting = true;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(parent != null ? 'إضافة حساب فرعي تحت ${parent['name_ar']}' : 'إضافة حساب جديد'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (parent == null)
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'نوع الحساب'),
                  value: selectedType,
                  items: const [
                    DropdownMenuItem(value: 'asset', child: Text('أصل')),
                    DropdownMenuItem(value: 'liability', child: Text('خصم')),
                    DropdownMenuItem(value: 'expense', child: Text('مصروف')),
                    DropdownMenuItem(value: 'revenue', child: Text('إيراد')),
                  ],
                  onChanged: (v) => setState(() => selectedType = v),
                ),
              const SizedBox(height: 8),
              TextFormField(controller: nameArCtrl, decoration: const InputDecoration(labelText: 'الاسم العربي')),
              const SizedBox(height: 8),
              TextFormField(controller: nameEnCtrl, decoration: const InputDecoration(labelText: 'الاسم الإنجليزي')),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'الطبيعة'),
                value: selectedNature,
                items: const [
                  DropdownMenuItem(value: 'debit', child: Text('مدين')),
                  DropdownMenuItem(value: 'credit', child: Text('دائن')),
                ],
                onChanged: (v) => setState(() => selectedNature = v),
              ),
              const SizedBox(height: 8),
              CheckboxListTile(
                title: const Text('يقبل الترحيل'),
                value: acceptsPosting,
                onChanged: (v) => setState(() => acceptsPosting = v!),
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _loadAccounts();
            },
            child: const Text('إنشاء'),
          ),
        ],
      ),
    );
  }
}
