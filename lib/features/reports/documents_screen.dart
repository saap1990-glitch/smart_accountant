import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:drift/drift.dart';
import '../../core/database/app_database.dart';
import '../../core/services/pdf/pdf_service.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  final _db = GetIt.I<AppDatabase>();
  List<JournalEntry> _entries = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final query = _db.select(_db.journalEntries)
      ..orderBy([(t) => OrderingTerm.desc(t.entryDate)]);
    final entries = await query.get();
    if (!mounted) return;
    setState(() {
      _entries = entries;
      _loading = false;
    });
  }

  Future<void> _printEntry(JournalEntry entry) async {
    final lines = await (_db.select(
      _db.journalLines,
    )..where((t) => t.journalEntryId.equals(entry.id))).get();

    final pdfService = PdfService();
    await pdfService.printReport(
      reportTitle: 'قيد ${entry.entryNumber}',
      headers: ['الحساب', 'مدين', 'دائن', 'البيان'],
      rows: lines
          .map(
            (l) => [
              l.accountId.toString(),
              l.debit,
              l.credit,
              l.description ?? '',
            ],
          )
          .toList(),
    );
  }

  String _operationName(String type) {
    switch (type) {
      case 'receipt':
        return 'سند قبض';
      case 'payment':
        return 'سند صرف';
      case 'sale':
        return 'فاتورة بيع';
      case 'purchase':
        return 'فاتورة شراء';
      case 'journal':
        return 'قيد يومية';
      case 'transfer':
        return 'تحويل';
      case 'inventory':
        return 'حركة مخزون';
      default:
        return type;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المستندات والقيود'),
        actions: [
          IconButton(
            tooltip: 'تحديث',
            icon: const Icon(Icons.refresh),
            onPressed: _load,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _entries.isEmpty
          ? const Center(child: Text('لا توجد مستندات بعد'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _entries.length,
              itemBuilder: (_, index) {
                final entry = _entries[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        _operationName(entry.operationType).substring(0, 1),
                      ),
                    ),
                    title: Text(
                      entry.entryNumber,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${_operationName(entry.operationType)} • '
                      '${entry.entryDate.year}/${entry.entryDate.month}/${entry.entryDate.day}\n'
                      '${entry.description ?? ''}',
                    ),
                    trailing: IconButton(
                      tooltip: 'طباعة',
                      icon: const Icon(Icons.print),
                      onPressed: () => _printEntry(entry),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
