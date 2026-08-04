import 'package:flutter/material.dart';

import '../../core/database/app_database.dart';

class CustomersScreen extends StatelessWidget {
  final AppDatabase db;

  const CustomersScreen({
    super.key,
    required this.db,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('العملاء')),
      body: FutureBuilder(
        future: db.select(db.customers).get(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final rows = snapshot.data!;

          return ListView.builder(
            itemCount: rows.length,
            itemBuilder: (_, i) {
              final customer = rows[i];

              return ListTile(
                leading: const Icon(Icons.person),
                title: Text(customer.name),
                subtitle: Text(customer.code),
              );
            },
          );
        },
      ),
    );
  }
}
