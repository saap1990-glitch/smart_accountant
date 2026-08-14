import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../core/services/master_data/master_data_service.dart';
import '../shared/master_data_screen.dart';

class CashBoxesScreen extends StatefulWidget {
  const CashBoxesScreen({super.key});
  @override
  State<CashBoxesScreen> createState() => _CashBoxesScreenState();
}

class _CashBoxesScreenState extends State<CashBoxesScreen> {
  final _service = GetIt.I<MasterDataService>();
  List<Map<String, dynamic>> _list = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    final data = await _service.getAllCashBoxes();
    setState(() => _list = data);
  }

  @override
  Widget build(BuildContext context) {
    return MasterDataScreen(
      title: 'الصناديق',
      data: _list,
      columnKeys: ['name'],
      columnTitles: ['الاسم'],
      onSave: (data) async {
        await _service.createCashBox(name: data['name']!);
      },
      onDelete: (id) async {},
      getItems: () => _list,
      refresh: _load,
    );
  }
}
