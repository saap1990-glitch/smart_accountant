import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../core/services/master_data/master_data_service.dart';
import '../shared/master_data_screen.dart';

class CurrenciesScreen extends StatefulWidget {
  const CurrenciesScreen({super.key});
  @override
  State<CurrenciesScreen> createState() => _CurrenciesScreenState();
}

class _CurrenciesScreenState extends State<CurrenciesScreen> {
  final _service = GetIt.I<MasterDataService>();
  List<Map<String, dynamic>> _list = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    final data = await _service.getAllCurrencies();
    setState(() => _list = data);
  }

  @override
  Widget build(BuildContext context) {
    return MasterDataScreen(
      title: 'العملات',
      data: _list,
      columnKeys: ['code', 'name'],
      columnTitles: ['الرمز', 'الاسم'],
      onSave: (data) async {
        await _service.createCurrency(code: data['code']!, name: data['name']!);
      },
      onDelete: (id) async {},
      getItems: () => _list,
      refresh: _load,
    );
  }
}
