import 'package:flutter/material.dart';

import '../../core/di/service_locator.dart';
import '../../core/services/master_data/master_data_service.dart';

class AccountDetailScreen extends StatefulWidget {
  final Map<String, dynamic>? account;

  const AccountDetailScreen({super.key, this.account});

  @override
  State<AccountDetailScreen> createState() => _AccountDetailScreenState();
}

class _AccountDetailScreenState extends State<AccountDetailScreen> {
  final MasterDataService _service = sl<MasterDataService>();

  final _formKey = GlobalKey<FormState>();

  final _nameAr = TextEditingController();
  final _nameEn = TextEditingController();
  final _notes = TextEditingController();
  final _openingBalance = TextEditingController(text: '0');

  List<Map<String, dynamic>> _accounts = [];

  int? _parentId;
  String _nature = 'debit';
  String _currency = 'YER';
  String _openingNature = 'debit';

  bool _acceptsPosting = false;
  bool _active = true;
  bool _loading = true;
  bool _saving = false;

  bool get _editing => widget.account != null;

  int get _level {
    if (_parentId == null) return 1;

    final parent = _accounts.cast<Map<String, dynamic>?>().firstWhere(
      (a) => a?['id'] == _parentId,
      orElse: () => null,
    );

    if (parent == null) return 1;

    return (int.tryParse('${parent['level']}') ?? 0) + 1;
  }

  String get _type {
    if (_parentId == null) {
      return widget.account?['type']?.toString() ?? 'asset';
    }

    final parent = _accounts.cast<Map<String, dynamic>?>().firstWhere(
      (a) => a?['id'] == _parentId,
      orElse: () => null,
    );

    return parent?['type']?.toString() ?? 'asset';
  }

