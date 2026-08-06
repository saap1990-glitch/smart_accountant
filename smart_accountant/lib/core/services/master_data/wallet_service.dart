import '../../database/app_database.dart';

class WalletService {
  final AppDatabase db;

  WalletService(this.db);

  Future<int> createWallet({
    required String code,
    required String nameArabic,
    required String provider,
    required int accountId,
    required int currencyId,
  }) {
    return db.into(db.wallets).insert(
      WalletsCompanion.insert(
        code: code,
        nameArabic: nameArabic,
        provider: provider,
        accountId: accountId,
        currencyId: currencyId,
      ),
    );
  }
}
