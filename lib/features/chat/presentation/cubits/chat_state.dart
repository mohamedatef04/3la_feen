part of 'chat_cubit.dart';

class ChatMessage {
  final String id;
  final String senderId;
  final String content;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.content,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? '',
      senderId: json['sender_id'] ?? '',
      content: json['content'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  bool get isMe => senderId == Supabase.instance.client.auth.currentUser?.id;
}

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatSuccess extends ChatState {
  final List<ChatMessage> messages;

  const ChatSuccess({required this.messages});

  @override
  List<Object> get props => [messages];
}

class ChatFailure extends ChatState {
  final String errorMessage;

  const ChatFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