  Map<String, dynamic>? get _selectedParent {
    if (_parentId == null) return null;

    return _accounts.cast<Map<String, dynamic>?>().firstWhere(
      (a) => a?['id'] == _parentId,
      orElse: () => null,
    );
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _nameAr.dispose();
    _nameEn.dispose();
    _notes.dispose();
    _openingBalance.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final accounts = await _service.getAllAccounts();

      if (!mounted) return;

      setState(() {
        _accounts = accounts;

        if (_editing) {
          final a = widget.account!;

          _nameAr.text = '${a['name_ar'] ?? ''}';
          _nameEn.text = '${a['name_en'] ?? ''}';
          _notes.text = '${a['notes'] ?? ''}';

          _parentId = a['parent_id'] as int?;

          _nature = '${a['nature'] ?? 'debit'}';
          _currency = '${a['currency_code'] ?? 'YER'}';
          _openingNature = '${a['opening_balance_nature'] ?? 'debit'}';

          _acceptsPosting = a['accepts_posting'] == true;
          _active = a['is_active'] != false;

          _openingBalance.text = '${a['opening_balance'] ?? '0'}';
        }

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

  List<Map<String, dynamic>> get _parentOptions {
    return _accounts.where((a) {
      final level = int.tryParse('${a['level']}') ?? 0;
      final active = a['is_active'] != false;

      if (!active) return false;
      if (level >= 5) return false;

      if (_editing && a['id'] == widget.account!['id']) {
        return false;
      }

      return true;
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

  String _parentTitle(Map<String, dynamic> account) {
    return '${account['number'] ?? ''} - '
        '${account['name_ar'] ?? ''}';
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'اسم الحساب مطلوب';
    }

    return null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_editing && _level > 5) {
      _showError('لا يمكن إنشاء مستوى يتجاوز المستوى الخامس');
      return;
    }

    if (!_editing && _level > 1 && _parentId == null) {
      _showError('يجب اختيار الحساب الأب');
      return;
    }

    if (_level < 5 && _acceptsPosting) {
      _showError('الحسابات من المستوى الأول إلى الرابع حسابات تجميعية');
      return;
    }

    final balance = double.tryParse(_openingBalance.text.trim()) ?? 0;

    if (balance < 0) {
      _showError('الرصيد الافتتاحي لا يمكن أن يكون سالبًا');
      return;
    }

    setState(() => _saving = true);

    try {
      if (_editing) {
        await _service.updateAccount(
          widget.account!['id'] as int,
          nameAr: _nameAr.text.trim(),
          nameEn: _nameEn.text.trim().isEmpty ? null : _nameEn.text.trim(),
          isActive: _active,
          currencyCode: _currency,
          notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
          openingBalance: balance,
          openingBalanceNature: _openingNature,
        );
      } else {
        await _service.createAccount(
          nameAr: _nameAr.text.trim(),
          nameEn: _nameEn.text.trim().isEmpty ? null : _nameEn.text.trim(),
          type: _type,
          nature: _nature,
          parentId: _parentId,
          isActive: _active,
          currencyCode: _currency,
          notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
          openingBalance: balance,
          openingBalanceNature: _openingNature,
        );
      }

      if (!mounted) return;

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      _showError(e.toString());
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text(_editing ? 'تعديل الحساب' : 'إضافة حساب')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildHierarchyCard(),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameAr,
              validator: _validateName,
              decoration: const InputDecoration(
                labelText: 'اسم الحساب بالعربي *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameEn,
              decoration: const InputDecoration(
                labelText: 'اسم الحساب بالإنجليزية',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            _buildAccountInfo(),
            const SizedBox(height: 16),
            _buildPostingCard(),
            const SizedBox(height: 16),
            _buildBalanceCard(),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notes,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'ملاحظات',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(_editing ? 'حفظ التعديلات' : 'إنشاء الحساب'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHierarchyCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'التسلسل المحاسبي',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            if (!_editing)
              DropdownButtonFormField<int?>(
                value: _parentId,
                decoration: const InputDecoration(
                  labelText: 'الحساب الأب',
                  border: OutlineInputBorder(),
                ),
                items: [
                  const DropdownMenuItem<int?>(
                    child: Text('حساب رئيسي - المستوى الأول'),
                  ),
                  ..._parentOptions.map(
                    (a) => DropdownMenuItem<int?>(
                      value: a['id'] as int,
                      child: Text(_parentTitle(a)),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _parentId = value;

                    if (_level < 5) {
                      _acceptsPosting = false;
                    }
                  });
                },
              )
            else
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('الحساب الأب'),
                subtitle: Text(
                  _selectedParent == null
                      ? 'حساب رئيسي'
                      : _parentTitle(_selectedParent!),
                ),
              ),
            const SizedBox(height: 12),
            _infoRow('المستوى', '$_level من 5'),
            _infoRow('نوع الحساب', _typeName(_type)),
            if (_editing)
              _infoRow('رقم الحساب', '${widget.account!['number'] ?? ''}'),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _nature,
              decoration: const InputDecoration(
                labelText: 'طبيعة الحساب',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'debit', child: Text('مدين')),
                DropdownMenuItem(value: 'credit', child: Text('دائن')),
              ],
              onChanged: _editing
                  ? null
                  : (value) {
                      if (value != null) {
                        setState(() => _nature = value);
                      }
                    },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _currency,
              decoration: const InputDecoration(
                labelText: 'العملة',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'YER', child: Text('ريال يمني YER')),
                DropdownMenuItem(value: 'SAR', child: Text('ريال سعودي SAR')),
                DropdownMenuItem(value: 'USD', child: Text('دولار أمريكي USD')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _currency = value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostingCard() {
    final canPost = _level == 5;

    return Card(
      child: SwitchListTile(
        title: const Text('حساب قابل للترحيل'),
        subtitle: Text(
          canPost
              ? 'يسمح بتسجيل القيود مباشرة على هذا الحساب'
              : 'الحسابات قبل المستوى الخامس تجميعية ولا تستقبل قيودًا',
        ),
        value: canPost && _acceptsPosting,
        onChanged: canPost
            ? (value) {
                setState(() => _acceptsPosting = value);
              }
            : null,
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _openingBalance,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'الرصيد الافتتاحي',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _openingNature,
              decoration: const InputDecoration(
                labelText: 'طبيعة الرصيد الافتتاحي',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'debit', child: Text('مدين')),
                DropdownMenuItem(value: 'credit', child: Text('دائن')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _openingNature = value);
                }
              },
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('الحساب نشط'),
              value: _active,
              onChanged: (value) {
                setState(() => _active = value);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text('$title: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
