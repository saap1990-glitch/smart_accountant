import '../../database/app_database.dart';
import '../../services/accounting/account_seed_service.dart';

class AccountSeed {
  static Future<void> run(AppDatabase db) async {
    final service = AccountSeedService(db);
    await service.seed();
  }
}
