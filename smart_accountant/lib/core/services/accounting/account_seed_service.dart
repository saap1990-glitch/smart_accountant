import 'package:drift/drift.dart';

import '../../database/app_database.dart';

class AccountSeedService {
  final AppDatabase db;

  AccountSeedService(this.db);

  Future<void> seed() async {
    final exists = await db.select(db.accounts).get();

    if (exists.isNotEmpty) return;

    final assets = await _add(
      '10000',
      'الأصول',
      1,
      'ASSET',
      'DEBIT',
      null,
      false,
    );

    final currentAssets = await _add(
      '11000',
      'الأصول المتداولة',
      2,
      'ASSET',
      'DEBIT',
      assets,
      false,
    );

    final cash = await _add(
      '11100',
      'النقدية وما في حكمها',
      3,
      'ASSET',
      'DEBIT',
      currentAssets,
      false,
    );

    await _add(
      '11101',
      'الصندوق',
      4,
      'ASSET',
      'DEBIT',
      cash,
      true,
    );

    await _add(
      '11200',
      'البنوك',
      3,
      'ASSET',
      'DEBIT',
      currentAssets,
      true,
    );

    await _add(
      '11300',
      'المحافظ الإلكترونية',
      3,
      'ASSET',
      'DEBIT',
      currentAssets,
      true,
    );

    await _add(
      '12000',
      'العملاء',
      2,
      'ASSET',
      'DEBIT',
      assets,
      true,
    );

    await _add(
      '13000',
      'المخزون',
      2,
      'ASSET',
      'DEBIT',
      assets,
      true,
    );

    final fixedAssets = await _add(
      '14000',
      'الأصول الثابتة',
      2,
      'ASSET',
      'DEBIT',
      assets,
      false,
    );

    await _add(
      '14001',
      'الأثاث والتجهيزات',
      3,
      'ASSET',
      'DEBIT',
      fixedAssets,
      true,
    );

    final liabilities = await _add(
      '20000',
      'الخصوم',
      1,
      'LIABILITY',
      'CREDIT',
      null,
      false,
    );

    await _add(
      '21000',
      'الموردون',
      2,
      'LIABILITY',
      'CREDIT',
      liabilities,
      true,
    );

    final expenses = await _add(
      '30000',
      'المصروفات',
      1,
      'EXPENSE',
      'DEBIT',
      null,
      false,
    );

    await _add(
      '31000',
      'مصروفات التشغيل',
      2,
      'EXPENSE',
      'DEBIT',
      expenses,
      true,
    );

    final revenues = await _add(
      '40000',
      'الإيرادات',
      1,
      'REVENUE',
      'CREDIT',
      null,
      false,
    );

    await _add(
      '41000',
      'المبيعات',
      2,
      'REVENUE',
      'CREDIT',
      revenues,
      true,
    );
  }

  Future<int> _add(
    String number,
    String name,
    int level,
    String type,
    String nature,
    int? parent,
    bool posting,
  ) async {
    return db.into(db.accounts).insert(
          AccountsCompanion.insert(
            accountNumber: number,
            nameArabic: name,
            level: level,
            accountType: type,
            nature: nature,
            parentId: Value(parent),
            allowPosting: Value(posting),
          ),
        );
  }
}
