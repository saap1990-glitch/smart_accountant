import 'package:flutter/material.dart';

class ItemCardEntry {
  String? itemId;
  String itemName;
  String? unit;
  double quantity;
  double price;
  double freeQuantity;
  double discount;

  ItemCardEntry({
    this.itemId,
    required this.itemName,
    this.unit,
    this.quantity = 1,
    this.price = 0,
    this.freeQuantity = 0,
    this.discount = 0,
  });
}

class ItemCardWidget extends StatefulWidget {
  final List<ItemCardEntry> items;
  final List<Map<String, dynamic>> availableItems;
  final bool showPriceColumn;
  final bool showFreeColumn;
  final ValueChanged<List<ItemCardEntry>> onChanged;

  const ItemCardWidget({
    super.key,
    required this.items,
    required this.availableItems,
    this.showPriceColumn = true,
    this.showFreeColumn = true,
    required this.onChanged,
  });

  @override
  State<ItemCardWidget> createState() => _ItemCardWidgetState();
}

class _ItemCardWidgetState extends State<ItemCardWidget> {
  final _searchCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _freeCtrl = TextEditingController();
  final _discountCtrl = TextEditingController();
  Map<String, dynamic>? _selectedItem;

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
        _filteredItems = widget.availableItems.where((item) => (item['name'] ?? '').toString().toLowerCase().contains(query.toLowerCase())).toList();
      }
    });
  }

  double get _total {
    double total = 0;
    for (var item in widget.items) {
      total += item.quantity * item.price - item.discount;
    }
    return total;
  }

  void _addItem() {
    if (_selectedItem == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اختر صنفاً أولاً')));
      return;
    }
    final qty = double.tryParse(_qtyCtrl.text) ?? 1;
    final price = double.tryParse(_priceCtrl.text) ?? double.tryParse(_selectedItem!['price']?.toString() ?? '0') ?? 0;
    final free = double.tryParse(_freeCtrl.text) ?? 0;
    final discount = double.tryParse(_discountCtrl.text) ?? 0;

    widget.items.add(ItemCardEntry(
      itemId: _selectedItem!['id']?.toString(),
      itemName: _selectedItem!['name'] ?? '',
      unit: _selectedItem!['unit'] ?? '',
      quantity: qty,
      price: price,
      freeQuantity: free,
      discount: discount,
    ));
    widget.onChanged(widget.items);
    setState(() {
      _selectedItem = null;
      _qtyCtrl.clear();
      _priceCtrl.clear();
      _freeCtrl.clear();
      _discountCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.items.isNotEmpty) ...[
          const Text('الأصناف المضافة:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...widget.items.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                leading: CircleAvatar(backgroundColor: Colors.teal.withOpacity(0.1), child: const Icon(Icons.inventory, color: Colors.teal)),
                title: Text(item.itemName, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('الكمية: ${item.quantity} | السعر: ${item.price} | الإجمالي: ${(item.quantity * item.price - item.discount).toStringAsFixed(2)}'),
                trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () { widget.items.removeAt(idx); widget.onChanged(widget.items); setState(() {}); }),
              ),
            );
          }),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text('الإجمالي: ${_total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
          ),
          const Divider(),
        ],

        // قسم إضافة صنف
        const Text('إضافة صنف جديد:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),

        // اختيار الصنف
        Autocomplete<Map<String, dynamic>>(
          displayStringForOption: (option) => '${option['name']} (${option['unit'] ?? ''})',
          optionsBuilder: (textEditingValue) {
            if (textEditingValue.text.isEmpty) return _filteredItems.take(15);
            return _filteredItems.where((item) => (item['name'] ?? '').toString().toLowerCase().contains(textEditingValue.text.toLowerCase())).take(15);
          },
          onSelected: (selected) {
            setState(() {
              _selectedItem = selected;
              _priceCtrl.text = selected['price']?.toString() ?? '0';
            });
          },
          fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: const InputDecoration(labelText: '🔍 ابحث عن الصنف', border: OutlineInputBorder(), prefixIcon: Icon(Icons.search)),
              onSubmitted: (v) => onSubmitted(),
            );
          },
        ),
        const SizedBox(height: 12),

        // حقول الكمية والسعر
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _qtyCtrl,
                decoration: const InputDecoration(labelText: 'الكمية', border: OutlineInputBorder(), hintText: 'أدخل الكمية'),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 8),
            if (widget.showPriceColumn)
              Expanded(
                child: TextField(
                  controller: _priceCtrl,
                  decoration: const InputDecoration(labelText: 'السعر', border: OutlineInputBorder(), hintText: 'سعر الوحدة'),
                  keyboardType: TextInputType.number,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (widget.showFreeColumn)
          TextField(
            controller: _freeCtrl,
            decoration: const InputDecoration(labelText: 'الكمية المجانية', border: OutlineInputBorder(), hintText: '0 = لا يوجد مجاني'),
            keyboardType: TextInputType.number,
          ),
        const SizedBox(height: 8),
        TextField(
          controller: _discountCtrl,
          decoration: const InputDecoration(labelText: 'الخصم (مبلغ)', border: OutlineInputBorder(), hintText: '0 = لا يوجد خصم'),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('إضافة الصنف'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
            onPressed: _addItem,
          ),
        ),
      ],
    );
  }
}
