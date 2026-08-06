import 'package:flutter/material.dart';

import '../../core/database/app_database.dart';
import 'domain/services/account_service.dart';
import 'domain/tree/account_tree_engine.dart';
import 'screens/add_account_screen.dart';

class ChartAccountsScreen extends StatelessWidget {

  final AppDatabase db;

  const ChartAccountsScreen({
    super.key,
    required this.db,
  });


  @override
  Widget build(BuildContext context) {

    final service = AccountService(db);
    final tree = AccountTreeEngine(db);


    return Scaffold(

      appBar: AppBar(
        title: const Text('دليل الحسابات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddAccountScreen(
                    db: db,
                  ),
                ),
              );
            },
          ),
        ],
      ),


      body: FutureBuilder(

        future: service.getTree(),

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

            itemBuilder: (context,index){

              final account = accounts[index];


              return ListTile(

                leading: Icon(
                  account.allowPosting
                  ? Icons.account_balance
                  : Icons.folder,
                ),


                title: Text(
                  account.nameArabic,
                ),


                subtitle: Text(
                  '${account.accountNumber} - المستوى ${account.level}',
                ),


                trailing: Icon(
                  account.allowPosting
                  ? Icons.edit
                  : Icons.chevron_right,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
