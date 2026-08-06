import '../accounting/accounting_link_service.dart';

class FinancialAccountLinkerService {
  final AccountingLinkService linkService;

  FinancialAccountLinkerService(this.linkService);

  Future<int> linkCashBox({
    required int id,
    required String name,
    required int parentId,
    required String parentNumber,
  }) {
    return linkService.createCashBoxAccount(
      cashBoxId: id,
      name: name,
      parentId: parentId,
      parentNumber: parentNumber,
    );
  }

  Future<int> linkBank({
    required int id,
    required String name,
    required int parentId,
    required String parentNumber,
  }) {
    return linkService.createBankAccount(
      bankId: id,
      name: name,
      parentId: parentId,
      parentNumber: parentNumber,
    );
  }

  Future<int> linkWallet({
    required int id,
    required String name,
    required int parentId,
    required String parentNumber,
  }) {
    return linkService.createWalletAccount(
      walletId: id,
      name: name,
      parentId: parentId,
      parentNumber: parentNumber,
    );
  }

  Future<int> linkExchangeCompany({
    required int id,
    required String name,
    required int parentId,
    required String parentNumber,
  }) {
    return linkService.createExchangeCompanyAccount(
      exchangeId: id,
      name: name,
      parentId: parentId,
      parentNumber: parentNumber,
    );
  }
}
