import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../core/services/backup/backup_service.dart';

class BackupSettingsScreen extends StatefulWidget {
  const BackupSettingsScreen({super.key});

  @override
  State<BackupSettingsScreen> createState() => _BackupSettingsScreenState();
}

class _BackupSettingsScreenState extends State<BackupSettingsScreen> {
  final _backup = GetIt.I<BackupService>();

  bool _autoBackup = false;
  String? _backupPath;
  String _backupTime = '22:00';
  bool _notifyError = true;
  bool _closeNotify = false;
  String? _cloudAccount;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _autoBackup = await _backup.autoBackupEnabled;
    _backupPath = await _backup.backupPath ?? '/storage/emulated/0/SmartAccountant/Backups';
    _backupTime = await _backup.backupTime ?? '22:00';
    _notifyError = await _backup.notifyOnError;
    _closeNotify = await _backup.showCloseNotification;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('خيارات الحفظ والأرشفة')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // حفظ تلقائي
          SwitchListTile(
            secondary: const Icon(Icons.schedule, color: Colors.teal),
            title: const Text('حفظ البيانات يومياً'),
            subtitle: const Text('نسخ احتياطي تلقائي لحماية العمليات'),
            value: _autoBackup,
            onChanged: (v) async {
              setState(() => _autoBackup = v);
              await _backup.setAutoBackup(v);
            },
          ),

          // وقت الحفظ
          if (_autoBackup) ...[
            ListTile(
              leading: const Icon(Icons.access_time, color: Colors.teal),
              title: const Text('وقت حفظ البيانات'),
              subtitle: Text(_backupTime),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(
                    hour: int.parse(_backupTime.split(':')[0]),
                    minute: int.parse(_backupTime.split(':')[1]),
                  ),
                );
                if (time != null) {
                  final formatted = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                  setState(() => _backupTime = formatted);
                  await _backup.setBackupTime(formatted);
                }
              },
            ),
          ],

          const Divider(),

          // مجلد الحفظ
          ListTile(
            leading: const Icon(Icons.folder, color: Colors.blue),
            title: const Text('مجلد حفظ البيانات'),
            subtitle: Text(_backupPath ?? 'غير محدد'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // يمكن فتح FilePicker هنا
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('سيتم تفعيل اختيار المجلد قريباً')),
              );
            },
          ),

          // استعادة الصور
          ListTile(
            leading: const Icon(Icons.image, color: Colors.blue),
            title: const Text('استعادة الصور'),
            subtitle: const Text('استعادة صور المنتجات من النسخة الاحتياطية'),
            onTap: () async {
              await _backup.restoreImages();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تمت استعادة الصور ✅')),
              );
            },
          ),

          const Divider(),

          // حساب سحابي
          ListTile(
            leading: const Icon(Icons.cloud, color: Colors.blue),
            title: const Text('تغيير الحساب السحابي'),
            subtitle: Text(_cloudAccount ?? 'غير مرتبط'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),

          const Divider(),

          // تنبيهات
          SwitchListTile(
            secondary: const Icon(Icons.error_outline, color: Colors.orange),
            title: const Text('تنبيه تلقائي في حال حدوث خطأ'),
            subtitle: const Text('إشعار فوري عند فشل النسخ الاحتياطي'),
            value: _notifyError,
            onChanged: (v) async {
              setState(() => _notifyError = v);
              await _backup.setNotifyOnError(v);
            },
          ),

          SwitchListTile(
            secondary: const Icon(Icons.notifications_active, color: Colors.orange),
            title: const Text('إظهار الإشعار عند إغلاق التطبيق'),
            subtitle: const Text('تذكير بعمل نسخة احتياطية قبل الخروج'),
            value: _closeNotify,
            onChanged: (v) async {
              setState(() => _closeNotify = v);
              await _backup.setShowCloseNotification(v);
            },
          ),

          const SizedBox(height: 24),

          // أزرار سريعة
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.backup),
                  label: const Text('نسخ احتياطي الآن'),
                  onPressed: () => _backup.shareBackup(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.restore),
                  label: const Text('استعادة نسخة'),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
