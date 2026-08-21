import 'package:drift/drift.dart';
import '../database/app_database.dart';

class LedgerRepository {

  LedgerRepository(this._db);
  final AppDatabase _db;

  Future<void> addLedgerEntry({
    required int journalEntryId,
    required int journalLineId,
    required int accountId,
    required DateTime entryDate,
    required double debit,
    required double credit,
    required String currencyCode,
  }) async {
    await _db
        .into(_db.ledger)
        .insert(
          LedgerCompanion(
            journalEntryId: Value(journalEntryId),
            journalLineId: Value(journalLineId),
            accountId: Value(accountId),
            entryDate: Value(entryDate),
            debit: Value(debit.toString()),
            credit: Value(credit.toString()),
            balance: const Value('0'),
            currencyCode: Value(currencyCode),
          ),
        );
  }

  Future<List<Map<String, dynamic>>> getAccountStatement({
    required int accountId,
    DateTime? from,
    DateTime? to,
    String? currencyCode,
  }) async {
    var query = _db.select(_db.ledger)
      ..where((t) => t.accountId.equals(accountId));

    if (currencyCode != null) {
      query = query..where((t) => t.currencyCode.equals(currencyCode));
    }

    if (from != null) {
      query = query..where((t) => t.entryDate.isBiggerOrEqualValue(from));
    }

    if (to != null) {
      query = query..where((t) => t.entryDate.isSmallerOrEqualValue(to));
    }

    query.orderBy([
      (t) => OrderingTerm.asc(t.entryDate),
      (t) => OrderingTerm.asc(t.id),
    ]);

    final rows = await query.get();

    double runningBalance = 0;

    if (from != null) {
      runningBalance = await getBalance(
        accountId,
        asOf: from.subtract(const Duration(microseconds: 1)),
        currencyCode: currencyCode,
      );
    }

    return rows.map((r) {
      final debit = _number(r.debit);
      final credit = _number(r.credit);

      runningBalance += debit - credit;

      return {
        'id': r.id,
        'journal_entry_id': r.journalEntryId,
        'journal_line_id': r.journalLineId,
        'date': r.entryDate,
        'description': 'رقم القيد: ${r.journalEntryId}',
        'debit': debit,
        'credit': credit,
        'balance': runningBalance,
        'currency_code': r.currencyCode,
      };
    }).toList();
  }

  Future<double> getBalance(
    int accountId, {
    DateTime? asOf,
    String? currencyCode,
  }) async {
    var query = _db.select(_db.ledger)
      ..where((t) => t.accountId.equals(accountId));

    if (currencyCode != null) {
      query = query..where((t) => t.currencyCode.equals(currencyCode));
    }

    if (asOf != null) {
      query = query..where((t) => t.entryDate.isSmallerOrEqualValue(asOf));
    }

    final rows = await query.get();

    double balance = 0;

    for (final row in rows) {
      balance += _number(row.debit) - _number(row.credit);
    }

    return balance;
  }

  Future<Map<String, double>> getTotals(
    int accountId, {
    DateTime? from,
    DateTime? to,
    String? currencyCode,
  }) async {
    var query = _db.select(_db.ledger)
      ..where((t) => t.accountId.equals(accountId));

    if (currencyCode != null) {
      query = query..where((t) => t.currencyCode.equals(currencyCode));
    }

    if (from != null) {
      query = query..where((t) => t.entryDate.isBiggerOrEqualValue(from));
    }

    if (to != null) {
      query = query..where((t) => t.entryDate.isSmallerOrEqualValue(to));
    }

    final rows = await query.get();

    double debit = 0;
    double credit = 0;

    for (final row in rows) {
      debit += _number(row.debit);
      credit += _number(row.credit);
    }

    return {'debit': debit, 'credit': credit, 'balance': debit - credit};
  }

  Future<List<Map<String, dynamic>>> getEntries({
    DateTime? from,
    DateTime? to,
    String? currencyCode,
  }) async {
    var query = _db.select(_db.ledger);

    if (currencyCode != null) {
      query = query..where((t) => t.currencyCode.equals(currencyCode));
    }

    if (from != null) {
      query = query..where((t) => t.entryDate.isBiggerOrEqualValue(from));
    }

    if (to != null) {
      query = query..where((t) => t.entryDate.isSmallerOrEqualValue(to));
    }

    query.orderBy([
      (t) => OrderingTerm.asc(t.entryDate),
      (t) => OrderingTerm.asc(t.id),
    ]);

    final rows = await query.get();

    return rows
        .map(
          (r) => {
            'id': r.id,
            'journal_entry_id': r.journalEntryId,
            'journal_line_id': r.journalLineId,
            'account_id': r.accountId,
            'date': r.entryDate,
            'debit': _number(r.debit),
            'credit': _number(r.credit),
            'balance': _number(r.balance),
            'currency_code': r.currencyCode,
          },
        )
        .toList();
  }

  double _number(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }
}
