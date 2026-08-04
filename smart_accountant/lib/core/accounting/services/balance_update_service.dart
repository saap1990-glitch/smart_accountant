import 'package:drift/drift.dart';

import '../../database/app_database.dart';

class BalanceUpdateService {
  final AppDatabase db;

  const BalanceUpdateService(this.db);

  Future<void> update({
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
          ),
        );
  }
}
