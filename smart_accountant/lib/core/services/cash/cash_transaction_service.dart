import '../accounting/document_service.dart';

class CashTransactionService {

  final DocumentService documents;

  CashTransactionService(this.documents);


  Future<int> receipt({
    required int accountId,
    required String currency,
    required double amount,
  }) {

    return documents.createAutoReceipt(
      accountId: accountId,
      currency: currency,
      amount: amount,
    );
  }


  Future<int> payment({
    required int accountId,
    required String currency,
    required double amount,
  }) {

    return documents.createAutoPayment(
      accountId: accountId,
      currency: currency,
      amount: amount,
    );
  }
}
