import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BackupService {
  final _storage = const FlutterSecureStorage();

  Future<bool> get autoBackupEnabled async => await _storage.read(key: 'auto_backup') == 'true';
  Future<void> setAutoBackup(bool value) async => await _storage.write(key: 'auto_backup', value: value.toString());
  Future<String?> get backupPath async => await _storage.read(key: 'backup_path');
  Future<void> setBackupPath(String path) async => await _storage.write(key: 'backup_path', value: path);
  Future<String?> get backupTime async => await _storage.read(key: 'backup_time');
  Future<void> setBackupTime(String time) async => await _storage.write(key: 'backup_time', value: time);
  Future<bool> get notifyOnError async => await _storage.read(key: 'backup_notify_error') == 'true';
  Future<void> setNotifyOnError(bool value) async => await _storage.write(key: 'backup_notify_error', value: value.toString());
  Future<bool> get showCloseNotification async => await _storage.read(key: 'backup_close_notify') == 'true';
  Future<void> setShowCloseNotification(bool value) async => await _storage.write(key: 'backup_close_notify', value: value.toString());

  Future<File> exportBackup() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/backup_${DateTime.now().millisecondsSinceEpoch}.json');
    final data = {'version': '1.0', 'date': DateTime.now().toIso8601String(), 'accounts': [], 'transactions': []};
    await file.writeAsString(jsonEncode(data));
    return file;
  }

  Future<void> shareBackup() async {
    final file = await exportBackup();
    await Share.shareXFiles([XFile(file.path)], text: 'نسخة احتياطية من المحاسب الذكي');
  }

  Future<Map<String, dynamic>?> importBackup(String path) async {
    try {
      final content = await File(path).readAsString();
      return jsonDecode(content) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  Future<void> restoreImages() async {}
}
