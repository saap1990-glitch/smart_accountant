import 'package:flutter/material.dart';

class AdvancedSettingsScreen extends StatefulWidget {
  const AdvancedSettingsScreen({super.key});

  @override
  State<AdvancedSettingsScreen> createState() => _AdvancedSettingsScreenState();
}

class _AdvancedSettingsScreenState extends State<AdvancedSettingsScreen> {
  bool _sendWhatsApp = false;
  bool _voiceAssistant = true;
  bool _showGuideIcon = true;
  bool _showCurrency = true;
  bool _yearlyClose = false;
  bool _sortTotals = true;
  bool _preventNegativeSale = true;
  bool _showTotalOperations = true;
  bool _showOperationNumber = true;
  bool _darkMode = false;
  bool _debtAlert = true;
  double _fontSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('خيارات متقدمة')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // التواصل
          _section('التواصل والمشاركة'),
          SwitchListTile(
            secondary: const Icon(Icons.message, color: Colors.green),
            title: const Text('إرسال كشف الحساب عبر الواتساب'),
            subtitle: const Text('تواصل مباشر مع العميل'),
            value: _sendWhatsApp,
            onChanged: (v) => setState(() => _sendWhatsApp = v),
          ),

          _section('المساعد الذكي'),
          SwitchListTile(
            secondary: const Icon(Icons.mic, color: Colors.purple),
            title: const Text('استخدام المساعد الصوتي'),
            subtitle: const Text('تفعيل وضع الحساب الذكي الصوتي'),
            value: _voiceAssistant,
            onChanged: (v) => setState(() => _voiceAssistant = v),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.gps_fixed, color: Colors.purple),
            title: const Text('إظهار أيقونة الموجه'),
            subtitle: const Text('في الشاشة الرئيسية'),
            value: _showGuideIcon,
            onChanged: (v) => setState(() => _showGuideIcon = v),
          ),

          _section('العمليات المحاسبية'),
          SwitchListTile(
            secondary: const Icon(Icons.block, color: Colors.red),
            title: const Text('إيقاف البيع بالسالب'),
            subtitle: const Text('رقابة صارمة على المخزون'),
            value: _preventNegativeSale,
            onChanged: (v) => setState(() => _preventNegativeSale = v),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.calendar_month, color: Colors.teal),
            title: const Text('الإغلاق السنوي للحسابات'),
            value: _yearlyClose,
            onChanged: (v) => setState(() => _yearlyClose = v),
          ),

          _section('العرض'),
          SwitchListTile(
            secondary: const Icon(Icons.attach_money, color: Colors.teal),
            title: const Text('إظهار العملات'),
            value: _showCurrency,
            onChanged: (v) => setState(() => _showCurrency = v),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.format_list_numbered, color: Colors.teal),
            title: const Text('إظهار رقم العملية'),
            subtitle: const Text('تسلسل مقفل في شاشة الحساب'),
            value: _showOperationNumber,
            onChanged: (v) => setState(() => _showOperationNumber = v),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.functions, color: Colors.teal),
            title: const Text('إجمالي العمليات أسفل الحساب'),
            value: _showTotalOperations,
            onChanged: (v) => setState(() => _showTotalOperations = v),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.sort, color: Colors.teal),
            title: const Text('فرز إجمالي المبالغ'),
            value: _sortTotals,
            onChanged: (v) => setState(() => _sortTotals = v),
          ),

          _section('التنبيهات'),
          SwitchListTile(
            secondary: const Icon(Icons.warning, color: Colors.orange),
            title: const Text('تنبيه الديون'),
            subtitle: const Text('إشعار عند وجود ديون مستحقة'),
            value: _debtAlert,
            onChanged: (v) => setState(() => _debtAlert = v),
          ),

          _section('المظهر'),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode, color: Colors.indigo),
            title: const Text('الوضع الليلي'),
            value: _darkMode,
            onChanged: (v) => setState(() => _darkMode = v),
          ),
          ListTile(
            leading: const Icon(Icons.format_size, color: Colors.indigo),
            title: const Text('حجم الخط'),
            subtitle: Text('${_fontSize.toInt()}'),
            trailing: SizedBox(
              width: 150,
              child: Slider(
                value: _fontSize,
                min: 12,
                max: 24,
                onChanged: (v) => setState(() => _fontSize = v),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.save),
            label: const Text('حفظ جميع الإعدادات'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم حفظ الإعدادات ✅')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 4),
      child: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.teal)),
    );
  }
}
