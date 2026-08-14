import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';

class PdfService {
  /// طباعة فاتورة
  Future<void> printInvoice({
    required String title,
    required String number,
    required String date,
    required String customerName,
    required List<Map<String, dynamic>> items,
    required double total,
    double? discount,
    double? tax,
    String? notes,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(child: pw.Text('المحاسب الذكي', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold))),
              pw.Center(child: pw.Text(title, style: pw.TextStyle(fontSize: 18))),
              pw.SizedBox(height: 16),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('رقم: $number'),
                  pw.Text('التاريخ: $date'),
                ],
              ),
              pw.SizedBox(height: 8),
              if (customerName.isNotEmpty) pw.Text('العميل/المورد: $customerName'),
              pw.SizedBox(height: 16),
              pw.TableHelper.fromTextArray(
                headers: ['الصنف', 'الوحدة', 'الكمية', 'السعر', 'الإجمالي'],
                data: items.map((item) => [
                  item['name'] ?? '',
                  item['unit'] ?? '',
                  item['quantity']?.toString() ?? '',
                  item['price']?.toString() ?? '',
                  ((item['quantity'] ?? 0) * (item['price'] ?? 0)).toStringAsFixed(2),
                ]).toList(),
                border: pw.TableBorder.all(),
              ),
              pw.SizedBox(height: 16),
              if (discount != null) pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [pw.Text('الخصم'), pw.Text(discount.toStringAsFixed(2))]),
              if (tax != null) pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [pw.Text('الضريبة'), pw.Text(tax.toStringAsFixed(2))]),
              pw.Divider(),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Text('الإجمالي', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                pw.Text(total.toStringAsFixed(2), style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              ]),
              if (notes != null) pw.Text('ملاحظات: $notes'),
            ],
          ),
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  /// مشاركة PDF
  Future<Uint8List> generateInvoicePdf({
    required String title,
    required String number,
    required String date,
    required String customerName,
    required List<Map<String, dynamic>> items,
    required double total,
  }) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: pw.Column(
            children: [
              pw.Text('المحاسب الذكي', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.Text(title),
              pw.SizedBox(height: 16),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [pw.Text('رقم: $number'), pw.Text('التاريخ: $date')]),
              pw.SizedBox(height: 16),
              pw.TableHelper.fromTextArray(
                headers: ['الصنف', 'الكمية', 'السعر', 'الإجمالي'],
                data: items.map((item) => [item['name'] ?? '', item['quantity']?.toString() ?? '', item['price']?.toString() ?? '', ((item['quantity'] ?? 0) * (item['price'] ?? 0)).toStringAsFixed(2)]).toList(),
              ),
              pw.SizedBox(height: 16),
              pw.Text('الإجمالي: $total', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
    return pdf.save();
  }

  /// طباعة تقرير
  Future<void> printReport({
    required String reportTitle,
    required List<String> headers,
    required List<List<String>> rows,
  }) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(child: pw.Text('المحاسب الذكي', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold))),
              pw.Center(child: pw.Text(reportTitle, style: pw.TextStyle(fontSize: 18))),
              pw.SizedBox(height: 16),
              pw.TableHelper.fromTextArray(
                headers: headers,
                data: rows,
                border: pw.TableBorder.all(),
              ),
            ],
          ),
        ),
      ),
    );
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }
}
