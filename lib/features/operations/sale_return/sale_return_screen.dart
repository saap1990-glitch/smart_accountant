import 'package:flutter/material.dart';
import '../shared/smart_operation_form.dart';
import '../../../../core/engine/accounting/transaction_context.dart';

class SaleReturnScreen extends StatelessWidget {
  const SaleReturnScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const SmartOperationForm(
      config: OperationConfig(
        title: 'مرتجع بيع',
        transactionType: TransactionType.sale,
        showCustomer: true,
        showInvoiceNumber: true,
        showWarehouse: true,
        showItems: true,
        showPrice: true,
        showFreeQty: true,
        isReturn: true,
      ),
    );
  }
}
