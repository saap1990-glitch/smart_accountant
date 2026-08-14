class DatabaseSeed {
  const DatabaseSeed._();

  static const String baseCurrency = 'YER';

  static const List<Map<String, Object>> rootAccounts = [
    {
      'number': '1',
      'nameAr': 'الأصول',
      'nameEn': 'Assets',
      'level': 1,
      'type': 'asset',
      'nature': 'debit',
    },
    {
      'number': '2',
      'nameAr': 'الخصوم',
      'nameEn': 'Liabilities',
      'level': 1,
      'type': 'liability',
      'nature': 'credit',
    },
    {
      'number': '3',
      'nameAr': 'المصروفات',
      'nameEn': 'Expenses',
      'level': 1,
      'type': 'expense',
      'nature': 'debit',
    },
    {
      'number': '4',
      'nameAr': 'الإيرادات',
      'nameEn': 'Revenues',
      'level': 1,
      'type': 'revenue',
      'nature': 'credit',
    },
  ];
}
