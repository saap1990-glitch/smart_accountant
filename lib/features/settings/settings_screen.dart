import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/services/backup/backup_service.dart';
import '../../core/services/subscription/subscription_service.dart';
import '../../core/services/templates/activity_templates.dart';
import '../../core/auth/auth_service.dart';
import '../../core/theme/app_theme.dart';
import 'profile_screen.dart';
import 'security_screen.dart';
import 'print_screen.dart';
import 'backup_settings_screen.dart';
import 'advanced_settings_screen.dart';
import 'year_close_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _storage = const FlutterSecureStorage();
  final _backup = GetIt.I<BackupService>();
  final _sub = GetIt.I<SubscriptionService>();
  final _templates = GetIt.I<ActivityTemplates>();
  final _auth = GetIt.I<AuthService>();

  // إعدادات محفوظة
  bool _darkMode = false;
  bool _autoBackup = false;
  bool _lockWithPin = true;
  bool _showBalance = true;
  bool _preventNegativeSale = true;
  bool _showOperationNumber = true;
  bool _debtAlert = true;
  bool _voiceAssistant = true;
  bool _showCurrency = true;
  double _fontSize = 16.0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _darkMode = await _storage.read(key: 'dark_mode') == 'true';
    _autoBackup = await _storage.read(key: 'auto_backup') == 'true';
    _lockWithPin = await _storage.read(key: 'lock_pin') != 'false';
    _showBalance = await _storage.read(key: 'show_balance') != 'false';
    _preventNegativeSale = await _storage.read(key: 'prevent_negative') != 'false';
    _showOperationNumber = await _storage.read(key: 'show_op_number') != 'false';
    _debtAlert = await _storage.read(key: 'debt_alert') != 'false';
    _voiceAssistant = await _storage.read(key: 'voice_assistant') != 'false';
    _showCurrency = await _storage.read(key: 'show_currency') != 'false';
    final fontSize = await _storage.read(key: 'font_size');
    if (fontSize != null) _fontSize = double.tryParse(fontSize) ?? 16.0;
    if (mounted) setState(() {});
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    await _storage.write(key: key, value: value.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: ListView(
        children: [
          _section('👤 البيانات الشخصية'),
          _tile(Icons.person, Colors.teal, 'الملف الشخصي', 'الاسم والعنوان والتواصل', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()))),

          _section('💾 النسخ الاحتياطي'),
          _tile(Icons.backup, Colors.blue, 'حفظ نسخة احتياطية', 'تصدير ومشاركة', () => _backup.shareBackup()),
          _tile(Icons.cloud, Colors.blue, 'خيارات الحفظ', 'تلقائي ومسارات', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BackupSettingsScreen()))),
          _switch('حفظ يومي تلقائي', 'نسخ احتياطي تلقائي', _autoBackup, (v) { setState(() => _autoBackup = v); _saveSetting('auto_backup', v); }),

          _section('🔒 الأمان'),
          _tile(Icons.lock, Colors.red, 'كلمة السر', 'PIN والحماية', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SecurityScreen()))),
          _switch('قفل التطبيق', 'يتطلب PIN عند الفتح', _lockWithPin, (v) { setState(() => _lockWithPin = v); _saveSetting('lock_pin', v); }),

          _section('🖨️ الطباعة'),
          _tile(Icons.print, Colors.grey, 'خيارات الطباعة', 'ترويسة وتذييل', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrintSettingsScreen()))),
          _switch('طباعة الرصيد', 'إظهار الرصيد في الطباعة', _showBalance, (v) { setState(() => _showBalance = v); _saveSetting('show_balance', v); }),

          _section('⚙️ خيارات متقدمة'),
          _tile(Icons.settings, Colors.teal, 'جميع الخيارات', 'الصوت والعملات والمزيد', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdvancedSettingsScreen()))),
          _switch('منع البيع بالسالب', 'رقابة على المخزون', _preventNegativeSale, (v) { setState(() => _preventNegativeSale = v); _saveSetting('prevent_negative', v); }),
          _switch('إظهار رقم العملية', 'في الشاشات', _showOperationNumber, (v) { setState(() => _showOperationNumber = v); _saveSetting('show_op_number', v); }),
          _switch('تنبيه الديون', 'إشعار بالديون المستحقة', _debtAlert, (v) { setState(() => _debtAlert = v); _saveSetting('debt_alert', v); }),
          _switch('المساعد الصوتي', 'الأوامر بالصوت', _voiceAssistant, (v) { setState(() => _voiceAssistant = v); _saveSetting('voice_assistant', v); }),
          _switch('إظهار العملات', 'عملات متعددة', _showCurrency, (v) { setState(() => _showCurrency = v); _saveSetting('show_currency', v); }),

          _section('🎨 المظهر'),
          _switch('الوضع الليلي', 'Dark Mode', _darkMode, (v) { setState(() => _darkMode = v); _saveSetting('dark_mode', v); }),
          ListTile(
            leading: const Icon(Icons.format_size, color: Colors.indigo),
            title: const Text('حجم الخط'),
            subtitle: Text('${_fontSize.toInt()}'),
            trailing: SizedBox(width: 150, child: Slider(value: _fontSize, min: 12, max: 24, onChanged: (v) { setState(() => _fontSize = v.toDouble()); _saveSetting('font_size', v.toString()); })),
          ),

          _section('📂 القوالب'),
          _tile(Icons.account_tree, Colors.teal, 'قوالب الأنشطة', 'اختيار دليل حسابات', _showTemplates),

          _section('🔒 الإغلاق السنوي'),
          _tile(Icons.calendar_month, Colors.red, 'الإغلاق السنوي', 'تصفير الحسابات', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const YearCloseScreen()))),

          _section('👑 الاشتراك'),
          ListTile(
            leading: const Icon(Icons.subscriptions, color: Colors.purple),
            title: Text(_sub.isActive ? 'الاشتراك نشط' : 'الاشتراك منتهي'),
            subtitle: Text(_sub.isActive ? 'متبقي ${_sub.daysLeft} يوم' : 'جدد اشتراكك'),
            trailing: _sub.isActive ? const Icon(Icons.check_circle, color: Colors.green) : const Icon(Icons.warning, color: Colors.red),
          ),
          _tile(Icons.key, Colors.purple, 'شراء النسخة الكاملة', 'إدخال رمز التفعيل', _showActivation),

          _section('🚪'),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('خروج'),
            onTap: () async { await _auth.logout(); if (mounted) Navigator.pushReplacementNamed(context, '/login'); },
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _section(String title) {
    return Padding(padding: const EdgeInsets.fromLTRB(16, 20, 16, 8), child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.teal)));
  }

  Widget _tile(IconData icon, Color color, String title, String subtitle, VoidCallback onTap) {
    return ListTile(leading: Icon(icon, color: color), title: Text(title), subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)), trailing: const Icon(Icons.arrow_forward_ios, size: 16), onTap: onTap);
  }

  Widget _switch(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(title: Text(title, style: const TextStyle(fontSize: 15)), subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)), value: value, onChanged: onChanged, secondary: const Icon(Icons.toggle_on, color: Colors.teal));
  }

  void _showTemplates() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('اختر قالب النشاط'),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: _templates.templates.entries.map((e) => ListTile(title: Text(e.value['name'] ?? ''), subtitle: Text(e.value['description'] ?? ''), onTap: () async { Navigator.pop(ctx); await _templates.applyTemplate(e.key); if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم تطبيق: ${e.value['name']}'))); })).toList()),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء'))],
      ),
    );
  }

  void _showActivation() {
    final codeCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تفعيل الاشتراك'),
        content: TextField(controller: codeCtrl, decoration: const InputDecoration(labelText: 'رمز التفعيل')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(onPressed: () async {
            final ok = await _sub.activate(codeCtrl.text.trim());
            if (ctx.mounted) Navigator.pop(ctx);
            if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'تم التفعيل ✅' : 'رمز غير صحيح ❌')));
          }, child: const Text('تفعيل')),
        ],
      ),
    );
  }
}
