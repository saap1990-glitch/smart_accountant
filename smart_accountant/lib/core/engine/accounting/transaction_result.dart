class TransactionResult {
  final bool success;

  final String message;

  final int? journalId;

  const TransactionResult({
    required this.success,

    required this.message,

    this.journalId,
  });
}
