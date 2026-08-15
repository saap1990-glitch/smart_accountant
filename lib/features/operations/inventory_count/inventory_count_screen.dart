import 'package:flutter/material.dart';
import '../shared/smart_operation_form.dart';
import '../../../../core/engine/accounting/transaction_context.dart';

class InventoryCountScreen extends StatelessWidget {
  const InventoryCountScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const SmartOperationForm(
      config: OperationConfig(
        title: 'تحويل مخزني',
        transactionType: TransactionType.transfer,
        showWarehouse: true,
        showDestinationWarehouse: true,
        showItems: true,
        showPrice: false,
        showFreeQty: false,
      ),
    );
  }
}
