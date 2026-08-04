import 'package:flutter/material.dart';

import '../../core/database/app_database.dart';

class CashBoxesScreen extends StatelessWidget {
  final AppDatabase db;

  const CashBoxesScreen({
    super.key,
    required this.db,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الصناديق')),
      body: FutureBuilder(
        future: db.select(db.cashBoxes).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final rows = snapshot.data!;

          return ListView.builder(
            itemCount: rows.length,
            itemBuilder: (_, i) {
              final row = rows[i];

              return ListTile(
                leading: const Icon(Icons.money),
                title: Text(row.nameArabic),
                subtitle: Text(row.code),
              );
            },
          );
        },
      ),
    );
  }
}
