import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../core/services/master_data/master_data_service.dart';

class AccountDetailScreen extends StatefulWidget {
  final Map<String, dynamic> account;
  const AccountDetailScreen({super.key, required this.account});

  @override
  State<AccountDetailScreen> createState() => _AccountDetailScreenState();
}

class _AccountDetailScreenState extends State<AccountDetailScreen> {
  final _dataService = GetIt.I<MasterDataService>();

  Color get _color {
    switch (widget.account['type']) {
      case 'asset': return Colors.green;
      case 'liability': return Colors.red;
      case 'expense': return Colors.orange;
      case 'revenue': return Colors.blue;
      default: return Colors.grey;
    }
  }

  String get _typeName {
    switch (widget.account['type']) {
      case 'asset': return 'أصل';
      case 'liability': return 'خصم';
      case 'expense': return 'مصروف';
      case 'revenue': return 'إيراد';
      default: return widget.account['type'] ?? '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    final acc = widget.account;
    return Scaffold(
      appBar: AppBar(
        title: Text(acc['name_ar'] ?? acc['name_en'] ?? 'تفاصيل الحساب'),
        actions: [
          IconButton(icon: const Icon(Icons.edit), tooltip: 'تعديل', onPressed: () => _showEditDialog()),
          IconButton(icon: const Icon(Icons.add), tooltip: 'إضافة حساب فرعي', onPressed: () => _showAddChildDialog()),
          IconButton(icon: const Icon(Icons.print), tooltip: 'طباعة', onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // بطاقة اللون والنوع
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [_color.withOpacity(0.8), _color]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(_getIcon(acc['type']), size: 50, color: Colors.white),
                const SizedBox(height: 8),
                Text(acc['name_ar'] ?? acc['name_en'] ?? '', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                Text('${acc['number']} - $_typeName', style: const TextStyle(fontSize: 16, color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // البيانات الأساسية
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('البيانات الأساسية', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Divider(),
                  _row('رقم الحساب', acc['number']?.toString()),
                  _row('الاسم العربي', acc['name_ar']?.toString()),
                  _row('الاسم الإنجليزي', acc['name_en']?.toString()),
                  _row('النوع', _typeName),
                  _row('الطبيعة', acc['nature'] == 'debit' ? 'مدين 🔻' : 'دائن 🔺'),
                  _row('المستوى', acc['level']?.toString()),
                  _row('الحالة', acc['is_active'] == true ? 'نشط ✅' : 'موقوف ⛔'),
                  _row('يقبل الترحيل', acc['accepts_posting'] == true ? 'نعم ✅' : 'لا ❌'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // البيانات المحاسبية
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('البيانات المحاسبية', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Divider(),
                  _row('الرصيد الافتتاحي', '0'),
                  _row('إجمالي المدين', '0'),
                  _row('إجمالي الدائن', '0'),
                  _row('الرصيد الحالي', '0'),
                  _row('عدد القيود', '0'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // أزرار التحكم
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('إضافة فرعي'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                  onPressed: () => _showAddChildDialog(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text('تعديل'),
                  onPressed: () => _showEditDialog(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.receipt_long),
                  label: const Text('كشف حساب'),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.book),
                  label: const Text('الأستاذ العام'),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            icon: const Icon(Icons.block, color: Colors.red),
            label: const Text('إيقاف الحساب'),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  IconData _getIcon(String? type) {
    switch (type) {
      case 'asset': return Icons.account_balance;
      case 'liability': return Icons.money_off;
      case 'expense': return Icons.money;
      case 'revenue': return Icons.trending_up;
      default: return Icons.account_balance;
    }
  }

  Widget _row(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(value ?? '-', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        ],
      ),
    );
  }

  void _showEditDialog() {
    final nameArCtrl = TextEditingController(text: widget.account['name_ar']);
    final nameEnCtrl = TextEditingController(text: widget.account['name_en']);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تعديل الحساب'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameArCtrl, decoration: const InputDecoration(labelText: 'الاسم العربي')),
            const SizedBox(height: 8),
            TextField(controller: nameEnCtrl, decoration: const InputDecoration(labelText: 'الاسم الإنجليزي')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () async {
              await _dataService.updateAccount(widget.account['id'] as int, nameAr: nameArCtrl.text, nameEn: nameEnCtrl.text.isEmpty ? null : nameEnCtrl.text);
              Navigator.pop(ctx);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ تم التعديل')));
                Navigator.pop(context);
              }
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  void _showAddChildDialog() {
    final nameArCtrl = TextEditingController();
    final nameEnCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('إضافة حساب فرعي تحت ${widget.account['name_ar']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameArCtrl, decoration: const InputDecoration(labelText: 'الاسم العربي *')),
            const SizedBox(height: 8),
            TextField(controller: nameEnCtrl, decoration: const InputDecoration(labelText: 'الاسم الإنجليزي')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () async {
              if (nameArCtrl.text.trim().isEmpty) return;
              final childrenCount = 0;
              final nextNumber = '${widget.account['number']}${(childrenCount + 1).toString().padLeft(2, '0')}';
              await _dataService.createAccount(
                number: nextNumber,
                nameAr: nameArCtrl.text,
                nameEn: nameEnCtrl.text.isEmpty ? null : nameEnCtrl.text,
                type: widget.account['type'] as String,
                nature: widget.account['nature'] as String,
                parentId: widget.account['id'] as int,
                level: (widget.account['level'] as int) + 1,
              );
              Navigator.pop(ctx);
              if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ تمت الإضافة')));
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }
}
