import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../core/services/master_data/master_data_service.dart';
import '../shared/master_data_screen.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});
  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  final _service = GetIt.I<MasterDataService>();
  List<Map<String, dynamic>> _list = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    final data = await _service.getAllItems();
    setState(() => _list = data);
  }

  @override
  Widget build(BuildContext context) {
    return MasterDataScreen(
      title: 'الأصناف',
      data: _list,
      columnKeys: ['name', 'unit', 'cost', 'price'],
      columnTitles: ['الاسم', 'الوحدة', 'التكلفة', 'سعر البيع'],
      onSave: (data) async {
        await _service.createItem(
          name: data['name']!,
          unit: data['unit']!,
          cost: double.tryParse(data['cost'] ?? '0'),
          price: double.tryParse(data['price'] ?? '0'),
        );
      },
      onDelete: (id) async {},
      getItems: () => _list,
      refresh: _load,
    );
  }
}
