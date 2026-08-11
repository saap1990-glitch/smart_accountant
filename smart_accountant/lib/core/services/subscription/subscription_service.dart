class SubscriptionService {
  DateTime? _expiryDate;

  /// تفعيل التجربة المجانية (90 يومًا)
  void startTrial() {
    _expiryDate = DateTime.now().add(const Duration(days: 90));
  }

  /// التحقق من صلاحية الاشتراك
  bool get isActive {
    if (_expiryDate == null) return false;
    return DateTime.now().isBefore(_expiryDate!);
  }

  /// عدد الأيام المتبقية
  int get daysLeft {
    if (_expiryDate == null) return 0;
    return _expiryDate!.difference(DateTime.now()).inDays;
  }
}
