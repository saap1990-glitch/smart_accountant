import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سند صرف'),
      ),
      body: const Center(
        child: Text('إنشاء سند صرف'),
      ),
    );
  }
}
