import 'package:flutter/material.dart';
import '../shared/smart_operation_form.dart';
import '../../../core/engine/accounting/transaction_context.dart';

class PurchaseReturnScreen extends StatelessWidget {
  const PurchaseReturnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SmartOperationForm(
      config: OperationConfig(
        title: 'مرتجع مشتريات',
        transactionType: TransactionType.purchase,
        showSupplier: true,
        showInvoiceNumber: true,
        showWarehouse: true,
        showItems: true,
        showPrice: true,
        showFreeQty: true,
        isReturn: true,
        isInventoryOut: true,
      ),
    );
  }
}
