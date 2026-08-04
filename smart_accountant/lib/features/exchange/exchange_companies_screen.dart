import 'package:flutter/material.dart';

import '../../core/database/app_database.dart';

class ExchangeCompaniesScreen extends StatelessWidget {
  final AppDatabase db;

  const ExchangeCompaniesScreen({
    super.key,
    required this.db,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('شركات الصرافة')),
      body: FutureBuilder(
        future: db.select(db.exchangeCompanies).get(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final rows = snapshot.data!;

          return ListView.builder(
            itemCount: rows.length,
            itemBuilder: (_, i) {
              final company = rows[i];

              return ListTile(
                leading: const Icon(Icons.currency_exchange),
                title: Text(company.nameArabic),
                subtitle: Text(company.code),
              );
            },
          );
        },
      ),
    );
  }
}
