class ValidationResult {
  final bool isValid;
  final List<String> errors;
  const ValidationResult({required this.isValid, this.errors = const []});

  factory ValidationResult.success() => const ValidationResult(isValid: true);
  factory ValidationResult.failure(List<String> errors) => ValidationResult(isValid: false, errors: errors);
}
