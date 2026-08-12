import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../core/services/backup/backup_service.dart';
import '../../core/services/subscription/subscription_service.dart';
import '../../core/services/templates/activity_templates.dart';
import '../../core/auth/auth_service.dart';
import 'privacy_screen.dart';
import 'terms_screen.dart';
import 'profile_screen.dart';
import 'security_screen.dart';
import 'print_screen.dart';
import 'backup_settings_screen.dart';
import 'advanced_settings_screen.dart';
import '../targets/targets_screen.dart';
import '../reports/reports_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _backup = GetIt.I<BackupService>();
  final _sub = GetIt.I<SubscriptionService>();
  final _templates = GetIt.I<ActivityTemplates>();
  final _auth = GetIt.I<AuthService>();

  bool _darkMode = false;
  bool _showNotifications = true;
  bool _autoBackup = false;
  bool _lockWithPin = true;
  bool _showBalance = true;
  bool _preventNegativeSale = true;
  bool _showOperationNumber = true;
  bool _debtAlert = true;
  bool _sendWhatsApp = false;
  bool _voiceAssistant = true;
  bool _showCurrency = true;
  double _fontSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: ListView(
        children: [
          _sectionHeader('👤 البيانات الشخصية'),
          _tile(Icons.person, Colors.teal, 'الملف الشخصي', 'الاسم، العنوان، رقم الهاتف، البريد الإلكتروني',
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()))),

          _sectionHeader('💾 النسخ الاحتياطي والمزامنة'),
          _tile(Icons.backup, Colors.blue, 'حفظ نسخة احتياطية', null, () => _backup.shareBackup()),
          _tile(Icons.restore, Colors.blue, 'استرجاع قاعدة البيانات', null, () {}),
          _tile(Icons.cloud, Colors.blue, 'جوجل درايف', 'مزامنة سحابية',
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BackupSettingsScreen()))),
          _switchTile(Icons.schedule, Colors.blue, 'حفظ البيانات يومياً', 'نسخ احتياطي تلقائي', _autoBackup,
              (v) => setState(() => _autoBackup = v)),

          _sectionHeader('🔒 خيارات الأمان'),
          _switchTile(Icons.lock, Colors.red, 'تفعيل كلمة السر', 'قفل التطبيق برقم سري', _lockWithPin,
              (v) => setState(() => _lockWithPin = v)),
          _tile(Icons.key, Colors.red, 'تغيير كلمة السر', null,
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SecurityScreen()))),

          _sectionHeader('🖨️ خيارات الطباعة'),
          _tile(Icons.print, Colors.grey, 'إعدادات الطباعة', 'الترويسة، التذييل، خيارات العرض',
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrintSettingsScreen()))),
          _switchTile(Icons.money, Colors.grey, 'طباعة الرصيد المتبقي', null, _showBalance,
              (v) => setState(() => _showBalance = v)),

          _sectionHeader('🔔 خيارات الإشعارات'),
          _switchTile(Icons.notifications, Colors.orange, 'تفعيل الإشعارات', null, _showNotifications,
              (v) => setState(() => _showNotifications = v)),
          _switchTile(Icons.warning, Colors.orange, 'تنبيه الديون', 'تنبيه عند وجود ديون مستحقة', _debtAlert,
              (v) => setState(() => _debtAlert = v)),

          _sectionHeader('⚙️ خيارات متقدمة'),
          _tile(Icons.settings, Colors.teal, 'جميع الخيارات المتقدمة', 'الواتساب، المساعد الصوتي، العملات...',
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdvancedSettingsScreen()))),
          _switchTile(Icons.message, Colors.green, 'إرسال كشف الحساب عبر الواتساب', null, _sendWhatsApp,
              (v) => setState(() => _sendWhatsApp = v)),
          _switchTile(Icons.mic, Colors.purple, 'استخدام المساعد الصوتي', null, _voiceAssistant,
              (v) => setState(() => _voiceAssistant = v)),
          _switchTile(Icons.attach_money, Colors.teal, 'إظهار العملات', null, _showCurrency,
              (v) => setState(() => _showCurrency = v)),
          _switchTile(Icons.block, Colors.red, 'إيقاف البيع بالسالب', 'رقابة صارمة على المخزون', _preventNegativeSale,
              (v) => setState(() => _preventNegativeSale = v)),
          _switchTile(Icons.format_list_numbered, Colors.teal, 'إظهار رقم العملية', null, _showOperationNumber,
              (v) => setState(() => _showOperationNumber = v)),

          _sectionHeader('🎨 المظهر'),
          _switchTile(Icons.dark_mode, Colors.indigo, 'الوضع الليلي', null, _darkMode,
              (v) => setState(() => _darkMode = v)),
          ListTile(
            leading: const Icon(Icons.format_size, color: Colors.indigo),
            title: const Text('حجم الخط'),
            subtitle: Text('${_fontSize.toInt()}'),
            trailing: SizedBox(
              width: 150,
              child: Slider(value: _fontSize, min: 12, max: 24, onChanged: (v) => setState(() => _fontSize = v)),
            ),
          ),

          _sectionHeader('👑 الاشتراك'),
          ListTile(
            leading: const Icon(Icons.subscriptions, color: Colors.purple),
            title: Text(_sub.isActive ? 'الاشتراك نشط' : 'الاشتراك منتهي'),
            subtitle: Text(_sub.isActive ? 'متبقي ${_sub.daysLeft} يوم' : 'جدد اشتراكك الآن'),
            trailing: _sub.isActive ? const Icon(Icons.check_circle, color: Colors.green) : const Icon(Icons.warning, color: Colors.red),
          ),
          _tile(Icons.key, Colors.purple, 'شراء النسخة الكاملة', 'أدخل رمز التفعيل', () {}),

          _sectionHeader('📂 قوالب الأنشطة'),
          _tile(Icons.account_tree, Colors.teal, 'اختيار قالب النشاط', 'دليل حسابات مناسب لنشاطك', _showTemplateDialog),

          _sectionHeader('📞 روابط'),
          _tile(Icons.support, Colors.blue, 'تواصل والدعم', null, () {}),
          _tile(Icons.info, Colors.blue, 'حول البرنامج', null, () {}),
          _tile(Icons.share, Colors.blue, 'مشاركة البرنامج', null, () {}),
          _tile(Icons.privacy_tip, Colors.blue, 'سياسة الخصوصية', null,
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyScreen()))),
          _tile(Icons.description, Colors.blue, 'شروط الاستخدام', null,
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsScreen()))),

          _sectionHeader(''),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('خروج'),
            onTap: () async {
              await _auth.logout();
              if (mounted) Navigator.pushReplacementNamed(context, '/login');
            },
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.teal)),
    );
  }

  Widget _tile(IconData icon, Color color, String title, String? subtitle, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _switchTile(IconData icon, Color color, String title, String? subtitle, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      secondary: Icon(icon, color: color),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      value: value,
      onChanged: onChanged,
    );
  }

  void _showTemplateDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('اختر قالب النشاط'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _templates.templates.entries.map((entry) {
              final t = entry.value;
              return ListTile(
                leading: Icon(_getIcon(t['icon']), color: Colors.teal),
                title: Text(t['name']),
                subtitle: Text(t['description']),
                onTap: () async {
                  Navigator.pop(ctx);
                  await _templates.applyTemplate(entry.key);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم تطبيق قالب: ${t['name']}')));
                },
              );
            }).toList(),
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء'))],
      ),
    );
  }

  IconData _getIcon(String name) {
    switch (name) {
      case 'store': return Icons.store;
      case 'shopping_cart': return Icons.shopping_cart;
      case 'medical_services': return Icons.medical_services;
      case 'currency_exchange': return Icons.currency_exchange;
      case 'construction': return Icons.construction;
      case 'miscellaneous_services': return Icons.miscellaneous_services;
      case 'restaurant': return Icons.restaurant;
      case 'factory': return Icons.factory;
      default: return Icons.account_balance;
    }
  }
}
