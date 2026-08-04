import 'package:drift/drift.dart';

import '../../database/app_database.dart';

class LedgerPostingService {
  final AppDatabase db;

  LedgerPostingService(this.db);

  Future<void> postJournal({
    required int journalId,
    required DateTime date,
    required String currency,
  }) async {
    await db.transaction(() async {
      final lines = await (db.select(
        db.journalLines,
      )..where((t) => t.journalId.equals(journalId))).get();

      for (final line in lines) {
        await db
            .into(db.ledger)
            .insert(
              LedgerCompanion.insert(
                journalId: line.journalId,
                accountId: line.accountId,
                date: date,
                debit: Value(line.debit),
                credit: Value(line.credit),
                balance: Value(line.debit - line.credit),
                description: line.description,
              ),
            );

        await _updateBalance(
          accountId: line.accountId,
          currency: currency,
          debit: line.debit,
          credit: line.credit,
        );
      }
    });
  }

  Future<void> _updateBalance({
    required int accountId,
    required String currency,
    required double debit,
    required double credit,
  }) async {
    final existing =
        await (db.select(db.balances)..where(
              (t) =>
                  t.accountId.equals(accountId) & t.currency.equals(currency),
            ))
            .getSingleOrNull();

    if (existing == null) {
      await db
          .into(db.balances)
          .insert(
            BalancesCompanion.insert(
              accountId: accountId,
              currency: currency,
              debitTotal: Value(debit),
              creditTotal: Value(credit),
              balance: Value(debit - credit),
            ),
          );
      return;
    }

    await (db.update(db.balances)..where(
          (t) => t.accountId.equals(accountId) & t.currency.equals(currency),
        ))
        .write(
          BalancesCompanion(
            debitTotal: Value(existing.debitTotal + debit),
            creditTotal: Value(existing.creditTotal + credit),
            balance: Value(
              (existing.debitTotal + debit) - (existing.creditTotal + credit),
            ),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }
}
