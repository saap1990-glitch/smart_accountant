import 'package:flutter/material.dart';
import '../shared/smart_operation_form.dart';
import '../../../../core/engine/accounting/transaction_context.dart';

class PurchaseReturnScreen extends StatelessWidget {
  const PurchaseReturnScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return SmartOperationForm(
      config: const OperationConfig(
        title: 'مرتجع شراء',
        transactionType: TransactionType.purchase,
        showSupplier: true,
        showItems: true,
        isReturn: true,
      ),
    );
  }
}
