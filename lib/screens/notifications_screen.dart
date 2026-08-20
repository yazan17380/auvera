import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/notification.dart';


class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late List<AppNotification> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = List.from(mockNotifications);
    // Backend: GET /notifications
  }

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  void _markOneRead(String id) {
    setState(() {
      _notifications = _notifications.map((n) {
        if (n.id != id) return n;
        return AppNotification(
          id: n.id,
          type: n.type,
          message: n.message,
          isRead: true,
          createdAt: n.createdAt,
        );
      }).toList();
    });
    // Backend: POST /notifications/{id}/read
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    return '${diff.inMinutes}m ago';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(children: [
                Text('Notifications',
                    style: Theme.of(context).textTheme.headlineMedium
                        ?.copyWith(fontSize: 20)),
                if (_unreadCount > 0) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('$_unreadCount',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700)),
                  ),
                ],
              ]),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _notifications.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 88, height: 88,
                            decoration: const BoxDecoration(
                                color: AppColors.cardWhite,
                                shape: BoxShape.circle),
                            child: const Icon(
                                Icons.notifications_none_rounded,
                                size: 40,
                                color: AppColors.textHint),
                          ),
                          const SizedBox(height: 16),
                          Text('No notifications',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(fontSize: 17)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _notifications.length,
                      itemBuilder: (context, index) {
                        final n = _notifications[index];
                        return GestureDetector(
                          onTap: () => _markOneRead(n.id),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: n.isRead
                                  ? AppColors.cardWhite
                                  : AppColors.primary.withOpacity(0.06),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: n.isRead
                                    ? AppColors.border
                                    : AppColors.primary.withOpacity(0.2),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 36, height: 36,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    n.type == 'order_update'
                                        ? Icons.receipt_long_outlined
                                        : Icons.local_offer_outlined,
                                    size: 18,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(n.message,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: n.isRead
                                                  ? FontWeight.w400
                                                  : FontWeight.w600,
                                              color: AppColors.textPrimary,
                                              height: 1.4)),
                                      const SizedBox(height: 4),
                                      Text(_timeAgo(n.createdAt),
                                          style: const TextStyle(
                                              fontSize: 11,
                                              color: AppColors.textHint)),
                                    ],
                                  ),
                                ),
                                if (!n.isRead)
                                  Container(
                                    width: 8, height: 8,
                                    margin: const EdgeInsets.only(top: 4),
                                    decoration: const BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
