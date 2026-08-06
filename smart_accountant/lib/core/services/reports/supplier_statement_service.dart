import '../../database/app_database.dart';

class SupplierStatementService {

  final AppDatabase db;

  SupplierStatementService(this.db);


  Future<List<Map<String, dynamic>>> generate({
    required int accountId,
  }) async {

    final rows = await db.select(db.ledger).get();


    return rows
        .where((e) => e.accountId == accountId)
        .map((e) => {
              'date': e.date,
              'description': e.description,
              'debit': e.debit,
              'credit': e.credit,
              'balance': e.balance,
            })
        .toList();
  }
}
