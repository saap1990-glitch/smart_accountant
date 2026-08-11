import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../core/services/master_data/master_data_service.dart';
import '../shared/master_data_screen.dart';

class ExchangeCompaniesScreen extends StatefulWidget {
  const ExchangeCompaniesScreen({super.key});
  @override
  State<ExchangeCompaniesScreen> createState() => _ExchangeCompaniesScreenState();
}

class _ExchangeCompaniesScreenState extends State<ExchangeCompaniesScreen> {
  final _service = GetIt.I<MasterDataService>();
  List<Map<String, dynamic>> _list = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    final data = await _service.getAllExchangeCompanies();
    setState(() => _list = data);
  }

  @override
  Widget build(BuildContext context) {
    return MasterDataScreen(
      title: 'شركات الصرافة',
      data: _list,
      columnKeys: ['name', 'phone'],
      columnTitles: ['الاسم', 'الهاتف'],
      onSave: (data) async {
        await _service.createExchangeCompany(name: data['name']!, phone: data['phone']);
      },
      onDelete: (id) async {},
      getItems: () => _list,
      refresh: _load,
    );
  }
}
