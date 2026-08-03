import '../seeds/seed_service.dart';

class AppStartup {
  final SeedService seedService;

  AppStartup(this.seedService);

  Future<void> run() async {
    await seedService.seed();
  }
}
