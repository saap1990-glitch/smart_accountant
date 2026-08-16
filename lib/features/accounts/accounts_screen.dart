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
  final _ledger = GetIt.I<LedgerRepository>();

  List<Map<String, dynamic>> _accounts = [];
  Map<int, double> _balances = {};
  final Set<int> _expanded = <int>{};

  String _search = '';
  String? _typeFilter;
  int? _levelFilter;
  bool? _activeFilter;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (mounted) setState(() => _loading = true);

    final accounts = await _service.getAllAccounts();
    final balances = <int, double>{};

    for (final account in accounts) {
      final id = account['id'];
      if (id is int) {
        try {
          balances[id] = await _ledger.getBalance(id);
        } catch (_) {
          balances[id] = 0;
        }
      }
    }

    if (!mounted) return;

    setState(() {
      _accounts = accounts;
      _balances = balances;
      _loading = false;

      for (final account in accounts) {
        final id = account['id'];
        if (account['level'] == 1 && id is int) {
          _expanded.add(id);
        }
      }
    });
  }

  List<Map<String, dynamic>> get _visibleAccounts {
    var result = List<Map<String, dynamic>>.from(_accounts);

    if (_typeFilter != null) {
      result = result
          .where((a) => a['type']?.toString() == _typeFilter)
          .toList();
    }

    if (_levelFilter != null) {
      result = result.where((a) => a['level'] == _levelFilter).toList();
    }

    if (_activeFilter != null) {
      result = result
          .where((a) => (a['is_active'] ?? true) == _activeFilter)
          .toList();
    }

    if (_search.trim().isNotEmpty) {
      final q = _search.trim().toLowerCase();

      result = result.where((a) {
        final number = a['number']?.toString().toLowerCase() ?? '';
        final ar = a['name_ar']?.toString().toLowerCase() ?? '';
        final en = a['name_en']?.toString().toLowerCase() ?? '';

        return number.contains(q) || ar.contains(q) || en.contains(q);
      }).toList();
    }

    return result;
  }

  List<Map<String, dynamic>> _children(int? parentId) {
    final source = _visibleAccounts
        .where((a) => a['parent_id'] == parentId)
        .toList();

    source.sort(
      (a, b) => (a['number']?.toString() ?? '').compareTo(
        b['number']?.toString() ?? '',
      ),
    );

    return source;
  }

  bool _hasChildren(int id) {
    return _accounts.any((a) => a['parent_id'] == id);
  }

  Color _typeColor(String? type) {
    switch (type) {
      case 'asset':
        return Colors.green;
      case 'liability':
        return Colors.red;
      case 'expense':
        return Colors.orange;
      case 'revenue':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _typeName(String? type) {
    switch (type) {
      case 'asset':
        return 'أصول';
      case 'liability':
        return 'خصوم';
      case 'expense':
        return 'مصروفات';
      case 'revenue':
        return 'إيرادات';
      default:
        return 'حساب';
    }
  }

  String _formatBalance(double value) {
    return value.toStringAsFixed(2);
  }

  Future<String?> _nextAccountNumber(Map<String, dynamic> parent) async {
    final parentNumber = parent['number']?.toString() ?? '';
    final level = (parent['level'] as int? ?? 0) + 1;

    if (level > 5) {
      return null;
    }

    final children = _accounts.where((a) => a['parent_id'] == parent['id']);

    var maxSuffix = 0;

    for (final child in children) {
      final number = child['number']?.toString() ?? '';

      if (!number.startsWith(parentNumber)) {
        continue;
      }

      final suffix = number.substring(parentNumber.length);

      if (suffix.length != 2) {
        continue;
      }

      final value = int.tryParse(suffix);

      if (value != null && value > maxSuffix) {
        maxSuffix = value;
      }
    }

    final next = maxSuffix + 1;

    if (next > 99) {
      throw StateError('لا يمكن إضافة أكثر من 99 حسابًا تحت نفس الأب');
    }

    return '$parentNumber${next.toString().padLeft(2, '0')}';
  }

  Future<void> _showAddRoot() async {
    await _showAccountForm();
  }

  Future<void> _showAddChild(Map<String, dynamic> parent) async {
    final level = parent['level'] as int? ?? 0;

    if (level >= 5) {
      _message('لا يمكن إضافة مستوى بعد المستوى الخامس');
      return;
    }

    await _showAccountForm(parent: parent);
  }

  Future<void> _showAccountForm({
    Map<String, dynamic>? parent,
    Map<String, dynamic>? existing,
  }) async {
    final nameAr = TextEditingController(
      text: existing?['name_ar']?.toString() ?? '',
    );

    final nameEn = TextEditingController(
      text: existing?['name_en']?.toString() ?? '',
    );

    final notes = TextEditingController(
      text: existing?['notes']?.toString() ?? '',
    );

    var acceptsPosting =
        existing?['accepts_posting'] == true ||
        ((existing?['level'] as int? ?? 1) >= 4);

    var active = existing?['is_active'] != false;

    final isEdit = existing != null;

    String type =
        existing?['type']?.toString() ?? parent?['type']?.toString() ?? 'asset';

    String nature =
        existing?['nature']?.toString() ??
        parent?['nature']?.toString() ??
        'debit';

    final level = isEdit
        ? existing!['level'] as int
        : (parent?['level'] as int? ?? 0) + 1;

    String currency = existing?['currency_code']?.toString() ?? 'YER';

    String? generatedNumber;

    if (!isEdit && parent == null && level == 1) {
      generatedNumber = await _nextRootNumber();
    } else if (!isEdit && parent != null) {
      generatedNumber = await _nextAccountNumber(parent);
    }

    if (!mounted) return;

    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              title: Text(
                isEdit
                    ? 'تعديل الحساب'
                    : parent == null
                    ? 'إضافة حساب رئيسي'
                    : 'إضافة حساب فرعي',
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isEdit)
                      ListTile(
                        leading: const Icon(Icons.numbers),
                        title: const Text('الرقم'),
                        subtitle: Text(
                          generatedNumber ?? 'سيتم توليده تلقائيًا',
                        ),
                      ),
                    if (parent != null)
                      ListTile(
                        leading: const Icon(Icons.account_tree),
                        title: const Text('الحساب الأب'),
                        subtitle: Text(
                          '${parent['number']} - ${parent['name_ar']}',
                        ),
                      ),
                    ListTile(
                      title: Text('المستوى $level'),
                      subtitle: Text(_typeName(type)),
                    ),
                    TextField(
                      controller: nameAr,
                      autofocus: true,
                      decoration: const InputDecoration(
                        labelText: 'اسم الحساب بالعربي *',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: nameEn,
                      decoration: const InputDecoration(
                        labelText: 'اسم الحساب بالإنجليزي',
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (!isEdit)
                      DropdownButtonFormField<String>(
                        value: type,
                        decoration: const InputDecoration(
                          labelText: 'نوع الحساب',
                        ),
                        items: const [
                          DropdownMenuItem(value: 'asset', child: Text('أصول')),
                          DropdownMenuItem(
                            value: 'liability',
                            child: Text('خصوم'),
                          ),
                          DropdownMenuItem(
                            value: 'expense',
                            child: Text('مصروفات'),
                          ),
                          DropdownMenuItem(
                            value: 'revenue',
                            child: Text('إيرادات'),
                          ),
                        ],
                        onChanged: parent != null
                            ? null
                            : (v) {
                                if (v != null) {
                                  setDialogState(() => type = v);
                                  setDialogState(
                                    () =>
                                        nature = v == 'asset' || v == 'expense'
                                        ? 'debit'
                                        : 'credit',
                                  );
                                }
                              },
                      ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: currency,
                      decoration: const InputDecoration(labelText: 'العملة'),
                      items: const [
                        DropdownMenuItem(
                          value: 'YER',
                          child: Text('ريال يمني YER'),
                        ),
                        DropdownMenuItem(
                          value: 'SAR',
                          child: Text('ريال سعودي SAR'),
                        ),
                        DropdownMenuItem(
                          value: 'USD',
                          child: Text('دولار أمريكي USD'),
                        ),
                      ],
                      onChanged: (v) {
                        if (v != null) {
                          setDialogState(() => currency = v);
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('حساب قابل للترحيل'),
                      subtitle: Text(
                        level >= 4
                            ? 'مسموح عادة في المستويات التفصيلية'
                            : 'الحسابات التجميعية يفضل ألا تستقبل قيودًا',
                      ),
                      value: acceptsPosting,
                      onChanged: (v) {
                        if (v && level < 4) {
                          _message(
                            'لا يفضل جعل الحساب التجميعي قابلًا للترحيل قبل المستوى الرابع',
                          );
                        }
                        setDialogState(() => acceptsPosting = v);
                      },
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('الحساب نشط'),
                      value: active,
                      onChanged: (v) {
                        setDialogState(() => active = v);
                      },
                    ),
                    TextField(
                      controller: notes,
                      maxLines: 2,
                      decoration: const InputDecoration(labelText: 'ملاحظات'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('إلغاء'),
                ),
                FilledButton.icon(
                  icon: const Icon(Icons.save),
                  label: Text(isEdit ? 'حفظ' : 'إنشاء'),
                  onPressed: () async {
                    final ar = nameAr.text.trim();

                    if (ar.isEmpty) {
                      _message('اسم الحساب مطلوب');
                      return;
                    }

                    try {
                      if (isEdit) {
                        await _service.updateAccount(
                          existing!['id'] as int,
                          nameAr: ar,
                          nameEn: nameEn.text.trim().isEmpty
                              ? null
                              : nameEn.text.trim(),
                          acceptsPosting: acceptsPosting,
                          isActive: active,
                          currencyCode: currency,
                          notes: notes.text.trim().isEmpty
                              ? null
                              : notes.text.trim(),
                        );
                      } else {
                        final number = generatedNumber;

                        if (number == null) {
                          throw StateError('تعذر توليد رقم الحساب تلقائيًا');
                        }

                        await _service.createAccount(
                          number: number,
                          nameAr: ar,
                          nameEn: nameEn.text.trim().isEmpty
                              ? null
                              : nameEn.text.trim(),
                          type: type,
                          nature: nature,
                          parentId: parent?['id'] as int?,
                          level: level,
                          acceptsPosting: acceptsPosting,
                          isActive: active,
                          currencyCode: currency,
                          notes: notes.text.trim().isEmpty
                              ? null
                              : notes.text.trim(),
                        );
                      }

                      if (ctx.mounted) Navigator.pop(ctx);
                      await _load();

                      if (mounted) {
                        _message(
                          isEdit
                              ? 'تم تحديث الحساب بنجاح'
                              : 'تم إنشاء الحساب بنجاح',
                        );
                      }
                    } catch (e) {
                      if (ctx.mounted) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          SnackBar(content: Text('تعذر حفظ الحساب: $e')),
                        );
                      }
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );

    nameAr.dispose();
    nameEn.dispose();
    notes.dispose();
  }

  Future<String?> _nextRootNumber() async {
    final roots = _accounts.where((a) => a['parent_id'] == null);

    var max = 0;

    for (final root in roots) {
      final number = int.tryParse(root['number']?.toString() ?? '');
      if (number != null && number > max) {
        max = number;
      }
    }

    final next = max + 1;

    if (next > 4) {
      return next.toString();
    }

    return next.toString();
  }

  void _message(String text) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _toggleActive(Map<String, dynamic> account) async {
    if (account['is_system'] == true) {
      _message('الحساب النظامي لا يمكن تعطيله من هنا');
      return;
    }

    final id = account['id'] as int;
    final active = account['is_active'] != false;

    await _service.updateAccount(
      id,
      nameAr: account['name_ar']?.toString() ?? '',
      nameEn: account['name_en']?.toString(),
      isActive: !active,
    );

    await _load();
  }

  Future<void> _deleteAccount(Map<String, dynamic> account) async {
    final id = account['id'] as int;

    if (account['is_system'] == true) {
      _message('لا يمكن حذف حساب نظامي');
      return;
    }

    if (_hasChildren(id)) {
      _message('لا يمكن حذف حساب يحتوي على حسابات فرعية');
      return;
    }

    final balance = _balances[id] ?? 0;

    if (balance.abs() > 0.001) {
      _message('لا يمكن حذف حساب له رصيد محاسبي');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف الحساب'),
        content: Text('هل تريد حذف الحساب "${account['name_ar']}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _service.deleteAccount(id);
      await _load();
      _message('تم حذف الحساب');
    } catch (e) {
      _message('تعذر حذف الحساب: $e');
    }
  }

  Widget _accountTile(Map<String, dynamic> account) {
    final id = account['id'] as int;
    final children = _children(id);
    final hasChildren = children.isNotEmpty;
    final expanded = _expanded.contains(id);
    final color = _typeColor(account['type']?.toString());
    final balance = _balances[id] ?? 0;
    final openingBalance =
        double.tryParse(account['opening_balance']?.toString() ?? '0') ?? 0;
    final openingNature =
        account['opening_balance_nature']?.toString() ?? 'debit';
    final active = account['is_active'] != false;
    final posting = account['accepts_posting'] == true;

    return Column(
      children: [
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          child: ListTile(
            dense: true,
            leading: CircleAvatar(
              backgroundColor: color.withOpacity(0.12),
              child: Text(
                '${account['level']}',
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
            ),
            title: Row(
              children: [
                if (hasChildren)
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_left,
                    size: 20,
                  ),
                Expanded(
                  child: Text(
                    '${account['number']}  ${account['name_ar']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: active ? null : Colors.grey,
                    ),
                  ),
                ),
                if (posting)
                  const Icon(Icons.edit_note, size: 18, color: Colors.green),
              ],
            ),
            subtitle: Text(
              '${_typeName(account['type']?.toString())} • '
              'الرصيد: ${_formatBalance(balance)} '
              '${account['currency_code'] ?? 'YER'}'
              ' • افتتاحي: ${_formatBalance(openingBalance)} '
              '${openingNature == 'debit' ? 'مدين' : 'دائن'}'
              '${active ? '' : ' • موقوف'}',
            ),
            onTap: () {
              if (hasChildren) {
                setState(() {
                  if (expanded) {
                    _expanded.remove(id);
                  } else {
                    _expanded.add(id);
                  }
                });
              }
            },
            onLongPress: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AccountDetailScreen(account: account),
              ),
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) async {
                switch (value) {
                  case 'add':
                    await _showAddChild(account);
                    break;
                  case 'edit':
                    await _showAccountForm(existing: account);
                    break;
                  case 'active':
                    await _toggleActive(account);
                    break;
                  case 'delete':
                    await _deleteAccount(account);
                    break;
                }
              },
              itemBuilder: (_) => [
                if ((account['level'] as int? ?? 5) < 5)
                  const PopupMenuItem(
                    value: 'add',
                    child: Text('إضافة حساب فرعي'),
                  ),
                const PopupMenuItem(value: 'edit', child: Text('تعديل')),
                const PopupMenuItem(
                  value: 'active',
                  child: Text('تفعيل / إيقاف'),
                ),
                if (account['is_system'] != true)
                  const PopupMenuItem(value: 'delete', child: Text('حذف')),
              ],
            ),
          ),
        ),
        if (expanded)
          ...children.map(
            (child) => Padding(
              padding: EdgeInsets.only(
                right: 18.0 * ((child['level'] as int? ?? 1) - 1),
              ),
              child: _accountTile(child),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final roots = _children(null);

    return Scaffold(
      appBar: AppBar(
        title: const Text('دليل الحسابات'),
        actions: [
          IconButton(
            tooltip: 'توسيع الكل',
            icon: const Icon(Icons.unfold_more),
            onPressed: () {
              setState(() {
                _expanded.addAll(
                  _accounts
                      .where((a) => _hasChildren(a['id'] as int))
                      .map((a) => a['id'] as int),
                );
              });
            },
          ),
          IconButton(
            tooltip: 'تحديث',
            icon: const Icon(Icons.refresh),
            onPressed: _load,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddRoot,
        icon: const Icon(Icons.add),
        label: const Text('حساب رئيسي'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 4),
                  child: TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'ابحث بالرقم أو اسم الحساب...',
                    ),
                    onChanged: (value) {
                      setState(() => _search = value);
                    },
                  ),
                ),
                SizedBox(
                  height: 48,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    children: [
                      _filterChip(
                        label: 'الكل',
                        selected: _typeFilter == null,
                        onSelected: () {
                          setState(() => _typeFilter = null);
                        },
                      ),
                      _filterChip(
                        label: 'الأصول',
                        selected: _typeFilter == 'asset',
                        onSelected: () {
                          setState(() => _typeFilter = 'asset');
                        },
                      ),
                      _filterChip(
                        label: 'الخصوم',
                        selected: _typeFilter == 'liability',
                        onSelected: () {
                          setState(() => _typeFilter = 'liability');
                        },
                      ),
                      _filterChip(
                        label: 'المصروفات',
                        selected: _typeFilter == 'expense',
                        onSelected: () {
                          setState(() => _typeFilter = 'expense');
                        },
                      ),
                      _filterChip(
                        label: 'الإيرادات',
                        selected: _typeFilter == 'revenue',
                        onSelected: () {
                          setState(() => _typeFilter = 'revenue');
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: roots.isEmpty
                      ? const Center(child: Text('لا توجد حسابات مطابقة'))
                      : RefreshIndicator(
                          onRefresh: _load,
                          child: ListView(
                            padding: const EdgeInsets.only(bottom: 90),
                            children: roots.map(_accountTile).toList(),
                          ),
                        ),
                ),
              ],
            ),
    );
  }

  Widget _filterChip({
    required String label,
    required bool selected,
    required VoidCallback onSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onSelected(),
      ),
    );
  }
}
