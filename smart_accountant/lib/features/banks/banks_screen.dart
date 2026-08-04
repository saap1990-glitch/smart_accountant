import 'package:flutter/material.dart';

import '../../core/database/app_database.dart';

class BanksScreen extends StatelessWidget {
  final AppDatabase db;

  const BanksScreen({
    super.key,
    required this.db,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('البنوك')),
      body: FutureBuilder(
        future: db.select(db.banks).get(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final rows = snapshot.data!;

          return ListView.builder(
            itemCount: rows.length,
            itemBuilder: (_, i) {
              return ListTile(
                leading: const Icon(Icons.account_balance),
                title: Text(rows[i].nameArabic),
                subtitle: Text(rows[i].code),
              );
            },
          );
        },
      ),
    );
  }
}
