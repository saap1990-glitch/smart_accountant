import '../../repositories/documents/document_repository.dart';
import '../numbering/operation_number_service.dart';
import '../workflow/workflow_manager.dart';

class DocumentService {
  final DocumentRepository repository;
  final OperationNumberService numberService;
  final WorkflowManager workflow;

  DocumentService(this.repository, this.numberService, this.workflow);


  Future<int> createReceipt({
    required String number,
    required int accountId,
    required String currency,
    required double amount,
  }) async {
    final id = await repository.createDocument(
      number: number,
      type: 'RECEIPT',
      accountId: accountId,
      currency: currency,
      exchangeRate: 1,
    );

    await repository.addLine(
      documentId: id,
      accountId: accountId,
      debit: amount,
    );

    return id;
  }
}


extension DocumentOperations on DocumentService {

  Future<int> createPayment({
    required String number,
    required int accountId,
    required String currency,
    required double amount,
  }) async {
    final id = await repository.createDocument(
      number: number,
      type: 'PAYMENT',
      accountId: accountId,
      currency: currency,
      exchangeRate: 1,
    );

    await repository.addLine(
      documentId: id,
      accountId: accountId,
      credit: amount,
    );

    return id;
  }


  Future<int> createSale({
    required String number,
    required int customerAccountId,
    required int revenueAccountId,
    required String currency,
    required double amount,
  }) async {
    return workflow.execute<int>(
      operation: 'SALE',
      action: () async {

        final id = await repository.createDocument(
          number: number,
          type: 'SALE',
          accountId: customerAccountId,
          currency: currency,
          exchangeRate: 1,
        );

        await repository.addLine(
          documentId: id,
          accountId: customerAccountId,
          debit: amount,
        );

        await repository.addLine(
          documentId: id,
          accountId: revenueAccountId,
          credit: amount,
        );

        return id;
      },
    );
  }


  Future<int> createPurchase({
    required String number,
    required int supplierAccountId,
    required int inventoryAccountId,
    required String currency,
    required double amount,
  }) async {
    return workflow.execute<int>(
      operation: 'PURCHASE',
      action: () async {

        final id = await repository.createDocument(
          number: number,
          type: 'PURCHASE',
          accountId: supplierAccountId,
          currency: currency,
          exchangeRate: 1,
        );

        await repository.addLine(
          documentId: id,
          accountId: inventoryAccountId,
          debit: amount,
        );

        await repository.addLine(
          documentId: id,
          accountId: supplierAccountId,
          credit: amount,
        );

        return id;
      },
    );
  }
}


extension SmartDocumentCreation on DocumentService {

  Future<int> createAutoReceipt({
    required int accountId,
    required String currency,
    required double amount,
  }) async {
    final number = await numberService.generate(
      prefix: 'REC',
      type: 'RECEIPT',
    );

    return createReceipt(
      number: number,
      accountId: accountId,
      currency: currency,
      amount: amount,
    );
  }


  Future<int> createAutoPayment({
    required int accountId,
    required String currency,
    required double amount,
  }) async {
    final number = await numberService.generate(
      prefix: 'PAY',
      type: 'PAYMENT',
    );

    return createPayment(
      number: number,
      accountId: accountId,
      currency: currency,
      amount: amount,
    );
  }


  Future<int> createAutoSale({
    required int accountId,
    required String currency,
    required double amount,
  }) async {
    final number = await numberService.generate(
      prefix: 'SAL',
      type: 'SALE',
    );

    return createSale(
      number: number,
      customerAccountId: accountId,
      revenueAccountId: accountId,
      currency: currency,
      amount: amount,
    );
  }


  Future<int> createAutoPurchase({
    required int accountId,
    required String currency,
    required double amount,
  }) async {
    final number = await numberService.generate(
      prefix: 'PUR',
      type: 'PURCHASE',
    );

    return createPurchase(
      number: number,
      supplierAccountId: accountId,
      inventoryAccountId: accountId,
      currency: currency,
      amount: amount,
    );
  }
}
