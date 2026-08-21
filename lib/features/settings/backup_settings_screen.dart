import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:file_picker/file_picker.dart';
import '../../core/services/backup/backup_service.dart';

class BackupSettingsScreen extends StatefulWidget {
  const BackupSettingsScreen({super.key});

  @override
  State<BackupSettingsScreen> createState() => _BackupSettingsScreenState();
}

class _BackupSettingsScreenState extends State<BackupSettingsScreen> {
  final _backup = GetIt.I<BackupService>();
  bool _autoBackup = false;
  String _backupTime = '22:00';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _autoBackup = await _backup.autoBackupEnabled;
    _backupTime = await _backup.backupTime ?? '22:00';
    if (mounted) setState(() {});
  }

  Future<void> _restore() async {
    try {
      final result = await FilePicker.pickFiles(type: FileType.any);
      if (result.isNotEmpty) {
        final path = result.first.path;
        if (path != null) {
          final ok = await _backup.importBackup(path);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(ok ? '✅ تمت الاستعادة' : '❌ فشلت')),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('فشل اختيار الملف')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('النسخ الاحتياطي والاستعادة')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('حفظ يومي تلقائي'),
            value: _autoBackup,
            onChanged: (v) async {
              setState(() => _autoBackup = v);
              await _backup.setAutoBackup(v);
            },
          ),
          ListTile(
            leading: const Icon(Icons.access_time),
            title: const Text('وقت الحفظ'),
            subtitle: Text(_backupTime),
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: const TimeOfDay(hour: 22, minute: 0),
              );
              if (time != null) {
                final formatted =
                    '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                setState(() => _backupTime = formatted);
                await _backup.setBackupTime(formatted);
              }
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.backup),
                  label: const Text('نسخ الآن'),
                  onPressed: () => _backup.shareBackup(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.restore),
                  label: const Text('استعادة'),
                  onPressed: _restore,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
