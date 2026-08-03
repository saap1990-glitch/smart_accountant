import 'package:drift/drift.dart';

import '../../database/app_database.dart';

class JournalRepository {
  final AppDatabase db;

  JournalRepository(this.db);

  Future<int> createEntry({
    required String reference,

    required String description,

    required DateTime date,

    required String currency,

    required double exchangeRate,

    required List<JournalLinesCompanion> lines,
  }) async {
    return db.transaction(() async {
      final journalId = await db
          .into(db.journalEntries)
          .insert(
            JournalEntriesCompanion.insert(
              reference: reference,

              description: description,

              date: date,

              currency: currency,

              exchangeRate: Value(exchangeRate),
            ),
          );

      final updatedLines = lines
          .map((line) => line.copyWith(journalId: Value(journalId)))
          .toList();

      await db.batch((batch) {
        batch.insertAll(db.journalLines, updatedLines);
      });

      return journalId;
    });
  }
}
