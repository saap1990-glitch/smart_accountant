import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../database/tables/ledger_table.dart';

class LedgerRepository {
  final AppDatabase _db;

  LedgerRepository(this._db);

  /// إضافة حركة إلى الأستاذ العام
  Future<void> addLedgerEntry({
    required int journalEntryId,
    required int journalLineId,
    required int accountId,
    required DateTime entryDate,
    required double debit,
    required double credit,
    required String currencyCode,
  }) async {
    // جلب الرصيد السابق
    final previousBalance = await _getCurrentBalance(accountId, currencyCode);

    final newBalance = previousBalance + debit - credit;

    await _db.into(_db.ledger).insert(
      LedgerCompanion(
        journalEntryId: Value(journalEntryId),
        journalLineId: Value(journalLineId),
        accountId: Value(accountId),
        entryDate: Value(entryDate),
        debit: Value(debit.toString()),
        credit: Value(credit.toString()),
        balance: Value(newBalance.toString()),
        currencyCode: Value(currencyCode),
      ),
    );
  }

  /// جلب الرصيد الحالي لحساب معين
  Future<double> _getCurrentBalance(int accountId, String currencyCode) async {
    final lastEntry = await (_db.select(_db.ledger)
      ..where((t) => t.accountId.equals(accountId))
      ..where((t) => t.currencyCode.equals(currencyCode))
      ..orderBy([(t) => OrderingTerm.desc(t.entryDate)]))
      .getSingleOrNull();

    if (lastEntry != null) {
      return double.tryParse(lastEntry.balance) ?? 0;
    }
    return 0;
  }

  /// جلب كشف حساب كامل
  Future<List<Map<String, dynamic>>> getAccountStatement({
    required int accountId,
    DateTime? from,
    DateTime? to,
  }) async {
    var query = _db.select(_db.ledger)
      ..where((t) => t.accountId.equals(accountId));

    if (from != null) {
      query = query..where((t) => t.entryDate.isBiggerOrEqualValue(from));
    }
    if (to != null) {
      query = query..where((t) => t.entryDate.isSmallerOrEqualValue(to));
    }

    final rows = await (query
      ..orderBy([(t) => OrderingTerm.asc(t.entryDate)]))
      .get();

    return rows.map((r) => {
      'date': r.entryDate,
      'description': 'قيد #${r.journalEntryId}',
      'debit': r.debit,
      'credit': r.credit,
      'balance': r.balance,
    }).toList();
  }

  /// جلب الرصيد الحالي كـ double
  Future<double> getBalance(int accountId) async {
    final rows = await (_db.select(_db.ledger)
      ..where((t) => t.accountId.equals(accountId))
      ..orderBy([(t) => OrderingTerm.desc(t.entryDate)]))
      .get();

    if (rows.isNotEmpty) {
      return double.tryParse(rows.first.balance) ?? 0;
    }
    return 0;
  }
}
