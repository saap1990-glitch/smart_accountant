class AccountingException implements Exception {
  final String message;
  final String? code;

  const AccountingException(this.message, {this.code});

  @override
  String toString() {
    if (code == null) {
      return message;
    }

    return '[$code] $message';
  }
}
