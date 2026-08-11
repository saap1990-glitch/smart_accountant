import 'package:flutter/material.dart';

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
      appBar: AppBar(title: Text(title)),
      body: data.isEmpty
          ? const Center(child: Text('لا توجد بيانات'))
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: columns
                    .map((col) => DataColumn(
                        label: Text(columnTitles?[col] ?? col)))
                    .toList(),
                rows: data.map((row) {
                  return DataRow(
                    cells: columns.map((col) {
                      return DataCell(Text(row[col]?.toString() ?? ''));
                    }).toList(),
                  );
                }).toList(),
              ),
            ),
    );
  }
}
