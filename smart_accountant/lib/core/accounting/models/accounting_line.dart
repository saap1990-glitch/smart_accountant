class AccountingLine {
  final int accountId;
  final String currencyCode;
  final double exchangeRate;
  final double debit;
  final double credit;
  final String description;

  const AccountingLine({
    required this.accountId,
    required this.currencyCode,
    required this.exchangeRate,
    required this.debit,
    required this.credit,
    this.description = '',
  });

  bool get isDebit => debit > 0;

  bool get isCredit => credit > 0;

  double get amount => isDebit ? debit : credit;
}
