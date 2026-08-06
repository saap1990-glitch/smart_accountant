import '../../database/app_database.dart';

class IncomeStatementService {

  final AppDatabase db;

  IncomeStatementService(this.db);


  Future<Map<String, dynamic>> generate() async {

    final accounts = await db.select(db.accounts).get();
    final ledger = await db.select(db.ledger).get();


    double revenues = 0;
    double expenses = 0;


    for (final account in accounts) {

      final entries = ledger.where(
        (e) => e.accountId == account.id,
      );


      double debit = 0;
      double credit = 0;


      for (final e in entries) {
        debit += e.debit;
        credit += e.credit;
      }


      if (account.accountType == 'REVENUE') {
        revenues += credit - debit;
      }


      if (account.accountType == 'EXPENSE') {
        expenses += debit - credit;
      }
    }


    return {
      'revenues': revenues,
      'expenses': expenses,
      'netProfit': revenues - expenses,
    };
  }
}
