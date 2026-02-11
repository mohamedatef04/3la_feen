import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ala_feen/core/utils/notifcations.dart/local.dart';
import 'package:ala_feen/core/utils/safe_emit.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final SupabaseClient _supabase = Supabase.instance.client;
  RealtimeChannel? _channel;
  String? _currentTripId;
  List<ChatMessage> _messages = [];

  ChatCubit() : super(ChatInitial());

  void getMessages(String tripId) {
    safeEmit(ChatLoading());
    _currentTripId = tripId;

    // Initial fetch
    _fetchMessages(tripId);

    // Subscribe to realtime changes
    _subscribeToRealtimeChanges(tripId);
  }

  Future<void> _fetchMessages(String tripId) async {
    try {
      final data = await _supabase
          .from('chat_messages')
          .select()
          .eq('trip_id', tripId)
          .order('created_at', ascending: true);

      _messages = (data as List).map((e) => ChatMessage.fromJson(e)).toList();
      safeEmit(ChatSuccess(messages: List.from(_messages)));
    } catch (error) {
      safeEmit(ChatFailure(errorMessage: error.toString()));
    }
  }

  void _subscribeToRealtimeChanges(String tripId) {
    // Remove any existing subscription
    _channel?.unsubscribe();

    // Create a new channel for this trip's messages
    _channel = _supabase.channel('chat_$tripId');

    _channel!
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'chat_messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'trip_id',
            value: tripId,
          ),
          callback: (payload) {
            final newMessage = ChatMessage.fromJson(payload.newRecord);
            _messages.add(newMessage);
            safeEmit(ChatSuccess(messages: List.from(_messages)));

            // Show notification for messages from other user
            if (!newMessage.isMe) {
              _showNewMessageNotification(newMessage);
            }
          },
        )
        .subscribe();
  }

  void _showNewMessageNotification(ChatMessage message) {
    try {
      LocalNotifications().showNotification(
        title: 'Ø±Ø³Ø§Ù„Ø© Ø¬Ø¯ÙŠØ¯Ø©',
        body: message.content,
        payload: 'chat_${_currentTripId}',
      );
    } catch (e) {
      // Ignore notification errors
    }
  }

  Future<void> sendMessage({
    required String tripId,
    required String content,
  }) async {
    try {
      final userId = _supabase.auth.currentUser!.id;

      // Optimistic update - add message locally first
      final optimisticMessage = ChatMessage(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        senderId: userId,
        content: content,
        createdAt: DateTime.now(),
      );
      _messages.add(optimisticMessage);
      safeEmit(ChatSuccess(messages: List.from(_messages)));

      // Send to server
      await _supabase.from('chat_messages').insert({
        'trip_id': tripId,
        'sender_id': userId,
        'content': content,
      });

      // Refresh to get the actual message with server-generated ID
      await _fetchMessages(tripId);
    } catch (e) {
      // Remove optimistic message on error
      _messages.removeWhere((m) => m.id.startsWith('temp_'));
      safeEmit(ChatSuccess(messages: List.from(_messages)));
    }
  }

  @override
  Future<void> close() {
    _channel?.unsubscribe();
    return super.close();
  }
}

