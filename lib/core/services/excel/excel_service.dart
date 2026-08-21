import 'package:excel/excel.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';

class ExcelService {
  Future<void> exportToExcel({
    required String title,
    required List<String> headers,
    required List<List<dynamic>> rows,
  }) async {
    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];
    sheet.appendRow(headers.map((h) => TextCellValue(h)).toList());
    for (var row in rows) {
      sheet.appendRow(
        row.map((cell) => TextCellValue(cell.toString())).toList(),
      );
    }
    final bytes = excel.encode();
    if (bytes == null) return;
    final file = File('${Directory.systemTemp.path}/$title.xlsx');
    await file.writeAsBytes(bytes);
    await Share.shareXFiles([XFile(file.path)], text: title);
  }
}
