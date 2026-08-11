import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../core/services/master_data/master_data_service.dart';
import '../shared/master_data_screen.dart';

class UnitsScreen extends StatefulWidget {
  const UnitsScreen({super.key});
  @override
  State<UnitsScreen> createState() => _UnitsScreenState();
}

class _UnitsScreenState extends State<UnitsScreen> {
  final _service = GetIt.I<MasterDataService>();
  List<Map<String, dynamic>> _list = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    final data = await _service.getAllUnits();
    setState(() => _list = data);
  }

  @override
  Widget build(BuildContext context) {
    return MasterDataScreen(
      title: 'الوحدات',
      data: _list,
      columnKeys: ['name', 'abbreviation'],
      columnTitles: ['الاسم', 'الاختصار'],
      onSave: (data) async {
        await _service.createUnit(name: data['name']!, abbreviation: data['abbreviation']);
      },
      onDelete: (id) async {},
      getItems: () => _list,
      refresh: _load,
    );
  }
}
