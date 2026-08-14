import 'intent_analyzer.dart';

class WorkflowStep {
  final String description;
  final String action;
  final Map<String, dynamic>? data;

  WorkflowStep({required this.description, required this.action, this.data});
}

class WorkflowGenerator {
  List<WorkflowStep> generate(DetectedIntent intent) {
    switch (intent.intent) {
      case UserIntent.createSale:
        return [
          WorkflowStep(description: 'التحقق من العميل', action: 'verify_customer'),
          WorkflowStep(description: 'التحقق من الأصناف والكميات', action: 'verify_items'),
          WorkflowStep(description: 'حساب الإجمالي والضرائب', action: 'calculate_totals'),
          WorkflowStep(description: 'إنشاء القيود المحاسبية', action: 'create_entries'),
          WorkflowStep(description: 'حفظ الفاتورة', action: 'save_invoice'),
          WorkflowStep(description: 'عرض المعاينة للمستخدم', action: 'show_preview'),
        ];
      case UserIntent.createReceipt:
        return [
          WorkflowStep(description: 'تحديد جهة القبض', action: 'identify_source'),
          WorkflowStep(description: 'إنشاء القيد', action: 'create_entries'),
          WorkflowStep(description: 'حفظ السند', action: 'save_receipt'),
          WorkflowStep(description: 'عرض المعاينة', action: 'show_preview'),
        ];
      case UserIntent.queryBalance:
        return [
          WorkflowStep(description: 'تحديد الحساب', action: 'identify_account'),
          WorkflowStep(description: 'جلب الرصيد', action: 'fetch_balance'),
          WorkflowStep(description: 'عرض النتيجة', action: 'display_result'),
        ];
      case UserIntent.sendDocument:
        return [
          WorkflowStep(description: 'تحديد المستند', action: 'identify_document'),
          WorkflowStep(description: 'تحديد المستلم', action: 'identify_recipient'),
          WorkflowStep(description: 'إنشاء الملف', action: 'generate_file'),
          WorkflowStep(description: 'معاينة قبل الإرسال', action: 'preview_send'),
          WorkflowStep(description: 'إرسال', action: 'send'),
        ];
      default:
        return [
          WorkflowStep(description: 'تحليل الطلب', action: 'analyze'),
          WorkflowStep(description: 'تنفيذ العملية', action: 'execute'),
        ];
    }
  }
}
