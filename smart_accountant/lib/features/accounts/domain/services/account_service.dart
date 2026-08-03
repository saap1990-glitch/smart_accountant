import '../../../../core/database/app_database.dart';

class AccountService {
  final AppDatabase db;

  AccountService(this.db);

  Future<List<Account>> getTree() {
    return db.select(db.accounts).get();
  }

  Future<Account?> find(String number) {
    return (db.select(
      db.accounts,
    )..where((tbl) => tbl.accountNumber.equals(number))).getSingleOrNull();
  }

  Future<bool> canDelete(int id) async {
    final account = await (db.select(
      db.accounts,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

    if (account == null) {
      return false;
    }

    final children = await (db.select(
      db.accounts,
    )..where((tbl) => tbl.parentId.equals(id))).get();

    return children.isEmpty;
  }
}
