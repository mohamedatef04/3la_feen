import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable {
  final String? id;
  final String? title;
  final String? body;
  final String? createdAt;
  final bool? isRead;
  final Map<String, dynamic>? data;

  const NotificationModel({
    this.id,
    this.title,
    this.body,
    this.createdAt,
    this.isRead,
    this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String?,
      title: json['title'] as String?,
      body: json['body'] as String?,
      createdAt: json['created_at'] as String?,
      isRead: json['is_read'] as bool?,
      data: json['data'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'id': id,
      'title': title,
      'body': body,
      'created_at': createdAt,
      'is_read': isRead,
      'data': data,
    };
    return json;
  }

  @override
  List<Object?> get props => [id, title, body, createdAt, isRead, data];
}
