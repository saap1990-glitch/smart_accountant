import '../../repositories/documents/document_repository.dart';

class DocumentService {
  final DocumentRepository repository;

  DocumentService(this.repository);


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
  }


  Future<int> createPurchase({
    required String number,
    required int supplierAccountId,
    required int inventoryAccountId,
    required String currency,
    required double amount,
  }) async {
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
  }
}
