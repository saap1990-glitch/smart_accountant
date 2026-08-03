import 'package:drift/drift.dart';

import '../app_database.dart';

class AccountDao {
  final AppDatabase db;

  AccountDao(this.db);

  Future<List<Account>> getAll() {
    return db.select(db.accounts).get();
  }

  Future<Account?> findByNumber(String number) {
    return (db.select(
      db.accounts,
    )..where((tbl) => tbl.accountNumber.equals(number))).getSingleOrNull();
  }

  Future<int> insertAccount(AccountsCompanion account) {
    return db.into(db.accounts).insert(account);
  }

  Future<bool> updateAccount(AccountsCompanion account) {
    return db.update(db.accounts).replace(account);
  }
}
