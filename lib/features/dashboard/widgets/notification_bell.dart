import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../core/services/notifications/notification_service.dart';

class NotificationBell extends StatefulWidget {
  const NotificationBell({super.key});

  @override
  State<NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends State<NotificationBell> {
  final _service = GetIt.I<NotificationService>();
  int _count = 0;

  @override
  void initState() {
    super.initState();
    _count = _service.unreadCount;
    _service.notifications.listen((_) {
      if (mounted) setState(() => _count = _service.unreadCount);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () => _showNotifications(context),
        ),
        if (_count > 0)
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                _count.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ),
      ],
    );
  }

  void _showNotifications(BuildContext context) {
    _service.markAllRead();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final notifications = _service.all;
        if (notifications.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: Text('لا توجد إشعارات 🎉', style: TextStyle(fontSize: 18))),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: notifications.length,
          separatorBuilder: (_, _) => const Divider(),
          itemBuilder: (_, i) {
            final n = notifications[i];
            IconData icon;
            Color color;
            switch (n.type) {
              case NotificationType.achievement:
                icon = Icons.emoji_events;
                color = Colors.amber;
                break;
              case NotificationType.warning:
                icon = Icons.warning;
                color = Colors.orange;
                break;
              case NotificationType.deadline:
                icon = Icons.schedule;
                color = Colors.red;
                break;
              case NotificationType.motivational:
                icon = Icons.favorite;
                color = Colors.pink;
                break;
              default:
                icon = Icons.info;
                color = Colors.teal;
            }
            return ListTile(
              leading: CircleAvatar(backgroundColor: color.withValues(alpha: 0.2), child: Icon(icon, color: color)),
              title: Text(n.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(n.message),
              trailing: Text(
                '${n.timestamp.hour}:${n.timestamp.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            );
          },
        );
      },
    );
  }
}
