import '../../database/app_database.dart';
import '../accounting/accounting_link_service.dart';

class MasterAccountLinkService {

  final AppDatabase db;
  final AccountingLinkService accountService;

  MasterAccountLinkService(
    this.db,
    this.accountService,
  );


  Future<int> createCustomerAccount({
    required int customerId,
    required String name,
  }) {
    return accountService.createLinkedAccount(
      module: 'CUSTOMERS',
      entityType: 'CUSTOMER',
      entityId: customerId,
      parentAccountId: 0,
      parentNumber: '12000',
      name: name,
      type: 'ASSET',
      nature: 'DEBIT',
    );
  }


  Future<int> createSupplierAccount({
    required int supplierId,
    required String name,
  }) {
    return accountService.createLinkedAccount(
      module: 'SUPPLIERS',
      entityType: 'SUPPLIER',
      entityId: supplierId,
      parentAccountId: 0,
      parentNumber: '21000',
      name: name,
      type: 'LIABILITY',
      nature: 'CREDIT',
    );
  }
}
