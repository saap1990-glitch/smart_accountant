import 'package:flutter/material.dart';

class PrintSettingsScreen extends StatefulWidget {
  const PrintSettingsScreen({super.key});

  @override
  State<PrintSettingsScreen> createState() => _PrintSettingsScreenState();
}

class _PrintSettingsScreenState extends State<PrintSettingsScreen> {
  bool _showData = true;
  bool _showDate = true;
  bool _showSummary = false;
  bool _showBalance = true;
  bool _showDebit = true;
  bool _showCredit = true;
  final _headerCtrl = TextEditingController();
  final _footerCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('خيارات الطباعة')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('إظهار البيانات'),
            subtitle: const Text('اسم الشركة والعنوان'),
            value: _showData,
            onChanged: (v) => setState(() => _showData = v),
          ),
          SwitchListTile(
            title: const Text('إظهار التاريخ'),
            value: _showDate,
            onChanged: (v) => setState(() => _showDate = v),
          ),
          SwitchListTile(
            title: const Text('طباعة البيانات المختصرة'),
            value: _showSummary,
            onChanged: (v) => setState(() => _showSummary = v),
          ),
          SwitchListTile(
            title: const Text('طباعة الرصيد المتبقي'),
            value: _showBalance,
            onChanged: (v) => setState(() => _showBalance = v),
          ),
          SwitchListTile(
            title: const Text('🔻 إظهار المدين'),
            value: _showDebit,
            onChanged: (v) => setState(() => _showDebit = v),
          ),
          SwitchListTile(
            title: const Text('🔺 إظهار الدائن'),
            value: _showCredit,
            onChanged: (v) => setState(() => _showCredit = v),
          ),
          const Divider(),
          const Text(
            'ترويسة وتذييل',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _headerCtrl,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'الترويسة (أعلى الصفحة)',
              hintText: 'مثال: شركة النجاح التجارية - صنعاء',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _footerCtrl,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'التذييل (أسفل الصفحة)',
              hintText: 'مثال: شكراً لتعاملكم معنا',
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.save),
            label: const Text('حفظ الإعدادات'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم حفظ إعدادات الطباعة ✅')),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _headerCtrl.dispose();
    _footerCtrl.dispose();
    super.dispose();
  }
}
