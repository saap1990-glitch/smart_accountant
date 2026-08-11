import 'package:drift/drift.dart';
import 'accounts_table.dart';
import 'journal_entries_table.dart';

class JournalLines extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get journalEntryId => integer().references(JournalEntries, #id)();
  IntColumn get accountId => integer().references(Accounts, #id)();
  TextColumn get description => text().nullable()();
  TextColumn get debit => text().withDefault(const Constant('0'))();
  TextColumn get credit => text().withDefault(const Constant('0'))();
  TextColumn get currencyCode => text().withDefault(const Constant('YER'))();
  TextColumn get exchangeRate => text().withDefault(const Constant('1'))();
  TextColumn get foreignDebit => text().withDefault(const Constant('0'))();
  TextColumn get foreignCredit => text().withDefault(const Constant('0'))();
}
