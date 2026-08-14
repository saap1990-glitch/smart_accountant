import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../core/services/inventory/item_movement_service.dart';

class ItemCardScreen extends StatefulWidget {
  final String itemName;
  const ItemCardScreen({super.key, required this.itemName});

  @override
  State<ItemCardScreen> createState() => _ItemCardScreenState();
}

class _ItemCardScreenState extends State<ItemCardScreen> {
  late Map<String, dynamic> _card;

  @override
  void initState() {
    super.initState();
    final service = GetIt.I<ItemMovementService>();
    _card = service.getItemCard(widget.itemName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('كرت صنف: ${widget.itemName}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _row('المشتريات', _card['purchases'].toString()),
                  _row('المبيعات', _card['sales'].toString()),
                  _row('المرتجعات', _card['returns'].toString()),
                  _row('التسويات', _card['adjustments'].toString()),
                  const Divider(),
                  _row('الرصيد', _card['balance'].toString(), bold: true),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('حركات الصنف', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ...(_card['movements'] as List).map((m) => ListTile(
            title: Text(m.reference ?? m.operationType),
            subtitle: Text('${m.date.toLocal()}'.split(' ')[0]),
            trailing: Text('${m.quantity}'),
          )),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
