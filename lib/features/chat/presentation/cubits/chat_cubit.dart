import 'dart:async';

import 'package:ala_feen/core/utils/safe_emit.dart';
import 'package:ala_feen/features/chat/data/models/chat_message.dart';
import 'package:ala_feen/features/chat/data/repos/chat_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

export 'package:ala_feen/features/chat/data/models/chat_message.dart';

part 'chat_state.dart';

/// Messages of one trip's chat. New messages arrive over realtime; messages
/// sent from this device show immediately as pending until the server
/// confirms them.
class ChatCubit extends Cubit<ChatState> {
  ChatCubit(this._repo) : super(ChatInitial());

  final ChatRepo _repo;
  StreamSubscription<ChatMessage>? _subscription;
  List<ChatMessage> _messages = [];
  int _pendingCounter = 0;

  Future<void> getMessages(String tripId) async {
    safeEmit(ChatLoading());

    await _subscription?.cancel();
    _subscription = _repo
        .watchNewMessages(tripId)
        .listen(_onIncoming, onError: (_) {});

    final result = await _repo.fetchMessages(tripId);
    result.fold(
      (failure) => safeEmit(ChatFailure(errorMessage: failure.errorMessage)),
      (messages) {
        // Keep anything realtime delivered while the initial fetch ran.
        final fetchedIds = messages.map((m) => m.id).toSet();
        _messages = [
          ...messages,
          ..._messages.where((m) => !fetchedIds.contains(m.id)),
        ];
        _emitMessages();
      },
    );
  }

  Future<void> sendMessage({
    required String tripId,
    required String content,
  }) async {
    final text = content.trim();
    if (text.isEmpty) return;

    final pending = ChatMessage(
      id: 'pending_${_pendingCounter++}',
      senderId: _repo.currentUserId ?? '',
      content: text,
      createdAt: DateTime.now(),
      isMe: true,
      isPending: true,
    );
    _messages = [..._messages, pending];
    _emitMessages();

    final result = await _repo.sendMessage(tripId: tripId, content: text);
    result.fold(
      (failure) {
        _messages = _messages.where((m) => m.id != pending.id).toList();
        _emitMessages(sendError: failure.errorMessage);
      },
      (saved) {
        final alreadyReceived = _messages.any((m) => m.id == saved.id);
        _messages = [
          for (final m in _messages)
            if (m.id != pending.id) m else if (!alreadyReceived) saved,
        ];
        _emitMessages();
      },
    );
  }

  void _onIncoming(ChatMessage message) {
    if (_messages.any((m) => m.id == message.id)) return;

    // Our own message echoed back by realtime replaces its pending copy.
    final pendingIndex = message.isMe
        ? _messages.indexWhere(
            (m) => m.isPending && m.content == message.content,
          )
        : -1;
    if (pendingIndex != -1) {
      _messages = [..._messages]..[pendingIndex] = message;
    } else {
      _messages = [..._messages, message];
    }
    _emitMessages();
  }

  void _emitMessages({String? sendError}) {
    safeEmit(
      ChatSuccess(messages: List.unmodifiable(_messages), sendError: sendError),
    );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
