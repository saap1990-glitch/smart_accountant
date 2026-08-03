import '../app_database.dart';

import 'account_seed.dart';
import 'system_account_seed.dart';

class DatabaseSeedService {
  final AppDatabase db;

  DatabaseSeedService(this.db);

  Future<void> execute() async {
    // إنشاء دليل الحسابات الأساسي

    await AccountSeed.run(db);

    // إنشاء الحسابات الافتراضية للنظام

    await SystemAccountSeed.run(db);
  }
}
