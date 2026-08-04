import 'package:drift/drift.dart';

import '../app_database.dart';

class FinancialAccountSeed {
  static Future<void> run(AppDatabase db) async {
    final exists = await db.select(db.financialAccounts).get();

    if (exists.isNotEmpty) return;

    Future<int?> accountId(String number) async {
      final result = await (db.select(db.accounts)
            ..where((t) => t.accountNumber.equals(number)))
          .get();

      if (result.isEmpty) return null;

      return result.first.id;
    }

    final currency = await db.select(db.currencies).getSingle();

    final cashAccount = await accountId('11101');
    final bankAccount = await accountId('11200');
    final walletAccount = await accountId('11300');
    final exchangeAccount = await accountId('11400');

    if (cashAccount != null) {
      await db.into(db.financialAccounts).insert(
            FinancialAccountsCompanion.insert(
              type: 'CASH',
              code: 'CASH001',
              nameArabic: 'الصندوق الرئيسي',
              accountId: cashAccount,
              currencyId: currency.id,
            ),
          );
    }

    if (bankAccount != null) {
      await db.into(db.financialAccounts).insert(
            FinancialAccountsCompanion.insert(
              type: 'BANK',
              code: 'BANK001',
              nameArabic: 'البنك الرئيسي',
              accountId: bankAccount,
              currencyId: currency.id,
            ),
          );
    }

    if (walletAccount != null) {
      await db.into(db.financialAccounts).insert(
            FinancialAccountsCompanion.insert(
              type: 'WALLET',
              code: 'WALLET001',
              nameArabic: 'المحفظة الإلكترونية',
              accountId: walletAccount,
              currencyId: currency.id,
            ),
          );
    }

    if (exchangeAccount != null) {
      await db.into(db.financialAccounts).insert(
            FinancialAccountsCompanion.insert(
              type: 'EXCHANGE',
              code: 'EX001',
              nameArabic: 'شركة الصرافة',
              accountId: exchangeAccount,
              currencyId: currency.id,
            ),
          );
    }
  }
}
