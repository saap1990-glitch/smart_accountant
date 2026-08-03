import 'service_locator.dart';
import '../seeds/seed_service.dart';
import '../services/numbering/number_generator.dart';
import '../events/event_bus.dart';
import '../services/transaction_manager.dart';

void configureDependencies() {
  ServiceLocator.register<EventBus>(EventBus());

  ServiceLocator.register<NumberGenerator>(DefaultNumberGenerator());

  ServiceLocator.register<TransactionManager>(DefaultTransactionManager());

  ServiceLocator.register<SeedService>(DefaultSeedService());
}
