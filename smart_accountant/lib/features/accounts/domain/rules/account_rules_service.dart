import '../../../../core/database/app_database.dart';

class AccountRulesService {
  final AppDatabase db;

  AccountRulesService(this.db);

  Future<bool> accountNumberExists(String number) async {
    final result = await (db.select(
      db.accounts,
    )..where((tbl) => tbl.accountNumber.equals(number))).getSingleOrNull();

    return result != null;
  }

  Future<bool> hasChildren(int accountId) async {
    final result = await (db.select(
      db.accounts,
    )..where((tbl) => tbl.parentId.equals(accountId))).get();

    return result.isNotEmpty;
  }

  Future<bool> canPost(int accountId) async {
    final children = await hasChildren(accountId);

    return !children;
  }

  Future<bool> canDelete(int accountId) async {
    final account = await (db.select(
      db.accounts,
    )..where((tbl) => tbl.id.equals(accountId))).getSingleOrNull();

    if (account == null) {
      return false;
    }

    // الحسابات الرئيسية لا تحذف
    if (account.level <= 3) {
      return false;
    }

    final children = await hasChildren(accountId);

    return !children;
  }
}
