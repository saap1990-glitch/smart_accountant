import '../../database/app_database.dart';

class ReportService {

  final AppDatabase db;

  ReportService(this.db);


  Future<List<Map<String, dynamic>>> accountStatement({
    required int accountId,
  }) async {

    final rows = await db.select(db.ledger).get();

    return rows
        .where((e) => e.accountId == accountId)
        .map((e) => {
              'date': e.date,
              'debit': e.debit,
              'credit': e.credit,
              'description': e.description,
            })
        .toList();
  }


  Future<double> accountBalance({
    required int accountId,
  }) async {

    final data = await accountStatement(
      accountId: accountId,
    );

    double balance = 0;

    for (final row in data) {
      balance += (row['debit'] ?? 0);
      balance -= (row['credit'] ?? 0);
    }

    return balance;
  }
}
