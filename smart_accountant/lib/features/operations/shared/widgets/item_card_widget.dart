import 'package:flutter/material.dart';

class ItemCardEntry {
  String? itemId;
  String itemName;
  String? unit;
  double quantity;
  double price;
  double freeQuantity;

  ItemCardEntry({
    this.itemId,
    required this.itemName,
    this.unit,
    this.quantity = 1,
    this.price = 0,
    this.freeQuantity = 0,
  });
}

class ItemCardWidget extends StatefulWidget {
  final List<ItemCardEntry> items;
  final List<Map<String, dynamic>> availableItems;
  final bool showFreeColumn;
  final bool showPriceColumn;
  final ValueChanged<List<ItemCardEntry>> onChanged;

  const ItemCardWidget({
    super.key,
    required this.items,
    required this.availableItems,
    this.showFreeColumn = true,
    this.showPriceColumn = true,
    required this.onChanged,
  });

  @override
  State<ItemCardWidget> createState() => _ItemCardWidgetState();
}

class _ItemCardWidgetState extends State<ItemCardWidget> {
  final _itemCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _freeCtrl = TextEditingController();
  final _searchCtrl = TextEditingController();

  List<Map<String, dynamic>> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.availableItems;
  }

  void _searchItems(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.availableItems;
      } else {
        _filteredItems = widget.availableItems
            .where((item) => (item['name'] ?? '').toString().toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  double get _total {
    double total = 0;
    for (var item in widget.items) {
      total += item.quantity * item.price;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // جدول الأصناف
        if (widget.items.isNotEmpty) ...[
          const Text('الأصناف المضافة:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 12,
              columns: [
                const DataColumn(label: Text('الصنف')),
                const DataColumn(label: Text('الوحدة')),
                const DataColumn(label: Text('الكمية')),
                if (widget.showPriceColumn) const DataColumn(label: Text('السعر')),
                const DataColumn(label: Text('الإجمالي')),
                if (widget.showFreeColumn) const DataColumn(label: Text('مجاني')),
                const DataColumn(label: Text('حذف')),
              ],
              rows: widget.items.asMap().entries.map((entry) {
                final idx = entry.key;
                final item = entry.value;
                return DataRow(cells: [
                  DataCell(Text(item.itemName)),
                  DataCell(Text(item.unit ?? '-')),
                  DataCell(Text(item.quantity.toString())),
                  if (widget.showPriceColumn) DataCell(Text(item.price.toStringAsFixed(2))),
                  DataCell(Text((item.quantity * item.price).toStringAsFixed(2))),
                  if (widget.showFreeColumn) DataCell(Text(item.freeQuantity.toString())),
                  DataCell(IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                    onPressed: () {
                      widget.items.removeAt(idx);
                      widget.onChanged(widget.items);
                      setState(() {});
                    },
                  )),
                ]);
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text('الإجمالي: ${_total.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
          ),
          const Divider(),
        ],

        // إضافة صنف جديد
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Autocomplete<Map<String, dynamic>>(
                optionsBuilder: (textEditingValue) {
                  if (textEditingValue.text.isEmpty) return _filteredItems;
                  return _filteredItems.where((item) =>
                      (item['name'] ?? '').toString().toLowerCase().contains(textEditingValue.text.toLowerCase()));
                },
                displayStringForOption: (option) => '${option['name']} (${option['unit'] ?? ''})',
                fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: const InputDecoration(labelText: 'ابحث عن صنف...', isDense: true),
                    onSubmitted: (v) => onSubmitted(),
                  );
                },
                onSelected: (selected) {
                  _itemCtrl.text = selected['name'] ?? '';
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: TextField(
                controller: _qtyCtrl,
                decoration: const InputDecoration(labelText: 'الكمية', isDense: true),
                keyboardType: TextInputType.number,
              ),
            ),
            if (widget.showPriceColumn) ...[
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _priceCtrl,
                  decoration: const InputDecoration(labelText: 'السعر', isDense: true),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
            if (widget.showFreeColumn) ...[
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _freeCtrl,
                  decoration: const InputDecoration(labelText: 'مجاني', isDense: true),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.teal, size: 32),
              onPressed: () {
                if (_itemCtrl.text.isNotEmpty) {
                  final qty = double.tryParse(_qtyCtrl.text) ?? 1;
                  final price = double.tryParse(_priceCtrl.text) ?? 0;
                  final free = double.tryParse(_freeCtrl.text) ?? 0;
                  widget.items.add(ItemCardEntry(
                    itemName: _itemCtrl.text,
                    quantity: qty,
                    price: price,
                    freeQuantity: free,
                  ));
                  _itemCtrl.clear();
                  _qtyCtrl.clear();
                  _priceCtrl.clear();
                  _freeCtrl.clear();
                  widget.onChanged(widget.items);
                  setState(() {});
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
