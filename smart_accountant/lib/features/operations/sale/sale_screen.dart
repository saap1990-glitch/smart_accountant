import 'package:flutter/material.dart';
import '../shared/smart_operation_form.dart';
import '../../../../core/engine/accounting/transaction_context.dart';

class SaleScreen extends StatelessWidget {
  const SaleScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return SmartOperationForm(
      config: const OperationConfig(
        title: 'فاتورة بيع',
        transactionType: TransactionType.sale,
        showPaymentType: true,
        showCustomer: true,
        showItems: true,
        showCashSource: true,
      ),
    );
  }
}
