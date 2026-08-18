

class AppNotification {
  final String id;
  final String type;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  const AppNotification({
    required this.id,
    required this.type,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });
}

/// Mock
final List<AppNotification> mockNotifications = [
  AppNotification(
    id: '1',
    type: 'order_update',
    message: 'Your order #101 is now being processed.',
    isRead: false,
    createdAt: DateTime(2026, 8, 15, 10, 30),
  ),
  AppNotification(
    id: '2',
    type: 'order_update',
    message: 'Your order #98 has been delivered successfully.',
    isRead: false,
    createdAt: DateTime(2026, 8, 12, 14, 0),
  ),
  AppNotification(
    id: '3',
    type: 'promo',
    message: 'New arrivals are here! Check out the latest collection.',
    isRead: true,
    createdAt: DateTime(2026, 8, 10, 9, 0),
  ),
  AppNotification(
    id: '4',
    type: 'order_update',
    message: 'Your order #92 has been confirmed.',
    isRead: true,
    createdAt: DateTime(2026, 8, 5, 11, 20),
  ),
];
