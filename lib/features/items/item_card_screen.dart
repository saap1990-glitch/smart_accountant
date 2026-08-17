import 'package:flutter/material.dart';

class ItemCardScreen extends StatelessWidget {
  final Map<String, dynamic> item;

  const ItemCardScreen({super.key, required this.item});

  String _text(String key, [String fallback = '—']) {
    final value = item[key];
    if (value == null || '$value'.trim().isEmpty) return fallback;
    return '$value';
  }

  String _money(String key) {
    final value = item[key];
    if (value == null) return '0';
    return '$value';
  }

  @override
  Widget build(BuildContext context) {
    final isService = item['is_service'] == true;
    final isActive = item['is_active'] != false;

    return Scaffold(
      appBar: AppBar(title: const Text('بطاقة الصنف')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _header(context, isService, isActive),
          const SizedBox(height: 16),
          _section('البيانات الأساسية', [
            _row('رقم الصنف', _text('code')),
            _row('اسم الصنف', _text('name')),
            _row('الاسم بالإنجليزية', _text('name_en')),
            _row('نوع الصنف', isService ? 'خدمة' : 'صنف مخزني'),
            _row('التصنيف', _text('category')),
            _row('الوحدة', _text('unit')),
          ]),
          const SizedBox(height: 12),
          _section('الأسعار', [
            _row('تكلفة الشراء', _money('cost')),
            _row(isService ? 'سعر الخدمة' : 'سعر البيع', _money('price')),
          ]),
          if (!isService) ...[
            const SizedBox(height: 12),
            _section('المخزون', [
              _row('الرصيد الافتتاحي', _money('opening_quantity')),
              _row('الحد الأدنى', _money('minimum_quantity')),
              _row('الحد الأعلى', _money('maximum_quantity')),
            ]),
          ],
          const SizedBox(height: 12),
          _section('الترميز والتعريف', [
            _row('الباركود', _text('barcode')),
            _row('SKU', _text('sku')),
          ]),
          const SizedBox(height: 12),
          _section('الوصف والملاحظات', [
            _row('الوصف', _text('description')),
            _row('ملاحظات', _text('notes')),
          ]),
          const SizedBox(height: 12),
          _section('الحالة', [
            _row('حالة الصنف', isActive ? 'نشط' : 'متوقف'),
            _row('نوع الاستخدام', isService ? 'خدمة' : 'مخزون'),
          ]),
          const SizedBox(height: 24),
          _actions(context),
        ],
      ),
    );
  }

  Widget _header(BuildContext context, bool isService, bool isActive) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              child: Icon(
                isService ? Icons.miscellaneous_services : Icons.inventory_2,
                size: 30,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _text('name'),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _text('code'),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 6),
                  Chip(label: Text(isActive ? 'نشط' : 'متوقف')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 135,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _actions(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('سيتم ربط حركة المخزون في المرحلة التالية'),
                ),
              );
            },
            icon: const Icon(Icons.swap_vert),
            label: const Text('حركات المخزون'),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('سيتم ربط التقارير في المرحلة التالية'),
                ),
              );
            },
            icon: const Icon(Icons.analytics_outlined),
            label: const Text('تقارير الصنف'),
          ),
        ),
      ],
    );
  }
}
