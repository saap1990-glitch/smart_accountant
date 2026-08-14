import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('سياسة الخصوصية')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text(
            'نحن نأخذ خصوصيتك على محمل الجد. لا نقوم بجمع أي معلومات شخصية من جهازك. '
            'جميع البيانات المالية يتم تخزينها محليًا على جهازك فقط ولا يتم مشاركتها مع أي طرف ثالث.\n\n'
            'نستخدم تشفيرًا قويًا لحماية بياناتك. لا يمكن لأي شخص الوصول إليها بدون إذنك.',
            style: TextStyle(fontSize: 16),
            textDirection: TextDirection.rtl,
          ),
        ),
      ),
    );
  }
}
