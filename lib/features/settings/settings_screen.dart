import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/auth/auth_service.dart';
import '../../core/services/backup/backup_service.dart';
import '../../core/services/subscription/subscription_service.dart';
import '../../core/services/templates/activity_templates.dart';

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
  static const _storage = FlutterSecureStorage();

  late final BackupService _backup;
  late final SubscriptionService _subscription;
  late final ActivityTemplates _templates;
  late final AuthService _auth;

  bool _autoBackup = false;
  bool _lockWithPin = true;
  bool _showBalance = true;
  bool _preventNegativeSale = true;
  bool _showOperationNumber = true;
  bool _debtAlert = true;
  bool _voiceAssistant = true;
  bool _showCurrency = true;
  bool _darkMode = false;
  bool _yearlyClose = true;

  double _fontSize = 16;

  @override
  void initState() {
    super.initState();

    _backup = GetIt.I<BackupService>();
    _subscription = GetIt.I<SubscriptionService>();
    _templates = GetIt.I<ActivityTemplates>();
    _auth = GetIt.I<AuthService>();

    _load();
  }

  Future<void> _load() async {
    _autoBackup = await _storage.read(key: 'auto_backup') == 'true';
    _lockWithPin = await _storage.read(key: 'lock_pin') != 'false';
    _showBalance = await _storage.read(key: 'show_balance') != 'false';
    _preventNegativeSale =
        await _storage.read(key: 'prevent_negative') != 'false';
    _showOperationNumber =
        await _storage.read(key: 'show_op_number') != 'false';
    _debtAlert = await _storage.read(key: 'debt_alert') != 'false';
    _voiceAssistant = await _storage.read(key: 'voice_assistant') != 'false';
    _showCurrency = await _storage.read(key: 'show_currency') != 'false';
    _darkMode = await _storage.read(key: 'dark_mode') == 'true';
    _yearlyClose = await _storage.read(key: 'yearly_close') != 'false';

    final size = await _storage.read(key: 'font_size');
    _fontSize = double.tryParse(size ?? '') ?? 16;

    if (mounted) setState(() {});
  }

  Future<void> _save(String key, Object value) async {
    await _storage.write(key: key, value: value.toString());
  }

  void _open(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  Future<void> _backupNow() async {
    try {
      await _backup.shareBackup();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إنشاء النسخة الاحتياطية ✅')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذر إنشاء النسخة الاحتياطية')),
        );
      }
    }
  }

  Future<void> _logout() async {
    await _auth.logout();

    if (!mounted) return;

    Navigator.pushReplacementNamed(context, '/login');
  }

  void _showTemplates() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: ListView(
          children: [
            const ListTile(
              leading: Icon(Icons.account_tree, color: Colors.teal),
              title: Text(
                'قوالب الأنشطة المحاسبية',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            ..._templates.templates.keys.map(
              (name) => ListTile(
                leading: const Icon(Icons.business),
                title: Text(name),
                onTap: () => Navigator.pop(ctx),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final active = _subscription.isActive;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
        actions: [
          IconButton(
            tooltip: 'إعادة تحميل',
            icon: const Icon(Icons.refresh),
            onPressed: _load,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          _section('👤 البيانات الشخصية'),

          _tile(
            Icons.person,
            Colors.teal,
            'الملف الشخصي',
            'الاسم والعنوان والتواصل وبيانات المستخدم',
            () => _open(const ProfileScreen()),
          ),

          _section('💾 النسخ الاحتياطي والاستعادة'),

          _tile(
            Icons.backup,
            Colors.blue,
            'نسخ احتياطي الآن',
            'إنشاء نسخة من بيانات التطبيق ومشاركتها',
            _backupNow,
          ),

          _tile(
            Icons.cloud_sync,
            Colors.blue,
            'إعدادات النسخ الاحتياطي',
            'الحفظ التلقائي ووقت النسخ والاستعادة',
            () => _open(const BackupSettingsScreen()),
          ),

          _switch(
            'الحفظ اليومي التلقائي',
            'تشغيل النسخ الاحتياطي التلقائي',
            _autoBackup,
            (v) async {
              setState(() => _autoBackup = v);
              await _save('auto_backup', v);
              await _backup.setAutoBackup(v);
            },
          ),

          _section('🔐 الأمان والحماية'),

          _tile(
            Icons.security,
            Colors.red,
            'إعدادات الأمان',
            'PIN والبصمة والحماية',
            () => _open(const SecurityScreen()),
          ),

          _switch('قفل التطبيق', 'طلب الحماية عند فتح التطبيق', _lockWithPin, (
            v,
          ) async {
            setState(() => _lockWithPin = v);
            await _save('lock_pin', v);
          }),

          _section('🖨️ الطباعة'),

          _tile(
            Icons.print,
            Colors.grey,
            'إعدادات الطباعة',
            'الترويسة والتذييل والتاريخ والأرصدة',
            () => _open(const PrintSettingsScreen()),
          ),

          _switch(
            'إظهار الرصيد في الطباعة',
            'عرض الرصيد المتبقي في المستندات',
            _showBalance,
            (v) {
              setState(() => _showBalance = v);
              _save('show_balance', v);
            },
          ),

          _section('⚙️ العمليات والمحاسبة'),

          _switch(
            'منع البيع بالسالب',
            'منع بيع كمية أكبر من رصيد المخزون',
            _preventNegativeSale,
            (v) {
              setState(() => _preventNegativeSale = v);
              _save('prevent_negative', v);
            },
          ),

          _switch(
            'إظهار رقم العملية',
            'إظهار الرقم التلقائي للمستندات',
            _showOperationNumber,
            (v) {
              setState(() => _showOperationNumber = v);
              _save('show_op_number', v);
            },
          ),

          _switch(
            'تنبيهات الديون',
            'التنبيه عند وجود ديون مستحقة',
            _debtAlert,
            (v) {
              setState(() => _debtAlert = v);
              _save('debt_alert', v);
            },
          ),

          _section('🤖 المساعد الذكي'),

          _switch(
            'المساعد الصوتي',
            'السماح بالأوامر الصوتية',
            _voiceAssistant,
            (v) {
              setState(() => _voiceAssistant = v);
              _save('voice_assistant', v);
            },
          ),

          _section('💱 العملات'),

          _switch(
            'إظهار العملات',
            'تفعيل التعامل متعدد العملات داخل الشاشات',
            _showCurrency,
            (v) {
              setState(() => _showCurrency = v);
              _save('show_currency', v);
            },
          ),

          _section('🎨 المظهر'),

          _switch('الوضع الليلي', 'تفضيل المظهر الداكن', _darkMode, (v) {
            setState(() => _darkMode = v);
            _save('dark_mode', v);
          }),

          ListTile(
            leading: const Icon(Icons.format_size, color: Colors.indigo),
            title: const Text('حجم الخط'),
            subtitle: Text('${_fontSize.toInt()}'),
            trailing: SizedBox(
              width: 150,
              child: Slider(
                min: 12,
                max: 24,
                divisions: 12,
                value: _fontSize,
                onChanged: (v) {
                  setState(() => _fontSize = v);
                  _save('font_size', v);
                },
              ),
            ),
          ),

          _section('📂 قوالب الأنشطة'),

          _tile(
            Icons.account_tree,
            Colors.teal,
            'قوالب الأنشطة',
            'اختيار الهيكل المحاسبي المناسب للنشاط',
            _showTemplates,
          ),

          _section('🔒 الإغلاق السنوي'),

          _tile(
            Icons.calendar_month,
            Colors.red,
            'الإغلاق السنوي',
            'إغلاق السنة وترحيل النتيجة',
            () => _open(const YearCloseScreen()),
          ),

          _switch(
            'تفعيل الإغلاق السنوي',
            'السماح بإجراءات الإغلاق السنوي',
            _yearlyClose,
            (v) {
              setState(() => _yearlyClose = v);
              _save('yearly_close', v);
            },
          ),

          _section('👑 الاشتراك'),

          ListTile(
            leading: Icon(
              active ? Icons.check_circle : Icons.warning,
              color: active ? Colors.green : Colors.red,
            ),
            title: Text(active ? 'الاشتراك نشط' : 'الاشتراك منتهي'),
            subtitle: Text(
              active
                  ? 'متبقي ${_subscription.daysLeft} يوم'
                  : 'يرجى تجديد الاشتراك',
            ),
          ),

          ListTile(
            leading: const Icon(Icons.key, color: Colors.purple),
            title: const Text('شراء / تفعيل النسخة'),
            subtitle: const Text('إدخال رمز التفعيل'),
            onTap: _showActivation,
          ),

          _section('🧰 خيارات متقدمة'),

          _tile(
            Icons.tune,
            Colors.teal,
            'جميع الخيارات المتقدمة',
            'إعدادات النظام التفصيلية',
            () => _open(const AdvancedSettingsScreen()),
          ),

          _section('🚪 الحساب'),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('تسجيل الخروج'),
            onTap: _logout,
          ),
        ],
      ),
    );
  }

  void _showActivation() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تفعيل الاشتراك'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'رمز التفعيل',
            prefixIcon: Icon(Icons.key),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              final ok = await _subscription.activate(controller.text.trim());

              if (ctx.mounted) Navigator.pop(ctx);

              if (mounted) {
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      ok ? 'تم تفعيل الاشتراك ✅' : 'رمز التفعيل غير صحيح ❌',
                    ),
                  ),
                );
              }
            },
            child: const Text('تفعيل'),
          ),
        ],
      ),
    );
  }

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.teal,
        ),
      ),
    );
  }

  Widget _tile(
    IconData icon,
    Color color,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _switch(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 11, color: Colors.grey),
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}
