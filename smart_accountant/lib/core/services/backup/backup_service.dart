import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class BackupService {
  Future<File> exportBackup() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/backup_${DateTime.now().millisecondsSinceEpoch}.json');
    final data = {
      'version': '1.0',
      'date': DateTime.now().toIso8601String(),
      'accounts': [],
      'transactions': [],
    };
    await file.writeAsString(jsonEncode(data));
    return file;
  }

  Future<void> shareBackup() async {
    final file = await exportBackup();
    await Share.shareXFiles([XFile(file.path)], text: 'نسخة احتياطية من المحاسب الذكي');
  }

  Future<void> importBackup(String path) async {
    await File(path).readAsString();
  }
}
