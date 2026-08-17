import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../core/services/master_data/master_data_service.dart';

class ExchangeCompaniesScreen extends StatefulWidget {
  const ExchangeCompaniesScreen({super.key});

  @override
  State<ExchangeCompaniesScreen> createState() =>
      _ExchangeCompaniesScreenState();
}

class _ExchangeCompaniesScreenState extends State<ExchangeCompaniesScreen> {
  final _service = GetIt.I<MasterDataService>();
  final _search = TextEditingController();

  List<Map<String, dynamic>> _companies = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    if (mounted) setState(() => _loading = true);

    try {
      final data = await _service.getAllExchangeCompanies();

      if (!mounted) return;

      setState(() {
        _companies = data;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() => _loading = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تعذر تحميل شركات الصرافة')));
    }
  }

  List<Map<String, dynamic>> get _filtered {
    final q = _search.text.trim().toLowerCase();

    if (q.isEmpty) return _companies;

    return _companies.where((company) {
      final name = '${company['name'] ?? ''}'.toLowerCase();
      final phone = '${company['phone'] ?? ''}'.toLowerCase();
      final address = '${company['address'] ?? ''}'.toLowerCase();

      return name.contains(q) || phone.contains(q) || address.contains(q);
    }).toList();
  }

  Future<void> _showForm() async {
    final name = TextEditingController();
    final phone = TextEditingController();
    final address = TextEditingController();

    try {
      final saved = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('إضافة شركة صرافة'),
          content: SizedBox(
            width: 450,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: name,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'اسم الشركة *',
                      prefixIcon: Icon(Icons.currency_exchange),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: phone,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'رقم الهاتف',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: address,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'العنوان',
                      prefixIcon: Icon(Icons.location_on),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('إلغاء'),
            ),
            FilledButton.icon(
              onPressed: () async {
                final value = name.text.trim();

                if (value.isEmpty) return;

                await _service.createExchangeCompany(
                  name: value,
                  phone: phone.text.trim().isEmpty ? null : phone.text.trim(),
                );

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext, true);
                }
              },
              icon: const Icon(Icons.save),
              label: const Text('حفظ'),
            ),
          ],
        ),
      );

      if (saved == true && mounted) {
        await _load();
      }
    } finally {
      name.dispose();
      phone.dispose();
      address.dispose();
    }
  }

  Future<void> _delete(Map<String, dynamic> company) async {
    final id = company['id'];

    if (id is! int) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف شركة الصرافة'),
        content: Text('هل تريد حذف "${company['name'] ?? ''}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _service.deleteExchangeCompany(id);

      if (!mounted) return;

      await _load();
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا يمكن حذف الشركة المرتبطة بعمليات')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final companies = _filtered;

    return Scaffold(
      appBar: AppBar(
        title: const Text('شركات الصرافة'),
        actions: [
          IconButton(
            onPressed: _load,
            tooltip: 'تحديث',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showForm,
        icon: const Icon(Icons.add),
        label: const Text('إضافة شركة'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _search,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: 'بحث ذكي',
                hintText: 'اسم الشركة أو الهاتف أو العنوان...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _search.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _search.clear();
                          setState(() {});
                        },
                        icon: const Icon(Icons.clear),
                      ),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : companies.isEmpty
                ? _empty()
                : RefreshIndicator(
                    onRefresh: _load,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100),
                      itemCount: companies.length,
                      itemBuilder: (_, index) {
                        final company = companies[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.currency_exchange),
                            ),
                            title: Text(
                              '${company['name'] ?? ''}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: _subtitle(company),
                            trailing: IconButton(
                              tooltip: 'حذف',
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => _delete(company),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _subtitle(Map<String, dynamic> company) {
    final phone = '${company['phone'] ?? ''}'.trim();
    final address = '${company['address'] ?? ''}'.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (phone.isNotEmpty) Text('الهاتف: $phone'),
        if (address.isNotEmpty) Text('العنوان: $address'),
        const Text('حساب شركة صرافة'),
      ],
    );
  }

  Widget _empty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.currency_exchange, size: 64),
          const SizedBox(height: 12),
          const Text(
            'لا توجد شركات صرافة',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _showForm,
            icon: const Icon(Icons.add),
            label: const Text('إضافة أول شركة'),
          ),
        ],
      ),
    );
  }
}
