import 'package:drift/drift.dart';

import '../../database/app_database.dart';
import '../models/accounting_entry.dart';

class JournalMapper {
  const JournalMapper();

  List<JournalLinesCompanion> toLines({
    required AccountingEntry entry,
    required int journalId,
  }) {
    return entry.lines.map((line) {
      return JournalLinesCompanion.insert(
        journalId: journalId,
        accountId: line.accountId,
        debit: Value(line.debit),
        credit: Value(line.credit),
        description: line.description,
      );
    }).toList();
  }

  List<JournalLinesCompanion> toJournalLines(AccountingEntry entry) {
    return toLines(entry: entry, journalId: 0);
  }
}
