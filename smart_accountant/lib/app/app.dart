import 'package:flutter/material.dart';

class SmartAccountantApp extends StatelessWidget {
  const SmartAccountantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Accountant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, fontFamily: 'Cairo'),
      home: const Scaffold(body: Center(child: Text('دفتر المحاسب الذكي'))),
    );
  }
}
