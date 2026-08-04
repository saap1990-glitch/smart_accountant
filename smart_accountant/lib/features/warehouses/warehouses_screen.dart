import 'package:flutter/material.dart';

import '../../core/database/app_database.dart';

class WarehousesScreen extends StatelessWidget {
  final AppDatabase db;

  const WarehousesScreen({
    super.key,
    required this.db,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المخازن')),
      body: FutureBuilder(
        future: db.select(db.warehouses).get(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final rows = snapshot.data!;

          return ListView.builder(
            itemCount: rows.length,
            itemBuilder: (_, i) {
              final warehouse = rows[i];

              return ListTile(
                leading: const Icon(Icons.warehouse),
                title: Text(warehouse.name),
                subtitle: Text(warehouse.code),
              );
            },
          );
        },
      ),
    );
  }
}
