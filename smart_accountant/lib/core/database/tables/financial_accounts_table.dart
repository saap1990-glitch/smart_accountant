import 'package:drift/drift.dart';

class FinancialAccounts extends Table {
  IntColumn get id => integer().autoIncrement()();

  // CASH / BANK / WALLET / EXCHANGE
  TextColumn get type => text()();

  // رقم داخلي للحساب المالي
  TextColumn get code => text().unique()();

  TextColumn get nameArabic => text()();

  TextColumn get nameEnglish => text().nullable()();

  // الربط مع دليل الحسابات
  IntColumn get accountId => integer()();

  // العملة الأساسية للحساب
  IntColumn get currencyId => integer()();

  // رقم الحساب البنكي أو المحفظة أو الهاتف
  TextColumn get externalNumber => text().nullable()();

  // اسم البنك أو شركة الصرافة أو مزود المحفظة
  TextColumn get providerName => text().nullable()();

  BoolColumn get active =>
      boolean().withDefault(const Constant(true))();

  TextColumn get notes =>
      text().nullable()();
}
