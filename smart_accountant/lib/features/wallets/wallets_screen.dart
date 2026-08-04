import 'package:flutter/material.dart';

import '../../core/database/app_database.dart';

class WalletsScreen extends StatelessWidget {
  final AppDatabase db;

  const WalletsScreen({
    super.key,
    required this.db,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المحافظ الإلكترونية')),
      body: FutureBuilder(
        future: db.select(db.wallets).get(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final rows = snapshot.data!;

          return ListView.builder(
            itemCount: rows.length,
            itemBuilder: (_, i) {
              final wallet = rows[i];

              return ListTile(
                leading: const Icon(Icons.account_balance_wallet),
                title: Text(wallet.nameArabic),
                subtitle: Text(wallet.provider),
              );
            },
          );
        },
      ),
    );
  }
}
