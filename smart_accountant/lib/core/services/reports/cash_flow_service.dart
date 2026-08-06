import '../../database/app_database.dart';

class CashFlowService {

  final AppDatabase db;

  CashFlowService(this.db);


  Future<Map<String, dynamic>> generate() async {

    final ledger = await db.select(db.ledger).get();

    double inflow = 0;
    double outflow = 0;


    for (final entry in ledger) {

      if (entry.debit > 0) {
        inflow += entry.debit;
      }


      if (entry.credit > 0) {
        outflow += entry.credit;
      }
    }


    return {
      'cashIn': inflow,
      'cashOut': outflow,
      'netCashFlow': inflow - outflow,
    };
  }
}
