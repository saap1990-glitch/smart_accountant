import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('شروط الاستخدام')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text(
            'باستخدامك لهذا التطبيق فإنك توافق على الشروط التالية:\n\n'
            '1. التطبيق مخصص لأغراض محاسبية فقط.\n'
            '2. المستخدم مسؤول عن دقة البيانات المدخلة.\n'
            '3. يمنع نسخ أو إعادة توزيع التطبيق بدون إذن.\n'
            '4. نحتفظ بالحق في تعديل هذه الشروط في أي وقت.\n',
            style: TextStyle(fontSize: 16),
            textDirection: TextDirection.rtl,
          ),
        ),
      ),
    );
  }
}
