import '../../database/app_database.dart';

class BankService {
  final AppDatabase db;

  BankService(this.db);

  Future<int> createBank({
    required String code,
    required String nameArabic,
    required int accountId,
    required int currencyId,
  }) {
    return db.into(db.banks).insert(
      BanksCompanion.insert(
        code: code,
        nameArabic: nameArabic,
        accountId: accountId,
        currencyId: currencyId,
      ),
    );
  }
}
