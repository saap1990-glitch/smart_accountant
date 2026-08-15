import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AdvancedSettingsScreen extends StatefulWidget {
  const AdvancedSettingsScreen({super.key});

  @override
  State<AdvancedSettingsScreen> createState() => _AdvancedSettingsScreenState();
}

class _AdvancedSettingsScreenState extends State<AdvancedSettingsScreen> {
  final _storage = const FlutterSecureStorage();

  bool _sendWhatsApp = false;
  bool _voiceAssistant = true;
  bool _showCurrency = true;
  bool _yearlyClose = false;
  bool _preventNegativeSale = true;
  bool _showOperationNumber = true;
  bool _debtAlert = true;
  bool _darkMode = false;
  bool _showTotalOperations = true;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    _sendWhatsApp = await _storage.read(key: 'send_whatsapp') == 'true';
    _voiceAssistant = await _storage.read(key: 'voice_assistant') != 'false';
    _showCurrency = await _storage.read(key: 'show_currency') != 'false';
    _yearlyClose = await _storage.read(key: 'yearly_close') == 'true';
    _preventNegativeSale = await _storage.read(key: 'prevent_negative') != 'false';
    _showOperationNumber = await _storage.read(key: 'show_op_number') != 'false';
    _debtAlert = await _storage.read(key: 'debt_alert') != 'false';
    _darkMode = await _storage.read(key: 'dark_mode') == 'true';
    _showTotalOperations = await _storage.read(key: 'show_totals') != 'false';
    if (mounted) setState(() {});
  }

  Future<void> _save(String key, bool value) async {
    await _storage.write(key: key, value: value.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الخيارات المتقدمة')),
      body: ListView(
        children: [
          _section('التواصل'),
          _sw('إرسال كشف الحساب عبر الواتساب', 'مشاركة مباشرة مع العميل', _sendWhatsApp, (v) { setState(() => _sendWhatsApp = v); _save('send_whatsapp', v); }),

          _section('المساعد الذكي'),
          _sw('تفعيل المساعد الصوتي', 'الأوامر بالصوت', _voiceAssistant, (v) { setState(() => _voiceAssistant = v); _save('voice_assistant', v); }),

          _section('العمليات'),
          _sw('منع البيع بالسالب', 'رقابة صارمة على المخزون', _preventNegativeSale, (v) { setState(() => _preventNegativeSale = v); _save('prevent_negative', v); }),
          _sw('إظهار رقم العملية', 'في جميع الشاشات', _showOperationNumber, (v) { setState(() => _showOperationNumber = v); _save('show_op_number', v); }),
          _sw('إجمالي العمليات أسفل الحساب', 'عرض المجاميع', _showTotalOperations, (v) { setState(() => _showTotalOperations = v); _save('show_totals', v); }),

          _section('التنبيهات'),
          _sw('تنبيه الديون المستحقة', 'إشعار عند وجود ديون', _debtAlert, (v) { setState(() => _debtAlert = v); _save('debt_alert', v); }),

          _section('العرض'),
          _sw('إظهار العملات', 'عملات متعددة في الشاشات', _showCurrency, (v) { setState(() => _showCurrency = v); _save('show_currency', v); }),
          _sw('الوضع الليلي', 'Dark Mode', _darkMode, (v) { setState(() => _darkMode = v); _save('dark_mode', v); }),

          _section('الإغلاق'),
          _sw('الإغلاق السنوي', 'تصفير الإيرادات والمصروفات', _yearlyClose, (v) { setState(() => _yearlyClose = v); _save('yearly_close', v); }),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _section(String title) {
    return Padding(padding: const EdgeInsets.fromLTRB(16, 20, 16, 4), child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.teal)));
  }

  Widget _sw(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(title: Text(title), subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)), value: value, onChanged: onChanged);
  }
}
