import 'package:flutter/material.dart';
import 'app/app.dart';
import 'core/di/service_locator.dart';
import 'core/services/accounting/accounting_link_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await setupServiceLocator();
    // زرع الحسابات الافتراضية
    final linkService = sl<AccountingLinkService>();
    await linkService.seedDefaultAccounts();
  } catch (e) {
    runApp(MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.red,
        body: Center(child: Text('خطأ في التهيئة: $e', style: const TextStyle(color: Colors.white, fontSize: 18))),
      ),
    ));
    return;
  }

  runApp(const SmartAccountantApp());
}
