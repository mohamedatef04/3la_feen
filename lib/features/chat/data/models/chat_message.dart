import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.content,
    required this.createdAt,
    required this.isMe,
    this.isPending = false,
  });

  final String id;
  final String senderId;
  final String content;
  final DateTime createdAt;

  /// Whether the signed-in user sent this message.
  final bool isMe;

  /// True while a message sent from this device is waiting for the server.
  final bool isPending;

  factory ChatMessage.fromJson(
    Map<String, dynamic> json, {
    required String? currentUserId,
  }) {
    final senderId = json['sender_id']?.toString() ?? '';
    return ChatMessage(
      id: json['id']?.toString() ?? '',
      senderId: senderId,
      content: json['content']?.toString() ?? '',
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '')?.toLocal() ??
          DateTime.now(),
      isMe: senderId.isNotEmpty && senderId == currentUserId,
    );
  }

  @override
  List<Object?> get props => [id, senderId, content, createdAt, isMe, isPending];
}
