import 'package:flutter/material.dart';

import '../../../core/database/app_database.dart';
import '../domain/wizard/account_creation_request.dart';
import '../domain/wizard/account_creation_wizard.dart';
import '../../../core/services/accounting/accounting_link_service.dart';
import '../../../core/services/accounting/system_account_service.dart';
import '../../../core/services/numbering/account_number_generator.dart';


class AddAccountScreen extends StatefulWidget {

  final AppDatabase db;

  const AddAccountScreen({
    super.key,
    required this.db,
  });


  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}


class _AddAccountScreenState extends State<AddAccountScreen> {

  final nameController = TextEditingController();

  String type = 'CUSTOMER';


  Future<void> save() async {

    final wizard = AccountCreationWizard(
      db: widget.db,
      linkService: AccountingLinkService(
        widget.db,
        AccountNumberGenerator(widget.db),
      ),
      systemAccounts: SystemAccountService(widget.db),
    );


    await wizard.create(
      AccountCreationRequest(
        entityType: type,
        name: nameController.text,
        module: 'ACCOUNTS',
      ),
    );


    if (mounted) {
      Navigator.pop(context);
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة حساب'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'اسم الحساب',
              ),
            ),


            DropdownButton<String>(
              value: type,

              items: const [
                DropdownMenuItem(
                  value: 'CUSTOMER',
                  child: Text('عميل'),
                ),
                DropdownMenuItem(
                  value: 'SUPPLIER',
                  child: Text('مورد'),
                ),
                DropdownMenuItem(
                  value: 'BANK',
                  child: Text('بنك'),
                ),
                DropdownMenuItem(
                  value: 'WALLET',
                  child: Text('محفظة'),
                ),
              ],

              onChanged: (v){
                setState(() {
                  type = v!;
                });
              },
            ),


            ElevatedButton(
              onPressed: save,
              child: const Text('حفظ'),
            )
          ],
        ),
      ),
    );
  }
}
