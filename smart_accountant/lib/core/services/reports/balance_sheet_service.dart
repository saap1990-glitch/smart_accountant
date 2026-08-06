import '../../database/app_database.dart';

class BalanceSheetService {

  final AppDatabase db;

  BalanceSheetService(this.db);


  Future<Map<String, dynamic>> generate() async {

    final accounts = await db.select(db.accounts).get();
    final ledger = await db.select(db.ledger).get();


    double assets = 0;
    double liabilities = 0;
    double equity = 0;


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


      final balance = debit - credit;


      switch(account.accountType) {

        case 'ASSET':
          assets += balance;
          break;

        case 'LIABILITY':
          liabilities += -balance;
          break;

        case 'EQUITY':
          equity += -balance;
          break;
      }
    }


    return {
      'assets': assets,
      'liabilities': liabilities,
      'equity': equity,
      'totalLiabilitiesAndEquity':
          liabilities + equity,
    };
  }
}
