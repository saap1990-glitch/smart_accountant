class TransactionContext {
  final String type;

  final DateTime date;

  final String currency;

  final double exchangeRate;

  final Map<String, dynamic> data;

  const TransactionContext({
    required this.type,

    required this.date,

    required this.currency,

    required this.exchangeRate,

    required this.data,
  });
}
