import 'package:drift/drift.dart';

import '../../database/app_database.dart';
import '../numbering/account_number_generator.dart';

class AccountingLinkService {
  final AppDatabase db;
  final AccountNumberGenerator generator;

  AccountingLinkService(this.db, this.generator);

  Future<int> createLinkedAccount({
    required String module,
    required String entityType,
    required int entityId,
    required int parentAccountId,
    required String parentNumber,
    required String name,
    required String type,
    required String nature,
  }) async {
    final number = await generator.generate(parentNumber);

    final accountId = await db.into(db.accounts).insert(
          AccountsCompanion.insert(
            accountNumber: number,
            nameArabic: name,
            level: 5,
            accountType: type,
            nature: nature,
            parentId: Value(parentAccountId),
          ),
        );

    await db.into(db.accountLinks).insert(
          AccountLinksCompanion.insert(
            module: module,
            entityType: entityType,
            entityId: entityId,
            accountId: accountId,
          ),
        );

    return accountId;
  }

  Future<int> createCashBoxAccount({
    required int cashBoxId,
    required String name,
    required int parentId,
    required String parentNumber,
  }) =>
      createLinkedAccount(
        module: 'cash',
        entityType: 'cash_box',
        entityId: cashBoxId,
        parentAccountId: parentId,
        parentNumber: parentNumber,
        name: name,
        type: 'ASSET',
        nature: 'DEBIT',
      );

  Future<int> createBankAccount({
    required int bankId,
    required String name,
    required int parentId,
    required String parentNumber,
  }) =>
      createLinkedAccount(
        module: 'bank',
        entityType: 'bank',
        entityId: bankId,
        parentAccountId: parentId,
        parentNumber: parentNumber,
        name: name,
        type: 'ASSET',
        nature: 'DEBIT',
      );

  Future<int> createWalletAccount({
    required int walletId,
    required String name,
    required int parentId,
    required String parentNumber,
  }) =>
      createLinkedAccount(
        module: 'wallet',
        entityType: 'wallet',
        entityId: walletId,
        parentAccountId: parentId,
        parentNumber: parentNumber,
        name: name,
        type: 'ASSET',
        nature: 'DEBIT',
      );

  Future<int> createExchangeCompanyAccount({
    required int exchangeId,
    required String name,
    required int parentId,
    required String parentNumber,
  }) =>
      createLinkedAccount(
        module: 'exchange',
        entityType: 'exchange_company',
        entityId: exchangeId,
        parentAccountId: parentId,
        parentNumber: parentNumber,
        name: name,
        type: 'ASSET',
        nature: 'DEBIT',
      );
}
