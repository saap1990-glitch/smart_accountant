import 'package:drift/drift.dart';

class DocumentLines extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get documentId => integer()();

  IntColumn get itemId => integer().nullable()();

  IntColumn get accountId => integer()();

  RealColumn get quantity =>
      real().withDefault(const Constant(0))();

  RealColumn get price =>
      real().withDefault(const Constant(0))();

  RealColumn get debit =>
      real().withDefault(const Constant(0))();

  RealColumn get credit =>
      real().withDefault(const Constant(0))();

  TextColumn get description => text().nullable()();
}
