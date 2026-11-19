class NotificationModel {
  final String? id;
  final String? userId;
  final String? title;
  final String? body;
  final String? type; // 'trip', 'offer', 'system', 'promo'
  final bool? isRead;
  final DateTime? createdAt;

  NotificationModel({
    this.id,
    this.userId,
    this.title,
    this.body,
    this.type,
    this.isRead,
    this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json['id']?.toString(),
        userId: json['user_id']?.toString(),
        title: json['title']?.toString(),
        body: json['body']?.toString(),
        type: json['type']?.toString(),
        isRead: json['is_read'] ?? false,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : null,
      );

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'title': title,
    'body': body,
    'type': type,
    'is_read': isRead,
  };
}
