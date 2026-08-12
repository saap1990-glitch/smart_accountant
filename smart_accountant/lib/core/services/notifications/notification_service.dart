import 'dart:async';

class AppNotification {
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;

  AppNotification({
    required this.title,
    required this.message,
    required this.type,
    DateTime? timestamp,
    this.isRead = false,
  }) : timestamp = timestamp ?? DateTime.now();
}

enum NotificationType {
  success,
  warning,
  info,
  achievement,
  deadline,
  motivational,
}

class NotificationService {
  final List<AppNotification> _notifications = [];
  final _controller = StreamController<List<AppNotification>>.broadcast();

  Stream<List<AppNotification>> get notifications => _controller.stream;

  List<AppNotification> get unread =>
      _notifications.where((n) => !n.isRead).toList();

  int get unreadCount => unread.length;

  List<AppNotification> get all => List.unmodifiable(_notifications);

  void add({
    required String title,
    required String message,
    required NotificationType type,
  }) {
    _notifications.insert(0, AppNotification(
      title: title,
      message: message,
      type: type,
    ));
    _controller.add(all);
  }

  void markAllRead() {
    for (var n in _notifications) {
      n = AppNotification(
        title: n.title,
        message: n.message,
        type: n.type,
        timestamp: n.timestamp,
        isRead: true,
      );
    }
    _controller.add(all);
  }

  // إشعارات ذكية تلقائية
  void checkTargetAchievement(double achieved, double target, String period) {
    final percentage = (achieved / target * 100);
    if (percentage >= 100) {
      add(
        title: '🎉 هدف محقق!',
        message: 'حققت $percentage% من هدفك ال$period. أداء رائع!',
        type: NotificationType.achievement,
      );
    } else if (percentage >= 80) {
      add(
        title: '🔥 اقتربت من الهدف!',
        message: 'تبقى ${(target - achieved).toStringAsFixed(0)} ريال لتحقيق هدفك ال$period',
        type: NotificationType.motivational,
      );
    } else if (percentage >= 50) {
      add(
        title: '💪 أنت في منتصف الطريق',
        message: 'أنجزت $percentage% من هدفك. استمر!',
        type: NotificationType.motivational,
      );
    }
  }

  void checkDeadlines() {
    final now = DateTime.now();
    // تنبيهات نهاية الشهر
    if (now.day >= 25) {
      add(
        title: '📅 تنبيه نهاية الشهر',
        message: 'تبقى ${DateTime(now.year, now.month + 1, 0).day - now.day} أيام على نهاية الشهر',
        type: NotificationType.deadline,
      );
    }
  }

  void lowStockAlert(String itemName, double quantity) {
    add(
      title: '⚠️ مخزون منخفض',
      message: 'الصنف "$itemName" أوشك على النفاد (الكمية: $quantity)',
      type: NotificationType.warning,
    );
  }

  void paymentReminder(String customerName, double amount, int daysLeft) {
    add(
      title: '💳 دفعة مستحقة',
      message: 'العميل "$customerName" عليه دفعة ${amount.toStringAsFixed(0)} ريال خلال $daysLeft يوم',
      type: NotificationType.deadline,
    );
  }

  void dispose() {
    _controller.close();
  }
}
