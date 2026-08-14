import 'package:get_it/get_it.dart';
import '../accounting/accounting_link_service.dart';
import '../master_data/master_data_service.dart';

class ActivityTemplates {

  ActivityTemplates();

  Map<String, Map<String, dynamic>> get templates => {
    'general': {
      'name': 'دليل محاسبي عام',
      'icon': 'account_balance',
      'description': 'مناسب لجميع الأنشطة',
    },
    'commercial': {
      'name': 'نشاط تجاري',
      'icon': 'store',
      'description': 'بيع وشراء البضائع',
    },
    'supermarket': {
      'name': 'سوبر ماركت',
      'icon': 'shopping_cart',
      'description': 'تجارة التجزئة والمواد الغذائية',
    },
    'pharmacy': {
      'name': 'صيدلية',
      'icon': 'medical_services',
      'description': 'بيع الأدوية والمستلزمات الطبية',
    },
    'exchange': {
      'name': 'شركة صرافة',
      'icon': 'currency_exchange',
      'description': 'تحويل العملات والحوالات',
    },
    'contracting': {
      'name': 'مقاولات',
      'icon': 'construction',
      'description': 'مشاريع البناء والتشييد',
    },
    'services': {
      'name': 'خدمات',
      'icon': 'miscellaneous_services',
      'description': 'تقديم الخدمات المهنية والاستشارية',
    },
    'restaurant': {
      'name': 'مطعم',
      'icon': 'restaurant',
      'description': 'المطاعم والوجبات',
    },
    'factory': {
      'name': 'مصنع',
      'icon': 'factory',
      'description': 'الإنتاج والتصنيع',
    },
  };

  Future<void> applyTemplate(String templateKey) async {
    // البذور الأساسية موجودة مسبقاً، نضيف حسابات إضافية حسب النشاط
    switch (templateKey) {
      case 'commercial':
      case 'supermarket':
        await _addCommercialAccounts();
        break;
      case 'pharmacy':
        await _addPharmacyAccounts();
        break;
      case 'exchange':
        await _addExchangeAccounts();
        break;
      case 'restaurant':
        await _addRestaurantAccounts();
        break;
      case 'factory':
        await _addFactoryAccounts();
        break;
      case 'contracting':
        await _addContractingAccounts();
        break;
      case 'services':
        await _addServicesAccounts();
        break;
      default:
        break; // عام = لا إضافات
    }
  }

  Future<void> _addCommercialAccounts() async {
    // إضافة أصناف تجارية شائعة
    // يمكن إضافة حسابات فرعية هنا
  }

  Future<void> _addPharmacyAccounts() async {}
  Future<void> _addExchangeAccounts() async {}
  Future<void> _addRestaurantAccounts() async {}
  Future<void> _addFactoryAccounts() async {}
  Future<void> _addContractingAccounts() async {}
  Future<void> _addServicesAccounts() async {}
}
