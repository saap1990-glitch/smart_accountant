import '../../database/app_database.dart';

class CashBoxService {
  final AppDatabase db;

  CashBoxService(this.db);

  Future<int> createCashBox({
    required String code,
    required String nameArabic,
    required int accountId,
    required int currencyId,
  }) {
    return db.into(db.cashBoxes).insert(
      CashBoxesCompanion.insert(
        code: code,
        nameArabic: nameArabic,
        accountId: accountId,
        currencyId: currencyId,
      ),
    );
  }
}
