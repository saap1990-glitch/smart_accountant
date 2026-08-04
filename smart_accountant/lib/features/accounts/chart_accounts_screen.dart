import 'package:flutter/material.dart';

import '../../core/database/app_database.dart';

class ChartAccountsScreen extends StatelessWidget {
  final AppDatabase db;

  const ChartAccountsScreen({
    super.key,
    required this.db,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('دليل الحسابات'),
      ),
      body: FutureBuilder(
        future: db.select(db.accounts).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final accounts = snapshot.data!;

          if (accounts.isEmpty) {
            return const Center(
              child: Text('لا توجد حسابات'),
            );
          }

          return ListView.builder(
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              final account = accounts[index];

              return ListTile(
                leading: const Icon(Icons.account_tree),
                title: Text(account.nameArabic),
                subtitle: Text(
                  '${account.accountNumber} - المستوى ${account.level}',
                ),
                trailing: account.allowPosting
                    ? const Icon(Icons.edit)
                    : const Icon(Icons.folder),
              );
            },
          );
        },
      ),
    );
  }
}
