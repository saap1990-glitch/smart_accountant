import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../core/services/reports/report_service.dart';
import 'report_view_screen.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reportService = GetIt.I<ReportService>();
    return Scaffold(
      appBar: AppBar(title: const Text('التقارير')),
      body: ListView(
        children: [
          _buildSection('التقارير المالية', [
            _ReportTile('الأستاذ العام', onTap: () async {
              final data = await reportService.generalLedger(
                accountId: 1, from: DateTime(2026,1,1), to: DateTime(2026,12,31));
              if (context.mounted) Navigator.push(context, MaterialPageRoute(builder: (_) =>
                ReportViewScreen(title: 'الأستاذ العام', data: data, columns: ['date','description','debit','credit','balance'])));
            }),
            _ReportTile('ميزان المراجعة', onTap: () async {
              final data = await reportService.trialBalance(DateTime.now());
              if (context.mounted) Navigator.push(context, MaterialPageRoute(builder: (_) =>
                ReportViewScreen(title: 'ميزان المراجعة', data: data, columns: ['account_number','account_name','debit','credit'])));
            }),
            _ReportTile('قائمة الدخل', onTap: () async {
              final inc = await reportService.incomeStatement(from: DateTime(2026,1,1), to: DateTime(2026,12,31));
              if (context.mounted) _showSummaryDialog(context, 'قائمة الدخل', inc);
            }),
            _ReportTile('الميزانية العمومية', onTap: () async {
              final bs = await reportService.balanceSheet(DateTime.now());
              if (context.mounted) _showSummaryDialog(context, 'الميزانية العمومية', bs);
            }),
            _ReportTile('التدفقات النقدية', onTap: () async {
              final cf = await reportService.cashFlow(from: DateTime(2026,1,1), to: DateTime(2026,12,31));
              if (context.mounted) _showSummaryDialog(context, 'التدفقات النقدية', cf);
            }),
          ]),
          _buildSection('كشوف الحسابات', [
            _ReportTile('كشف العميل', onTap: () async {
              final data = await reportService.customerStatement(customerId:1, from: DateTime(2026,1,1), to: DateTime(2026,12,31));
              if (context.mounted) Navigator.push(context, MaterialPageRoute(builder: (_) =>
                ReportViewScreen(title: 'كشف العميل', data: data, columns: ['date','description','debit','credit','balance'])));
            }),
            _ReportTile('كشف المورد', onTap: () async {
              final data = await reportService.supplierStatement(supplierId:1, from: DateTime(2026,1,1), to: DateTime(2026,12,31));
              if (context.mounted) Navigator.push(context, MaterialPageRoute(builder: (_) =>
                ReportViewScreen(title: 'كشف المورد', data: data, columns: ['date','description','debit','credit','balance'])));
            }),
            _ReportTile('كشف البنك', onTap: () async {
              final data = await reportService.bankStatement(bankId:1, from: DateTime(2026,1,1), to: DateTime(2026,12,31));
              if (context.mounted) Navigator.push(context, MaterialPageRoute(builder: (_) =>
                ReportViewScreen(title: 'كشف البنك', data: data, columns: ['date','description','debit','credit','balance'])));
            }),
            _ReportTile('كشف الصندوق', onTap: () async {
              final data = await reportService.cashBoxStatement(cashBoxId:1, from: DateTime(2026,1,1), to: DateTime(2026,12,31));
              if (context.mounted) Navigator.push(context, MaterialPageRoute(builder: (_) =>
                ReportViewScreen(title: 'كشف الصندوق', data: data, columns: ['date','description','debit','credit','balance'])));
            }),
            _ReportTile('كشف المحافظ', onTap: () async {
              final data = await reportService.walletStatement(walletId:1, from: DateTime(2026,1,1), to: DateTime(2026,12,31));
              if (context.mounted) Navigator.push(context, MaterialPageRoute(builder: (_) =>
                ReportViewScreen(title: 'كشف المحفظة', data: data, columns: ['date','description','debit','credit','balance'])));
            }),
            _ReportTile('كشف شركات الصرافة', onTap: () async {
              final data = await reportService.exchangeCompanyStatement(companyId:1, from: DateTime(2026,1,1), to: DateTime(2026,12,31));
              if (context.mounted) Navigator.push(context, MaterialPageRoute(builder: (_) =>
                ReportViewScreen(title: 'كشف شركة الصرافة', data: data, columns: ['date','description','debit','credit','balance'])));
            }),
          ]),
          _buildSection('تقارير المخزون والأرباح', [
            _ReportTile('تقرير المخزون', onTap: () async {
              final data = await reportService.inventoryReport();
              if (context.mounted) Navigator.push(context, MaterialPageRoute(builder: (_) =>
                ReportViewScreen(title: 'تقرير المخزون', data: data, columns: ['item','quantity','cost','total'])));
            }),
            _ReportTile('تقرير الأرباح', onTap: () async {
              final profit = await reportService.profitReport(from: DateTime(2026,1,1), to: DateTime(2026,12,31));
              if (context.mounted) _showSummaryDialog(context, 'تقرير الأرباح', profit);
            }),
          ]),
        ],
      ),
    );
  }

  void _showSummaryDialog(BuildContext context, String title, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: data.entries.map((e) =>
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text('${e.key}: ${e.value}'),
              )
            ).toList(),
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('موافق'))],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
        ),
        ...children,
        const Divider(),
      ],
    );
  }
}

class _ReportTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const _ReportTile(this.title, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
