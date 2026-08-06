import '../../database/app_database.dart';

class TrialBalanceService {

  final AppDatabase db;

  TrialBalanceService(this.db);


  Future<List<Map<String, dynamic>>> generate() async {

    final accounts = await db.select(db.accounts).get();
    final balances = await db.select(db.balances).get();

    return accounts.map((account) {

      final balance = balances.where(
        (b) => b.accountId == account.id,
      );

      double debit = 0;
      double credit = 0;

      for (final item in balance) {
        debit += item.debitTotal;
        credit += item.creditTotal;
      }

      return {
        'accountId': account.id,
        'accountNumber': account.accountNumber,
        'name': account.nameArabic,
        'debit': debit,
        'credit': credit,
        'balance': debit - credit,
      };

    }).toList();
  }
}
