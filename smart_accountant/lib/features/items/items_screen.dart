import 'package:flutter/material.dart';

import '../../core/database/app_database.dart';

class ItemsScreen extends StatelessWidget {
  final AppDatabase db;

  const ItemsScreen({
    super.key,
    required this.db,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الأصناف')),
      body: FutureBuilder(
        future: db.select(db.items).get(),
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
              final item = rows[i];

              return ListTile(
                leading: const Icon(Icons.inventory),
                title: Text(item.name),
                subtitle: Text(item.code),
              );
            },
          );
        },
      ),
    );
  }
}
