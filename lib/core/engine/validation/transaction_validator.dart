import 'validation_result.dart';
import '../accounting/transaction_context.dart';

abstract class TransactionValidator {
  ValidationResult validate(TransactionContext context);
}

class DefaultTransactionValidator implements TransactionValidator {
  @override
  ValidationResult validate(TransactionContext context) {
    final errors = <String>[];

    if (context.items.isEmpty) {
      errors.add('يجب إضافة بند واحد على الأقل');
    }

    double totalDebit = 0;
    double totalCredit = 0;
    for (final item in context.items) {
      if (item.accountId <= 0) {
        errors.add('رقم الحساب غير صالح');
      }
      if (item.debit < 0 || item.credit < 0) {
        errors.add('لا يمكن إدخال قيم سالبة');
      }
      totalDebit += item.debit;
      totalCredit += item.credit;
    }

    if ((totalDebit - totalCredit).abs() > 0.001) {
      errors.add('يجب أن يتساوى مجموع المدين والدائن');
    }

    if (totalDebit == 0 && totalCredit == 0) {
      errors.add('لا يمكن أن تكون جميع المبالغ صفراً');
    }

    return errors.isEmpty
        ? ValidationResult.success()
        : ValidationResult.failure(errors);
  }
}
