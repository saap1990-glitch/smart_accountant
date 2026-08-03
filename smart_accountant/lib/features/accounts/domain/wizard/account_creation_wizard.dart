import '../../../../core/database/app_database.dart';

import '../../../../core/services/accounting/accounting_link_service.dart';

import '../../../../core/services/accounting/system_account_service.dart';

import 'account_creation_request.dart';

class AccountCreationWizard {
  final AppDatabase db;

  final AccountingLinkService linkService;

  final SystemAccountService systemAccounts;

  AccountCreationWizard({
    required this.db,

    required this.linkService,

    required this.systemAccounts,
  });

  Future<int> create(AccountCreationRequest request) async {
    final key = _resolveKey(request.entityType);

    final parentId = await systemAccounts.getAccountId(key);

    if (parentId == null) {
      throw Exception('لم يتم إعداد الحساب الافتراضي $key');
    }

    final parent = await (db.select(
      db.accounts,
    )..where((tbl) => tbl.id.equals(parentId))).getSingle();

    return linkService.createLinkedAccount(
      module: request.module,

      entityType: request.entityType,

      entityId: 0,

      parentAccountId: parent.id,

      parentNumber: parent.accountNumber,

      name: request.name,

      type: parent.accountType,

      nature: parent.nature,
    );
  }

  String _resolveKey(String type) {
    switch (type) {
      case 'CUSTOMER':
        return 'CUSTOMERS';

      case 'SUPPLIER':
        return 'SUPPLIERS';

      case 'BANK':
        return 'BANKS';

      case 'WALLET':
        return 'WALLETS';

      case 'EXCHANGE':
        return 'EXCHANGE_COMPANIES';

      default:
        throw Exception('نوع غير معروف');
    }
  }
}
