class AppException implements Exception {
  const AppException(this.message, {this.code, this.cause});
  final String message;
  final String? code;
  final Object? cause;

  @override
  String toString() => 'AppException($code): $message';
}

class ValidationException extends AppException {
  const ValidationException(super.message, {super.code});
}

class DatabaseException extends AppException {
  const DatabaseException(super.message, {super.code});
}

class AccountingException extends AppException {
  const AccountingException(super.message, {super.code});
}
