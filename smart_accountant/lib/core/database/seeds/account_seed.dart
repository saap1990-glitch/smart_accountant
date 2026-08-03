import 'package:drift/drift.dart';

import '../app_database.dart';

class AccountSeed {
  static Future<void> run(AppDatabase db) async {
    final count = await db.accounts.count().getSingle();

    if (count > 0) {
      return;
    }

    Future<int> add(
      String number,
      String name,
      int level,
      String type,
      String nature,
      int? parent,
    ) {
      return db
          .into(db.accounts)
          .insert(
            AccountsCompanion.insert(
              accountNumber: number,
              nameArabic: name,
              level: level,
              accountType: type,
              nature: nature,
              parentId: Value(parent),
            ),
          );
    }

    // المستوى الأول

    final assets = await add('1', 'الأصول', 1, 'ASSET', 'DEBIT', null);

    final liabilities = await add(
      '2',
      'الخصوم',
      1,
      'LIABILITY',
      'CREDIT',
      null,
    );

    final expenses = await add('3', 'المصروفات', 1, 'EXPENSE', 'DEBIT', null);

    final revenues = await add('4', 'الإيرادات', 1, 'REVENUE', 'CREDIT', null);

    // المستوى الثاني

    final currentAssets = await add(
      '11',
      'الأصول المتداولة',
      2,
      'ASSET',
      'DEBIT',
      assets,
    );

    final fixedAssets = await add(
      '12',
      'الأصول غير المتداولة',
      2,
      'ASSET',
      'DEBIT',
      assets,
    );

    final currentLiabilities = await add(
      '21',
      'الخصوم المتداولة',
      2,
      'LIABILITY',
      'CREDIT',
      liabilities,
    );

    final longLiabilities = await add(
      '22',
      'الخصوم طويلة الأجل',
      2,
      'LIABILITY',
      'CREDIT',
      liabilities,
    );

    final operatingExpenses = await add(
      '31',
      'المصروفات التشغيلية',
      2,
      'EXPENSE',
      'DEBIT',
      expenses,
    );

    final otherRevenue = await add(
      '41',
      'إيرادات النشاط الرئيسي',
      2,
      'REVENUE',
      'CREDIT',
      revenues,
    );

    // حسابات الأصول المتداولة

    await add('1101', 'الصندوق', 3, 'ASSET', 'DEBIT', currentAssets);

    await add('1102', 'البنوك', 3, 'ASSET', 'DEBIT', currentAssets);

    await add('1103', 'شركات الصرافة', 3, 'ASSET', 'DEBIT', currentAssets);

    await add(
      '1104',
      'المحافظ الإلكترونية',
      3,
      'ASSET',
      'DEBIT',
      currentAssets,
    );

    await add('1105', 'العملاء', 3, 'ASSET', 'DEBIT', currentAssets);

    // حسابات الخصوم

    await add('2101', 'الموردون', 3, 'LIABILITY', 'CREDIT', currentLiabilities);

    // المصروفات

    await add('3101', 'الرواتب', 3, 'EXPENSE', 'DEBIT', operatingExpenses);

    await add('3102', 'الإيجارات', 3, 'EXPENSE', 'DEBIT', operatingExpenses);

    // الإيرادات

    await add('4101', 'المبيعات', 3, 'REVENUE', 'CREDIT', otherRevenue);
  }
}
