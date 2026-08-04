class AccountingResult<T> {
  final bool success;
  final T? data;
  final String? message;

  const AccountingResult({required this.success, this.data, this.message});

  factory AccountingResult.success(T data) {
    return AccountingResult(success: true, data: data);
  }

  factory AccountingResult.failure(String message) {
    return AccountingResult(success: false, message: message);
  }
}
