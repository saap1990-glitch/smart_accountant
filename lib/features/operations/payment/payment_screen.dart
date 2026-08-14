import 'package:flutter/material.dart';
import '../shared/smart_operation_form.dart';
import '../../../../core/engine/accounting/transaction_context.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const SmartOperationForm(
      config: OperationConfig(
        title: 'سند صرف',
        transactionType: TransactionType.payment,
        showPaymentMode: true,
        showCashSource: true,
        showBankSource: true,
        showSupplier: true,
        showDebitAccount: true,
      ),
    );
  }
}
