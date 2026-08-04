import 'package:flutter_test/flutter_test.dart';

import 'package:smart_accountant/core/database/app_database.dart';
import 'package:smart_accountant/core/services/accounting/account_seed_service.dart';

void main() {
  late AppDatabase db;
  late AccountSeedService seedService;

  setUp(() {
    db = AppDatabase();
    seedService = AccountSeedService(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('Account tree seed creates main accounting accounts', () async {
    await seedService.seed();

    final accounts = await db.select(db.accounts).get();

    expect(accounts.isNotEmpty, true);

    final assets = accounts.firstWhere(
      (account) => account.accountNumber == '10000',
    );

    expect(assets.nameArabic, 'الأصول');
    expect(assets.level, 1);

    final cash = accounts.firstWhere(
      (account) => account.accountNumber == '11100',
    );

    expect(cash.nameArabic, 'النقدية وما في حكمها');
    expect(cash.allowPosting, false);

    final box = accounts.firstWhere(
      (account) => account.accountNumber == '11101',
    );

    expect(box.nameArabic, 'الصندوق');
    expect(box.allowPosting, true);
  });
}
