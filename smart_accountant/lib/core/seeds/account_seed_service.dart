import 'package:get_it/get_it.dart';
import '../services/master_data/master_data_service.dart';

class AccountSeedService {
  final MasterDataService _masterDataService;

  AccountSeedService(this._masterDataService);

  Future<void> seedIfEmpty() async {
    final existingAccounts = await _masterDataService.getAllAccounts();
    if (existingAccounts.isNotEmpty) return;

    // 1. الأصول
    final assetsId = await _masterDataService.createAccount(
      number: '1', nameAr: 'الأصول', nameEn: 'Assets', type: 'asset', nature: 'debit', parentId: null, level: 1,
    );
    // 2. الخصوم
    final liabilitiesId = await _masterDataService.createAccount(
      number: '2', nameAr: 'الخصوم', nameEn: 'Liabilities', type: 'liability', nature: 'credit', parentId: null, level: 1,
    );
    // 3. المصروفات
    final expensesId = await _masterDataService.createAccount(
      number: '3', nameAr: 'المصروفات', nameEn: 'Expenses', type: 'expense', nature: 'debit', parentId: null, level: 1,
    );
    // 4. الإيرادات
    final revenuesId = await _masterDataService.createAccount(
      number: '4', nameAr: 'الإيرادات', nameEn: 'Revenues', type: 'revenue', nature: 'credit', parentId: null, level: 1,
    );
  }
}
