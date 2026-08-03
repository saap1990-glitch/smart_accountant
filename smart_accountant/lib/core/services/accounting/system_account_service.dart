import 'package:drift/drift.dart';

import '../../database/app_database.dart';

class SystemAccountService {
  final AppDatabase db;

  SystemAccountService(this.db);

  Future<int?> getAccountId(String key) async {
    final result = await (db.select(
      db.systemAccounts,
    )..where((tbl) => tbl.key.equals(key))).getSingleOrNull();

    return result?.accountId;
  }

  Future<void> saveAccount(
    String key,
    int accountId,
    String description,
  ) async {
    await db
        .into(db.systemAccounts)
        .insert(
          SystemAccountsCompanion.insert(
            key: key,
            accountId: accountId,
            description: Value(description),
          ),
        );
  }
}
