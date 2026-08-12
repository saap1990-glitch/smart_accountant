import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../database/tables/journal_entries_table.dart';
import '../database/tables/journal_lines_table.dart';

class JournalRepository {
  final AppDatabase _db;

  JournalRepository(this._db);

  /// حفظ قيد يومية كامل مع بنوده
  Future<int> saveJournalEntry({
    required String entryNumber,
    required DateTime entryDate,
    required String operationType,
    required String? description,
    required String? referenceType,
    required String? referenceId,
    required String currencyCode,
    required double exchangeRate,
    required List<Map<String, dynamic>> lines,
  }) async {
    // 1. حفظ رأس القيد
    final entryId = await _db.into(_db.journalEntries).insert(
      JournalEntriesCompanion(
        entryNumber: Value(entryNumber),
        entryDate: Value(entryDate),
        operationType: Value(operationType),
        status: const Value('posted'),
        description: Value(description),
        referenceType: Value(referenceType),
        referenceId: Value(referenceId),
        currencyCode: Value(currencyCode),
        exchangeRate: Value(exchangeRate.toString()),
        createdAt: Value(DateTime.now()),
      ),
    );

    // 2. حفظ بنود القيد
    for (final line in lines) {
      await _db.into(_db.journalLines).insert(
        JournalLinesCompanion(
          journalEntryId: Value(entryId),
          accountId: Value(line['accountId'] as int),
          description: Value(line['description']?.toString()),
          debit: Value((line['debit'] ?? 0).toString()),
          credit: Value((line['credit'] ?? 0).toString()),
          currencyCode: Value(currencyCode),
          exchangeRate: Value(exchangeRate.toString()),
          foreignDebit: Value(((line['debit'] ?? 0) * exchangeRate).toString()),
          foreignCredit: Value(((line['credit'] ?? 0) * exchangeRate).toString()),
        ),
      );
    }

    return entryId;
  }

  /// جلب جميع القيود
  Future<List<Map<String, dynamic>>> getAllEntries() async {
    final entries = await _db.select(_db.journalEntries).get();
    return entries.map((e) => {
      'id': e.id,
      'entry_number': e.entryNumber,
      'entry_date': e.entryDate,
      'operation_type': e.operationType,
      'description': e.description,
      'status': e.status,
    }).toList();
  }

  /// جلب بنود قيد محدد
  Future<List<Map<String, dynamic>>> getEntryLines(int entryId) async {
    final lines = await (_db.select(_db.journalLines)
      ..where((t) => t.journalEntryId.equals(entryId))).get();
    return lines.map((l) => {
      'id': l.id,
      'account_id': l.accountId,
      'debit': l.debit,
      'credit': l.credit,
      'description': l.description,
    }).toList();
  }
}
