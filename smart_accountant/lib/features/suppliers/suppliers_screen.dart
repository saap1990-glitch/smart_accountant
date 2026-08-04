import 'package:flutter/material.dart';

import '../../core/database/app_database.dart';

class SuppliersScreen extends StatelessWidget {
  final AppDatabase db;

  const SuppliersScreen({
    super.key,
    required this.db,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الموردون')),
      body: FutureBuilder(
        future: db.select(db.suppliers).get(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final rows = snapshot.data!;

          return ListView.builder(
            itemCount: rows.length,
            itemBuilder: (_, i) {
              final supplier = rows[i];

              return ListTile(
                leading: const Icon(Icons.local_shipping),
                title: Text(supplier.name),
                subtitle: Text(supplier.code),
              );
            },
          );
        },
      ),
    );
  }
}
