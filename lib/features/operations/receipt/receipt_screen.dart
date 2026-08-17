import 'package:flutter/material.dart';
import '../shared/smart_operation_form.dart';
import '../../../core/engine/accounting/transaction_context.dart';

class ReceiptScreen extends StatelessWidget {
  const ReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SmartOperationForm(
      config: OperationConfig(
        title: 'سند قبض',
        transactionType: TransactionType.receipt,
        showPaymentMode: true,
        showCashSource: true,
        showBankSource: true,
        showCreditAccount: true,
      ),
    );
  }
}
