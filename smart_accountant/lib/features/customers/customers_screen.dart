import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../core/services/master_data/master_data_service.dart';
import '../shared/master_data_screen.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});
  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final _service = GetIt.I<MasterDataService>();
  List<Map<String, dynamic>> _customers = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    final data = await _service.getAllCustomers();
    setState(() => _customers = data);
  }

  @override
  Widget build(BuildContext context) {
    return MasterDataScreen(
      title: 'العملاء',
      data: _customers,
      columnKeys: ['name', 'phone', 'address'],
      columnTitles: ['الاسم', 'الهاتف', 'العنوان'],
      onSave: (data) async {
        await _service.createCustomer(name: data['name']!, phone: data['phone'], address: data['address']);
      },
      onDelete: (id) async {
        // TODO: deleteCustomer
      },
      getItems: () => _customers,
      refresh: _load,
    );
  }
}
