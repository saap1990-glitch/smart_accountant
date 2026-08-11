import 'package:flutter/material.dart';
import '../shared/smart_operation_form.dart';
import '../../../../core/engine/accounting/transaction_context.dart';

class PurchaseScreen extends StatelessWidget {
  const PurchaseScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return SmartOperationForm(
      config: const OperationConfig(
        title: 'فاتورة شراء',
        transactionType: TransactionType.purchase,
        showPaymentType: true,
        showSupplier: true,
        showItems: true,
        showCashSource: true,
      ),
    );
  }
}
