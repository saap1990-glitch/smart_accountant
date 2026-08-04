import 'package:flutter/material.dart';

import '../core/database/app_database.dart';
import '../core/routes/app_routes.dart';

class SmartAccountantApp extends StatelessWidget {
  const SmartAccountantApp({super.key});

  @override
  Widget build(BuildContext context) {
    final db = AppDatabase();

    return MaterialApp(
      title: 'Smart Accountant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Cairo',
      ),
      routes: AppRoutes.routes(db: db),
      initialRoute: '/',
    );
  }
}
