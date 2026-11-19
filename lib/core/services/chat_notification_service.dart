import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ala_feen/core/utils/notifications/local.dart';

/// Global service that listens for new chat messages in the background
/// and shows notifications when the user is not in the chat screen.
class ChatNotificationService {
  ChatNotificationService._();
  static final ChatNotificationService _instance = ChatNotificationService._();
  factory ChatNotificationService() => _instance;

  final SupabaseClient _supabase = Supabase.instance.client;
  RealtimeChannel? _channel;
  StreamSubscription<AuthState>? _authSubscription;
  String? _currentUserId;
  String? _activeChatTripId; // The trip ID of the currently open chat screen

  bool _initialized = false;

  /// Initialize the service. Call this once when the app starts.
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    debugPrint('[ChatNotificationService] Initializing...');

    // Listen to auth state changes
    _authSubscription = _supabase.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null) {
        debugPrint(
          '[ChatNotificationService] User logged in: ${session.user.id}',
        );
        _currentUserId = session.user.id;
        _subscribeToAllMessages();
      } else {
        debugPrint('[ChatNotificationService] User logged out');
        _channel?.unsubscribe();
        _currentUserId = null;
      }
    });

    // Check if already logged in
    _currentUserId = _supabase.auth.currentUser?.id;
    if (_currentUserId != null) {
      debugPrint(
        '[ChatNotificationService] Already logged in: $_currentUserId',
      );
      _subscribeToAllMessages();
    } else {
      debugPrint(
        '[ChatNotificationService] Not logged in yet, waiting for auth',
      );
    }
  }

  /// Call this when user opens a chat screen to suppress notifications for that chat
  void setChatScreenActive(String? tripId) {
    debugPrint(
      '[ChatNotificationService] Chat screen active for trip: $tripId',
    );
    _activeChatTripId = tripId;
  }

  /// Call this when user closes a chat screen
  void setChatScreenInactive() {
    debugPrint('[ChatNotificationService] Chat screen inactive');
    _activeChatTripId = null;
  }

  void _subscribeToAllMessages() {
    _channel?.unsubscribe();

    debugPrint('[ChatNotificationService] Subscribing to chat_messages...');

    _channel = _supabase.channel(
      'global_chat_notifications_${DateTime.now().millisecondsSinceEpoch}',
    );

    _channel!
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'chat_messages',
          callback: (payload) {
            debugPrint(
              '[ChatNotificationService] Received message: ${payload.newRecord}',
            );

            final record = payload.newRecord;
            if (record.isEmpty) {
              debugPrint('[ChatNotificationService] Empty record, ignoring');
              return;
            }

            final senderId = record['sender_id']?.toString();
            final tripId = record['trip_id']?.toString();
            final content = record['content']?.toString() ?? '';

            debugPrint(
              '[ChatNotificationService] senderId: $senderId, currentUserId: $_currentUserId',
            );
            debugPrint(
              '[ChatNotificationService] tripId: $tripId, activeChatTripId: $_activeChatTripId',
            );

            // Don't show notification if:
            // 1. The message is from the current user
            // 2. The user has that chat screen open
            if (senderId == _currentUserId) {
              debugPrint('[ChatNotificationService] Skipping - own message');
              return;
            }
            if (tripId == _activeChatTripId) {
              debugPrint('[ChatNotificationService] Skipping - chat is open');
              return;
            }

            debugPrint('[ChatNotificationService] Showing notification!');
            _showNotification(content);
          },
        )
        .subscribe((status, error) {
          debugPrint(
            '[ChatNotificationService] Subscription status: $status, error: $error',
          );
        });
  }

  void _showNotification(String content) {
    try {
      LocalNotifications().showNotification(
        title: 'رسالة جديدة 💬',
        body: content,
        payload: 'chat',
      );
      debugPrint('[ChatNotificationService] Notification shown successfully');
    } catch (e) {
      debugPrint('[ChatNotificationService] Notification error: $e');
    }
  }

  void dispose() {
    _authSubscription?.cancel();
    _channel?.unsubscribe();
  }
}
