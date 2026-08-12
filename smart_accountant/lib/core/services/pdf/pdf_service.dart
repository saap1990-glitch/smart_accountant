import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfService {
  Future<void> printInvoice({
    required String invoiceNumber,
    required String date,
    required String customerName,
    required List<Map<String, dynamic>> items,
    required double total,
    double? discount,
    double? tax,
    String? notes,
  }) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.cairoRegular();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(32),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                // الهيدر
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('فاتورة بيع', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                        pw.Text('رقم: $invoiceNumber'),
                        pw.Text('التاريخ: $date'),
                      ],
                    ),
                    pw.Text('المحاسب الذكي', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                pw.SizedBox(height: 24),
                pw.Text('العميل: $customerName', style: const pw.TextStyle(fontSize: 16)),
                pw.SizedBox(height: 16),
                // جدول الأصناف
                pw.TableHelper.fromTextArray(
                  headers: ['الصنف', 'الكمية', 'السعر', 'الإجمالي'],
                  data: items.map((item) => [
                    item['name'] ?? '',
                    item['quantity']?.toString() ?? '',
                    item['price']?.toString() ?? '',
                    ((item['quantity'] ?? 0) * (item['price'] ?? 0)).toString(),
                  ]).toList(),
                ),
                pw.SizedBox(height: 16),
                // الإجمالي
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text('الإجمالي: ${total.toStringAsFixed(2)} ريال',
                        style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                if (notes != null) pw.Text('ملاحظات: $notes'),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }
}
