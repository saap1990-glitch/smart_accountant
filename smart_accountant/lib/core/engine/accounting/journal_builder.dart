class JournalLine {
  final int accountId;

  final double debit;

  final double credit;

  final String description;

  const JournalLine({
    required this.accountId,

    this.debit = 0,

    this.credit = 0,

    required this.description,
  });
}

class JournalBuilder {
  final List<JournalLine> _lines = [];

  void addLine({
    required int accountId,

    double debit = 0,

    double credit = 0,

    required String description,
  }) {
    _lines.add(
      JournalLine(
        accountId: accountId,

        debit: debit,

        credit: credit,

        description: description,
      ),
    );
  }

  List<JournalLine> get lines => List.unmodifiable(_lines);

  bool isBalanced() {
    final debit = _lines.fold<double>(0, (sum, line) => sum + line.debit);

    final credit = _lines.fold<double>(0, (sum, line) => sum + line.credit);

    return debit == credit;
  }
}
