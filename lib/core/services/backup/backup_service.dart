import 'package:drift/drift.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../database/app_database.dart';
import 'package:get_it/get_it.dart';

class BackupService {
  final _storage = const FlutterSecureStorage();

  Future<bool> get autoBackupEnabled async => await _storage.read(key: 'auto_backup') == 'true';
  Future<void> setAutoBackup(bool value) async => await _storage.write(key: 'auto_backup', value: value.toString());
  Future<String?> get backupPath async => await _storage.read(key: 'backup_path');
  Future<void> setBackupPath(String path) async => await _storage.write(key: 'backup_path', value: path);
  Future<String?> get backupTime async => await _storage.read(key: 'backup_time');
  Future<void> setBackupTime(String time) async => await _storage.write(key: 'backup_time', value: time);

  /// تصدير نسخة احتياطية كاملة من قاعدة البيانات
  Future<File> exportBackup() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/backup_${DateTime.now().millisecondsSinceEpoch}.json');

    final db = GetIt.I<AppDatabase>();

    // جمع جميع البيانات
    final accounts = await db.select(db.accounts).get();
    final customers = await db.select(db.customers).get();
    final suppliers = await db.select(db.suppliers).get();
    final items = await db.select(db.items).get();
    final banks = await db.select(db.banks).get();
    final cashBoxes = await db.select(db.cashBoxes).get();
    final wallets = await db.select(db.wallets).get();
    final exchangeCompanies = await db.select(db.exchangeCompanies).get();
    final currencies = await db.select(db.currencies).get();
    final warehouses = await db.select(db.warehouses).get();
    final journalEntries = await db.select(db.journalEntries).get();
    final journalLines = await db.select(db.journalLines).get();
    final ledger = await db.select(db.ledger).get();

    final data = {
      'version': '1.0',
      'date': DateTime.now().toIso8601String(),
      'accounts': accounts.map((a) => {'number': a.number, 'name_ar': a.nameAr, 'name_en': a.nameEn, 'type': a.type, 'nature': a.nature, 'parent_id': a.parentId, 'level': a.level}).toList(),
      'customers': customers.map((c) => {'name': c.name, 'phone': c.phone, 'address': c.address}).toList(),
      'suppliers': suppliers.map((s) => {'name': s.name, 'phone': s.phone, 'address': s.address}).toList(),
      'items': items.map((i) => {'name': i.name, 'unit': i.unit, 'cost': i.cost, 'price': i.price}).toList(),
      'banks': banks.map((b) => {'name': b.name, 'account_number': b.accountNumber}).toList(),
      'cash_boxes': cashBoxes.map((c) => {'name': c.name}).toList(),
      'wallets': wallets.map((w) => {'name': w.name, 'provider': w.provider}).toList(),
      'exchange_companies': exchangeCompanies.map((e) => {'name': e.name, 'phone': e.phone}).toList(),
      'currencies': currencies.map((c) => {'code': c.code, 'name': c.name, 'exchange_rate': c.exchangeRate, 'is_default': c.isDefault}).toList(),
      'warehouses': warehouses.map((w) => {'name': w.name, 'location': w.location}).toList(),
      'journal_count': journalEntries.length,
      'journal_lines_count': journalLines.length,
      'ledger_count': ledger.length,
    };

    await file.writeAsString(jsonEncode(data));
    return file;
  }

  /// مشاركة النسخة الاحتياطية
  Future<void> shareBackup() async {
    final file = await exportBackup();
    await Share.shareXFiles([XFile(file.path)], text: 'نسخة احتياطية من المحاسب الذكي');
  }

  /// استيراد نسخة احتياطية
  Future<bool> importBackup(String filePath) async {
    try {
      final content = await File(filePath).readAsString();
      final data = jsonDecode(content) as Map<String, dynamic>;

      final db = GetIt.I<AppDatabase>();

      // استعادة البيانات
      if (data['customers'] != null) {
        for (var c in data['customers'] as List) {
          await db.into(db.customers).insert(CustomersCompanion(name: Value(c['name']), phone: Value(c['phone']), address: Value(c['address'])));
        }
      }
      if (data['suppliers'] != null) {
        for (var s in data['suppliers'] as List) {
          await db.into(db.suppliers).insert(SuppliersCompanion(name: Value(s['name']), phone: Value(s['phone']), address: Value(s['address'])));
        }
      }
      if (data['items'] != null) {
        for (var i in data['items'] as List) {
          await db.into(db.items).insert(ItemsCompanion(name: Value(i['name']), unit: Value(i['unit']), cost: Value(double.tryParse(i['cost']?.toString() ?? '0') ?? 0), price: Value(double.tryParse(i['price']?.toString() ?? '0') ?? 0)));
        }
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
