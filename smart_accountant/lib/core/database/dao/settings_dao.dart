import 'package:drift/drift.dart';

import '../app_database.dart';

class SettingsDao {
  final AppDatabase db;

  SettingsDao(this.db);

  Future<String?> getValue(String key) async {
    final result = await (db.select(
      db.settings,
    )..where((tbl) => tbl.key.equals(key))).getSingleOrNull();

    return result?.value;
  }

  Future<int> save(SettingsCompanion setting) {
    return db
        .into(db.settings)
        .insert(setting, mode: InsertMode.insertOrReplace);
  }
}
