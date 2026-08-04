import 'package:drift/drift.dart';

import '../../database/app_database.dart';

class FinancialAccountService {
  final AppDatabase db;

  FinancialAccountService(this.db);

  Future<List<FinancialAccount>> getAll() async {
    return await db.select(db.financialAccounts).get();
  }

  Future<List<FinancialAccount>> getByType(String type) async {
    return await (db.select(db.financialAccounts)
          ..where((t) => t.type.equals(type)))
        .get();
  }

  Future<FinancialAccount?> findByCode(String code) async {
    final result = await (db.select(db.financialAccounts)
          ..where((t) => t.code.equals(code)))
        .get();

    if (result.isEmpty) return null;

    return result.first;
  }


  Future<int?> findAccountId(String accountNumber) async {
    final result = await (db.select(db.accounts)
          ..where((t) => t.accountNumber.equals(accountNumber)))
        .get();

    if (result.isEmpty) return null;

    return result.first.id;
  }

  Future<int> add({
    required String type,
    required String code,
    required String nameArabic,
    required int accountId,
    required int currencyId,
    String? externalNumber,
    String? providerName,
  }) async {
    return await db.into(db.financialAccounts).insert(
          FinancialAccountsCompanion.insert(
            type: type,
            code: code,
            nameArabic: nameArabic,
            accountId: accountId,
            currencyId: currencyId,
            externalNumber:
                externalNumber == null ? const Value.absent() : Value(externalNumber),
            providerName:
                providerName == null ? const Value.absent() : Value(providerName),
          ),
        );
  }
}
