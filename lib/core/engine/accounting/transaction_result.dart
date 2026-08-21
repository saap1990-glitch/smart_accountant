enum TransactionStatus { draft, approved, posted, cancelled }

class TransactionResult {

  const TransactionResult({this.entryNumber, required this.status, this.message});

  factory TransactionResult.success(String entryNumber) => TransactionResult(
        entryNumber: entryNumber,
        status: TransactionStatus.posted,
        message: 'تم ترحيل العملية بنجاح',
      );

  factory TransactionResult.draft() => const TransactionResult(
        status: TransactionStatus.draft,
        message: 'تم الحفظ كمسودة',
      );

  factory TransactionResult.cancelled() => const TransactionResult(
        status: TransactionStatus.cancelled,
        message: 'تم إلغاء العملية',
      );
  final String? entryNumber;
  final TransactionStatus status;
  final String? message;
}
