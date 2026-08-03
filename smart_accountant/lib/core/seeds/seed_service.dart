abstract class SeedService {
  Future<void> seed();
}

class DefaultSeedService implements SeedService {
  @override
  Future<void> seed() async {
    // سيتم هنا لاحقاً إنشاء:
    // دليل الحسابات الأساسي
    // العملات
    // إعدادات النظام
  }
}
