import '../models/accounting_entry.dart';
import 'validation_result.dart';

class AccountingValidator {
  ValidationResult validate(AccountingEntry entry) {
    final errors = <String>[];

    if (entry.lines.length < 2) {
      errors.add('يجب أن يحتوي القيد على سطرين على الأقل.');
    }

    if (!entry.isBalanced) {
      errors.add('القيد غير متوازن.');
    }

    for (final line in entry.lines) {
      if (line.debit < 0 || line.credit < 0) {
        errors.add('لا يسمح بالقيم السالبة.');
      }

      if (line.debit > 0 && line.credit > 0) {
        errors.add('لا يمكن أن يكون السطر مدينًا ودائنًا معًا.');
      }

      if (line.debit == 0 && line.credit == 0) {
        errors.add('يجب أن يحتوي السطر على مبلغ مدين أو دائن.');
      }
    }

    if (errors.isEmpty) {
      return ValidationResult.success();
    }

    return ValidationResult.failure(errors);
  }
}
