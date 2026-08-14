import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../core/services/pdf/pdf_service.dart';
import '../../core/services/excel/excel_service.dart';

class ReportViewScreen extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> data;
  final List<String> columns;
  final Map<String, String>? columnTitles;

  const ReportViewScreen({
    super.key,
    required this.title,
    required this.data,
    required this.columns,
    this.columnTitles,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(icon: const Icon(Icons.print), tooltip: 'طباعة PDF', onPressed: () => _printReport()),
          IconButton(icon: const Icon(Icons.table_chart), tooltip: 'تصدير Excel', onPressed: () => _exportExcel()),
        ],
      ),
      body: data.isEmpty
          ? const Center(child: Text('لا توجد بيانات'))
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: columns.map((col) => DataColumn(label: Text(columnTitles?[col] ?? col))).toList(),
                rows: data.map((row) {
                  return DataRow(cells: columns.map((col) => DataCell(Text(row[col]?.toString() ?? ''))).toList());
                }).toList(),
              ),
            ),
    );
  }

  void _printReport() async {
    final pdfService = GetIt.I<PdfService>();
    final headers = columns.map((c) => columnTitles?[c] ?? c).toList();
    final rows = data.map((row) => columns.map((c) => row[c]?.toString() ?? '').toList()).toList();
    await pdfService.printReport(reportTitle: title, headers: headers, rows: rows);
  }

  void _exportExcel() async {
    final excelService = GetIt.I<ExcelService>();
    final headers = columns.map((c) => columnTitles?[c] ?? c).toList();
    final rows = data.map((row) => columns.map((c) => row[c]?.toString() ?? '').toList()).toList();
    await excelService.exportToExcel(title: title, headers: headers, rows: rows);
  }
}
