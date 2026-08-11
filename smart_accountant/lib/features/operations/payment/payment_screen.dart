import 'package:flutter/material.dart';
import '../shared/smart_operation_form.dart';
import '../../../../core/engine/accounting/transaction_context.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return SmartOperationForm(
      config: const OperationConfig(
        title: 'سند صرف',
        transactionType: TransactionType.payment,
        amountLabel: 'المبلغ المدفوع',
        showPaymentType: true,
        showSupplier: true,
        showCashSource: true,
      ),
    );
  }
}
