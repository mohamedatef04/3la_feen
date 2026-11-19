import 'dart:async';

import 'package:ala_feen/core/errors/custom_exeption.dart';
import 'package:ala_feen/features/chat/data/models/chat_message.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ChatDataSource {
  String? get currentUserId;
  Future<List<ChatMessage>> fetchMessages(String tripId);
  Stream<ChatMessage> watchNewMessages(String tripId);
  Future<ChatMessage> sendMessage({
    required String tripId,
    required String content,
  });
}

class ChatDataSourceImpl implements ChatDataSource {
  ChatDataSourceImpl(this._supabase);

  final SupabaseClient _supabase;

  @override
  String? get currentUserId => _supabase.auth.currentUser?.id;

  @override
  Future<List<ChatMessage>> fetchMessages(String tripId) async {
    final rows = await _supabase
        .from('chat_messages')
        .select()
        .eq('trip_id', tripId)
        .order('created_at', ascending: true);
    return rows
        .map((row) => ChatMessage.fromJson(row, currentUserId: currentUserId))
        .toList();
  }

  @override
  Stream<ChatMessage> watchNewMessages(String tripId) {
    late final RealtimeChannel channel;
    final controller = StreamController<ChatMessage>(
      onCancel: () => _supabase.removeChannel(channel),
    );

    channel = _supabase
        .channel('chat_$tripId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'chat_messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'trip_id',
            value: tripId,
          ),
          callback: (payload) => controller.add(
            ChatMessage.fromJson(
              payload.newRecord,
              currentUserId: currentUserId,
            ),
          ),
        )
        .subscribe();

    return controller.stream;
  }

  @override
  Future<ChatMessage> sendMessage({
    required String tripId,
    required String content,
  }) async {
    final userId = currentUserId;
    if (userId == null) {
      throw const CustomExeption(errorMessage: 'User not authenticated');
    }
    final row = await _supabase
        .from('chat_messages')
        .insert({'trip_id': tripId, 'sender_id': userId, 'content': content})
        .select()
        .single();
    return ChatMessage.fromJson(row, currentUserId: userId);
  }
}
