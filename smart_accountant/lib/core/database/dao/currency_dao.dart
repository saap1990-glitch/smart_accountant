import 'package:drift/drift.dart';

import '../app_database.dart';

class CurrencyDao {
  final AppDatabase db;

  CurrencyDao(this.db);

  Future<List<Currency>> getAll() {
    return db.select(db.currencies).get();
  }

  Future<int> insertCurrency(CurrenciesCompanion currency) {
    return db.into(db.currencies).insert(currency);
  }
}
