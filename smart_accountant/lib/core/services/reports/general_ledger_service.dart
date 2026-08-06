import '../../database/app_database.dart';

class GeneralLedgerService {

  final AppDatabase db;

  GeneralLedgerService(this.db);


  Future<List<Map<String, dynamic>>> generate({
    required int accountId,
  }) async {

    final rows = await db.select(db.ledger).get();

    return rows
        .where((e) => e.accountId == accountId)
        .map((e) => {
              'date': e.date,
              'journalId': e.journalId,
              'description': e.description,
              'debit': e.debit,
              'credit': e.credit,
            })
        .toList();
  }
}
