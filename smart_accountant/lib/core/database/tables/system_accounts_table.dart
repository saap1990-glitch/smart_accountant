import 'package:drift/drift.dart';

class SystemAccounts extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get key => text().unique()();

  IntColumn get accountId => integer()();

  TextColumn get description => text().nullable()();
}
