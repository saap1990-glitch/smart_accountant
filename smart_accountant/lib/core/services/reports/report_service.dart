import '../../repositories/master_data_repository.dart';
import '../inventory/item_movement_service.dart';

class ReportService {
  final MasterDataRepository _repository;
  final ItemMovementService _movementService;

  ReportService(this._repository, this._movementService);

  Future<List<Map<String, dynamic>>> generalLedger({
    required int accountId,
    required DateTime from,
    required DateTime to,
  }) async {
    // TODO: استبدال ببيانات حقيقية من العمليات
    return [
      {'date': '2026-01-01', 'description': 'رصيد افتتاحي', 'debit': '0', 'credit': '0', 'balance': '10000'},
      {'date': '2026-08-01', 'description': 'فاتورة بيع #123', 'debit': '5000', 'credit': '0', 'balance': '15000'},
    ];
  }

  Future<List<Map<String, dynamic>>> trialBalance(DateTime asOf) async {
    final accounts = await _repository.getAllAccounts();
    return accounts.map((a) => {
      'account_number': a['number'],
      'account_name': a['name_ar'] ?? a['name_en'],
      'debit': '1000',
      'credit': '500',
      'net_debit': '500',
      'net_credit': '0',
    }).toList();
  }

  Future<Map<String, dynamic>> incomeStatement({required DateTime from, required DateTime to}) async {
    return {'revenues': 50000.0, 'expenses': 30000.0, 'net_income': 20000.0, 'period': '${from.toIso8601String()} / ${to.toIso8601String()}'};
  }

  Future<Map<String, dynamic>> balanceSheet(DateTime asOf) async {
    return {'assets': 150000.0, 'liabilities': 40000.0, 'equity': 110000.0, 'as_of': asOf.toIso8601String()};
  }

  Future<Map<String, dynamic>> cashFlow({required DateTime from, required DateTime to}) async {
    return {'operating': 25000.0, 'investing': -5000.0, 'financing': 0.0, 'net_cash_flow': 20000.0};
  }

  Future<List<Map<String, dynamic>>> customerStatement({required int customerId, required DateTime from, required DateTime to}) async {
    return _sampleStatement('عميل', customerId.toString());
  }

  Future<List<Map<String, dynamic>>> supplierStatement({required int supplierId, required DateTime from, required DateTime to}) async {
    return _sampleStatement('مورد', supplierId.toString());
  }

  Future<List<Map<String, dynamic>>> bankStatement({required int bankId, required DateTime from, required DateTime to}) async {
    return _sampleStatement('بنك', bankId.toString());
  }

  Future<List<Map<String, dynamic>>> cashBoxStatement({required int cashBoxId, required DateTime from, required DateTime to}) async {
    return _sampleStatement('صندوق', cashBoxId.toString());
  }

  Future<List<Map<String, dynamic>>> walletStatement({required int walletId, required DateTime from, required DateTime to}) async {
    return _sampleStatement('محفظة', walletId.toString());
  }

  Future<List<Map<String, dynamic>>> exchangeCompanyStatement({required int companyId, required DateTime from, required DateTime to}) async {
    return _sampleStatement('شركة صرافة', companyId.toString());
  }

  Future<List<Map<String, dynamic>>> inventoryReport() async {
    return _movementService.getAllItemCards().map((card) => {
      'item': card['item_name'],
      'quantity': card['balance'],
      'cost': '0',
      'total': '0',
    }).toList();
  }

  Future<Map<String, dynamic>> profitReport({required DateTime from, required DateTime to}) async {
    return {'total_sales': 100000.0, 'total_purchases': 60000.0, 'gross_profit': 40000.0, 'expenses': 15000.0, 'net_profit': 25000.0};
  }

  List<Map<String, dynamic>> _sampleStatement(String entity, String id) {
    return [
      {'date': '2026-07-01', 'description': 'رصيد سابق', 'debit': '0', 'credit': '0', 'balance': '5000'},
      {'date': '2026-07-15', 'description': 'عملية $entity #$id', 'debit': '3000', 'credit': '0', 'balance': '8000'},
    ];
  }
}
