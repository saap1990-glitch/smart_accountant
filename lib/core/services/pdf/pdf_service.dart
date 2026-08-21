import 'package:pdf/pdf.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';

class PdfService {
  Future<Map<String, dynamic>> _loadPrintSettings() async {
    const storage = FlutterSecureStorage();
    return {
      'showData': await storage.read(key: 'print_show_data') != 'false',
      'showDate': await storage.read(key: 'print_show_date') != 'false',
      'showBalance': await storage.read(key: 'print_show_balance') != 'false',
      'showDebit': await storage.read(key: 'print_show_debit') != 'false',
      'showCredit': await storage.read(key: 'print_show_credit') != 'false',
      'header': await storage.read(key: 'print_header') ?? '',
      'footer': await storage.read(key: 'print_footer') ?? '',
    };
  }

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
    final settings = await _loadPrintSettings();
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (settings['header']?.isNotEmpty == true)
                pw.Center(child: pw.Text(settings['header'] as String)),
              if (settings['showData'] != false) ...[
                pw.Center(
                  child: pw.Text(
                    'المحاسب الذكي',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Center(
                  child: pw.Text(title, style: pw.TextStyle(fontSize: 18)),
                ),
              ],
              pw.SizedBox(height: 16),
              if (settings['showDate'] != false)
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('رقم: $number'),
                    pw.Text('التاريخ: $date'),
                  ],
                ),
              pw.SizedBox(height: 8),
              if (customerName.isNotEmpty)
                pw.Text('العميل/المورد: $customerName'),
              pw.SizedBox(height: 16),
              pw.TableHelper.fromTextArray(
                headers: ['الصنف', 'الوحدة', 'الكمية', 'السعر', 'الإجمالي'],
                data: items
                    .map(
                      (item) => [
                        item['name'] ?? '',
                        item['unit'] ?? '',
                        item['quantity']?.toString() ?? '',
                        item['price']?.toString() ?? '',
                        ((item['quantity'] ?? 0) * (item['price'] ?? 0))
                            .toStringAsFixed(2),
                      ],
                    )
                    .toList(),
                border: pw.TableBorder.all(),
              ),
              pw.SizedBox(height: 16),
              if (discount != null)
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('الخصم'),
                    pw.Text(discount.toStringAsFixed(2)),
                  ],
                ),
              if (tax != null)
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('الضريبة'),
                    pw.Text(tax.toStringAsFixed(2)),
                  ],
                ),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'الإجمالي',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    total.toStringAsFixed(2),
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (notes != null) pw.Text('ملاحظات: $notes'),
              if (settings['footer']?.isNotEmpty == true)
                pw.Center(child: pw.Text(settings['footer'] as String)),
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
              pw.Text(
                'المحاسب الذكي',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(title),
              pw.SizedBox(height: 16),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [pw.Text('رقم: $number'), pw.Text('التاريخ: $date')],
              ),
              pw.SizedBox(height: 16),
              pw.TableHelper.fromTextArray(
                headers: ['الصنف', 'الكمية', 'السعر', 'الإجمالي'],
                data: items
                    .map(
                      (item) => [
                        item['name'] ?? '',
                        item['quantity']?.toString() ?? '',
                        item['price']?.toString() ?? '',
                        ((item['quantity'] ?? 0) * (item['price'] ?? 0))
                            .toStringAsFixed(2),
                      ],
                    )
                    .toList(),
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                'الإجمالي: $total',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
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
    required List<List<dynamic>> rows,
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
              pw.Center(
                child: pw.Text(
                  'المحاسب الذكي',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Center(
                child: pw.Text(reportTitle, style: pw.TextStyle(fontSize: 18)),
              ),
              pw.SizedBox(height: 16),
              pw.TableHelper.fromTextArray(
                headers: headers,
                data: rows
                    .map((r) => r.map((e) => e.toString()).toList())
                    .toList(),
                border: pw.TableBorder.all(),
              ),
            ],
          ),
        ),
      ),
    );
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  /// طباعة كشف حساب عصرية
  Future<void> printAccountStatement({
    required String accountName,
    required String accountNumber,
    required DateTime from,
    required DateTime to,
    required List<Map<String, dynamic>> rows,
  }) async {
    final settings = await _loadPrintSettings();
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(settings, 'كشف حساب'),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('الحساب: $accountName (رقم $accountNumber)'),
                  pw.Text('من ${_formatDate(from)} إلى ${_formatDate(to)}'),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                headers: ['التاريخ', 'البيان', 'مدين', 'دائن', 'الرصيد'],
                data: rows
                    .map(
                      (r) => [
                        _formatDate(
                          DateTime.tryParse(r['date']?.toString() ?? '') ??
                              DateTime.now(),
                        ),
                        r['description']?.toString() ?? '',
                        r['debit']?.toString() ?? '0',
                        r['credit']?.toString() ?? '0',
                        r['balance']?.toString() ?? '0',
                      ],
                    )
                    .toList(),
                border: pw.TableBorder.all(color: PdfColors.grey300),
                headerDecoration: pw.BoxDecoration(color: PdfColors.grey200),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                cellStyle: pw.TextStyle(fontSize: 10),
              ),
              pw.SizedBox(height: 10),
              _buildFooter(settings),
            ],
          ),
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  /// طباعة تقرير مخزون عصرية
  Future<void> printInventoryReport({
    required List<Map<String, dynamic>> items,
  }) async {
    final settings = await _loadPrintSettings();
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(settings, 'تقرير المخزون'),
              pw.SizedBox(height: 16),
              pw.Table.fromTextArray(
                headers: [
                  'الصنف',
                  'الوحدة',
                  'الكمية',
                  'متوسط التكلفة',
                  'القيمة الإجمالية',
                ],
                data: items
                    .map(
                      (item) => [
                        item['item']?.toString() ?? '',
                        item['unit']?.toString() ?? '',
                        item['quantity']?.toString() ?? '0',
                        item['average_cost']?.toString() ?? '0',
                        item['total_value']?.toString() ?? '0',
                      ],
                    )
                    .toList(),
                border: pw.TableBorder.all(color: PdfColors.grey300),
                headerDecoration: pw.BoxDecoration(color: PdfColors.grey200),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                cellStyle: pw.TextStyle(fontSize: 10),
              ),
              pw.SizedBox(height: 10),
              _buildFooter(settings),
            ],
          ),
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  /// طباعة فاتورة عصرية (بدون تفاصيل العميل المعقدة)
  Future<void> printInvoiceModern({
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
    final settings = await _loadPrintSettings();
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(settings, title),
              pw.SizedBox(height: 8),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [pw.Text('رقم: $number'), pw.Text('التاريخ: $date')],
              ),
              if (customerName.isNotEmpty) pw.Text('العميل: $customerName'),
              pw.SizedBox(height: 12),
              pw.Table.fromTextArray(
                headers: ['الصنف', 'الكمية', 'السعر', 'الإجمالي'],
                data: items
                    .map(
                      (item) => [
                        item['name']?.toString() ?? '',
                        item['quantity']?.toString() ?? '',
                        item['price']?.toString() ?? '',
                        ((item['quantity'] is num
                                    ? item['quantity'] as num
                                    : 0) *
                                (item['price'] is num
                                    ? item['price'] as num
                                    : 0))
                            .toStringAsFixed(2),
                      ],
                    )
                    .toList(),
                border: pw.TableBorder.all(color: PdfColors.grey300),
                headerDecoration: pw.BoxDecoration(color: PdfColors.grey200),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                cellStyle: pw.TextStyle(fontSize: 10),
              ),
              pw.SizedBox(height: 8),
              if (discount != null) pw.Text('الخصم: $discount'),
              if (tax != null) pw.Text('الضريبة: $tax'),
              pw.Divider(),
              pw.Text(
                'الإجمالي: $total',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              _buildFooter(settings),
            ],
          ),
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  /// طباعة سند قبض/صرف عصرية
  Future<void> printReceipt({
    required String title,
    required String number,
    required String date,
    required String accountName,
    required double amount,
    String? description,
  }) async {
    final settings = await _loadPrintSettings();
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(settings, title),
              pw.SizedBox(height: 16),
              pw.Text('الرقم: $number'),
              pw.Text('التاريخ: $date'),
              pw.Text('الحساب: $accountName'),
              pw.Text(
                'المبلغ: $amount',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              if (description != null) pw.Text('البيان: $description'),
              pw.SizedBox(height: 16),
              _buildFooter(settings),
            ],
          ),
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  pw.Widget _buildHeader(Map<String, dynamic> settings, String title) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        if (settings['header']?.isNotEmpty == true)
          pw.Center(child: pw.Text(settings['header'] as String)),
        if (settings['showData'] != false) ...[
          pw.Center(
            child: pw.Text(
              'المحاسب الذكي',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Center(child: pw.Text(title, style: pw.TextStyle(fontSize: 20))),
        ],
        pw.Divider(),
      ],
    );
  }

  pw.Widget _buildFooter(Map<String, dynamic> settings) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        if (settings['footer']?.isNotEmpty == true)
          pw.Center(child: pw.Text(settings['footer'] as String)),
        pw.SizedBox(height: 8),
        pw.Text('تم الإنشاء بواسطة المحاسب الذكي - ${DateTime.now()}'),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }
}
