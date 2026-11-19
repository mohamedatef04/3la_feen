part of 'chat_cubit.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatSuccess extends ChatState {
  final List<ChatMessage> messages;

  /// Set once when sending a message failed, so the screen can tell the user.
  final String? sendError;

  const ChatSuccess({required this.messages, this.sendError});

  @override
  List<Object?> get props => [messages, sendError];
}

class ChatFailure extends ChatState {
  final String errorMessage;

  const ChatFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
