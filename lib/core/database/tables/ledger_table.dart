import 'package:drift/drift.dart';
import 'accounts_table.dart';
import 'journal_entries_table.dart';
import 'journal_lines_table.dart';

class Ledger extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get journalEntryId => integer().references(JournalEntries, #id)();
  IntColumn get journalLineId => integer().references(JournalLines, #id)();
  IntColumn get accountId => integer().references(Accounts, #id)();
  DateTimeColumn get entryDate => dateTime()();
  TextColumn get debit => text().withDefault(const Constant('0'))();
  TextColumn get credit => text().withDefault(const Constant('0'))();
  TextColumn get balance => text().withDefault(const Constant('0'))();
  TextColumn get currencyCode => text().withDefault(const Constant('YER'))();
}
