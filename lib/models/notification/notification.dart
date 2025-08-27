// models/notifications/notifications_response.dart
class NotificationsResponse {
  final String message;
  final List<NotificationItem> notifications;

  NotificationsResponse({
    required this.message,
    required this.notifications,
  });

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) {
    final list = (json['notifications'] as List? ?? [])
        .map((e) => NotificationItem.fromJson(e as Map<String, dynamic>))
        .toList();
    return NotificationsResponse(
      message: json['message']?.toString() ?? '',
      notifications: list,
    );
  }
}

class NotificationItem {
  final int id;
  final String notifiableType;
  final int notifiableId;
  final String title;
  final String body;
  final int isRead; // 0 or 1
  final DateTime? createdAt;
  final DateTime? updatedAt;

  NotificationItem({
    required this.id,
    required this.notifiableType,
    required this.notifiableId,
    required this.title,
    required this.body,
    required this.isRead,
    this.createdAt,
    this.updatedAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] as int,
      notifiableType: json['notifiable_type']?.toString() ?? '',
      notifiableId: json['notifiable_id'] is int
          ? json['notifiable_id'] as int
          : int.tryParse('${json['notifiable_id']}') ?? 0,
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      isRead: json['is_read'] is int
          ? json['is_read'] as int
          : int.tryParse('${json['is_read']}') ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }
}
