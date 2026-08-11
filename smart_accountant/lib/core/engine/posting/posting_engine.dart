class PostingData {
  final Map<String, dynamic> entry;
  final List<Map<String, dynamic>> lines;
  const PostingData({required this.entry, required this.lines});
}

class PostingEngine {
  const PostingEngine();

  PostingData preparePosting({
    required String entryNumber,
    required DateTime entryDate,
    required String operationType,
    required String? description,
    required String? referenceType,
    required String? referenceId,
    required String currencyCode,
    required double exchangeRate,
    required List<Map<String, dynamic>> items,
  }) {
    final lines = items.map((item) => <String, dynamic>{
      'accountId': item['accountId'],
      'description': item['description'],
      'debit': item['debit'].toString(),
      'credit': item['credit'].toString(),
      'currencyCode': currencyCode,
      'exchangeRate': exchangeRate.toString(),
      'foreignDebit': (item['debit'] * exchangeRate).toString(),
      'foreignCredit': (item['credit'] * exchangeRate).toString(),
    }).toList();

    final entry = <String, dynamic>{
      'entryNumber': entryNumber,
      'entryDate': entryDate.toIso8601String(),
      'operationType': operationType,
      'status': 'posted',
      'description': description,
      'referenceType': referenceType,
      'referenceId': referenceId,
      'currencyCode': currencyCode,
      'exchangeRate': exchangeRate.toString(),
      'createdAt': DateTime.now().toIso8601String(),
    };
    return PostingData(entry: entry, lines: lines);
  }
}
