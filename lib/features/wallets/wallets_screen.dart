import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../core/services/master_data/master_data_service.dart';
import '../shared/master_data_screen.dart';

class WalletsScreen extends StatefulWidget {
  const WalletsScreen({super.key});
  @override
  State<WalletsScreen> createState() => _WalletsScreenState();
}

class _WalletsScreenState extends State<WalletsScreen> {
  final _service = GetIt.I<MasterDataService>();
  List<Map<String, dynamic>> _list = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    final data = await _service.getAllWallets();
    setState(() => _list = data);
  }

  @override
  Widget build(BuildContext context) {
    return MasterDataScreen(
      title: 'المحافظ',
      data: _list,
      columnKeys: ['name', 'provider'],
      columnTitles: ['الاسم', 'المزود'],
      onSave: (data) async {
        await _service.createWallet(name: data['name']!, provider: data['provider']);
      },
      onDelete: (id) async {},
      getItems: () => _list,
      refresh: _load,
    );
  }
}
