import 'dart:async';
import 'package:get_it/get_it.dart';
import '../event_bus/event_bus.dart';
import '../audit/audit_entry.dart';
import '../audit/audit_service.dart';
import '../services/transaction_manager.dart';
import '../services/numbering/number_generator.dart';
import '../engine/accounting/accounting_engine.dart';
import '../engine/validation/transaction_validator.dart';
import '../engine/workflow/workflow_engine.dart';
import '../repositories/master_data_repository.dart';
import '../repositories/journal_repository.dart';
import '../repositories/ledger_repository.dart';
import '../services/master_data/master_data_service.dart';
import '../services/operations/operation_service.dart';
import '../services/reports/report_service.dart';
import '../services/ai/ai_service.dart';
import '../services/backup/backup_service.dart';
import '../services/encryption/encryption_service.dart';
import '../services/subscription/subscription_service.dart';
import '../services/subscription/anti_tamper_service.dart';
import '../services/inventory/item_movement_service.dart';
import '../services/inventory/inventory_cost_service.dart';
import '../services/inventory/inventory_movement_engine.dart';
import '../services/accounting/accounting_link_service.dart';
import '../services/templates/activity_templates.dart';
import '../services/notifications/notification_service.dart';
import '../services/targets/target_service.dart';
import '../services/pdf/pdf_service.dart';
import '../services/excel/excel_service.dart';
import '../services/debts/debt_service.dart';
import '../services/admin/owner_auth_service.dart';
import '../auth/auth_service.dart';
import '../database/app_database.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  final db = AppDatabase();
  sl.registerSingleton<AppDatabase>(db);

  sl.registerLazySingleton<AppEventBus>(() => AppEventBus());
  sl.registerLazySingleton<AuditService>(() => _InMemoryAuditService());
  sl.registerLazySingleton<TransactionManager>(
    () => TransactionManager(sl<AuditService>(), sl<AppEventBus>()),
  );
  sl.registerLazySingleton<NumberGenerator>(
    () => NumberGenerator(sl<AppDatabase>()),
  );
  sl.registerLazySingleton<TransactionValidator>(
    () => DefaultTransactionValidator(),
  );
  sl.registerLazySingleton<WorkflowEngine>(() => WorkflowEngine());

  sl.registerLazySingleton<MasterDataRepository>(
    () => MasterDataRepository(sl<AppDatabase>()),
  );
  sl.registerLazySingleton<JournalRepository>(
    () => JournalRepository(sl<AppDatabase>()),
  );
  sl.registerLazySingleton<LedgerRepository>(
    () => LedgerRepository(sl<AppDatabase>()),
  );

  sl.registerLazySingleton<AccountingEngine>(
    () => AccountingEngine(
      validator: sl<TransactionValidator>(),
      workflow: sl<WorkflowEngine>(),
      numberGenerator: sl<NumberGenerator>(),
      transactionManager: sl<TransactionManager>(),
      eventBus: sl<AppEventBus>(),
      journalRepo: sl<JournalRepository>(),
      ledgerRepo: sl<LedgerRepository>(),
    ),
  );

  sl.registerLazySingleton<AccountingLinkService>(
    () => AccountingLinkService(sl<AppDatabase>()),
  );
  sl.registerLazySingleton<MasterDataService>(
    () => MasterDataService(
      sl<MasterDataRepository>(),
      sl<AccountingLinkService>(),
    ),
  );
  sl.registerLazySingleton<ItemMovementService>(
    () => ItemMovementService(sl<AppDatabase>()),
  );

  sl.registerLazySingleton<InventoryMovementEngine>(
    () => InventoryMovementEngine(sl<AppDatabase>()),
  );

  sl.registerLazySingleton<InventoryCostService>(
    () => InventoryCostService(sl<AppDatabase>()),
  );

  sl.registerLazySingleton<OperationService>(
    () => OperationService(
      sl<AccountingEngine>(),
      sl<MasterDataService>(),
      sl<ItemMovementService>(),
      sl<InventoryMovementEngine>(),
      sl<AppDatabase>(),
      sl<LedgerRepository>(),
    ),
  );
  sl.registerLazySingleton<ReportService>(
    () => ReportService(
      sl<MasterDataRepository>(),
      sl<ItemMovementService>(),
      sl<InventoryCostService>(),
      sl<LedgerRepository>(),
    ),
  );
  sl.registerLazySingleton<AiService>(
    () => AiService(sl<OperationService>(), sl<ReportService>()),
  );
  sl.registerLazySingleton<BackupService>(() => BackupService());
  sl.registerLazySingleton<EncryptionService>(() => EncryptionService());
  sl.registerLazySingleton<SubscriptionService>(() => SubscriptionService());
  sl.registerLazySingleton<AntiTamperService>(() => AntiTamperService());
  sl.registerLazySingleton<AuthService>(() => AuthService());
  sl.registerLazySingleton<ActivityTemplates>(() => ActivityTemplates());
  sl.registerLazySingleton<NotificationService>(() => NotificationService());
  sl.registerLazySingleton<TargetService>(() => TargetService());
  sl.registerLazySingleton<PdfService>(() => PdfService());
  sl.registerLazySingleton<ExcelService>(() => ExcelService());
  sl.registerLazySingleton<DebtService>(() => DebtService());
  sl.registerLazySingleton<OwnerAuthService>(() => OwnerAuthService());
}

class _InMemoryAuditService extends AuditService {
  final List<AuditEntry> _entries = [];
  final _controller = StreamController<AuditEntry>.broadcast();
  @override
  Future<void> record(AuditEntry entry) async {
    _entries.add(entry);
    _controller.add(entry);
  }

  @override
  Future<List<AuditEntry>> getAll() async => List.unmodifiable(_entries);
  @override
  Stream<AuditEntry> watchAll() => _controller.stream;
}
