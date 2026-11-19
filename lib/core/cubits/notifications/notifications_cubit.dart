import 'package:ala_feen/core/models/notification_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ala_feen/core/utils/safe_emit.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsInitial());

  final _supabase = Supabase.instance.client;

  Future<void> getNotifications() async {
    safeEmit(NotificationsLoading());
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        safeEmit(const NotificationsFailure(errorMessage: 'User not logged in'));
        return;
      }

      final response = await _supabase
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final notifications = (response as List)
          .map((json) => NotificationModel.fromJson(json))
          .toList();

      safeEmit(NotificationsSuccess(notifications: notifications));
    } catch (e) {
      safeEmit(NotificationsFailure(errorMessage: e.toString()));
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _supabase
          .from('notifications')
          .update({'is_read': true})
          .eq('id', notificationId);

      // Refresh the list
      getNotifications();
    } catch (e) {
      // Silent fail for mark as read
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      await _supabase
          .from('notifications')
          .update({'is_read': true})
          .eq('user_id', userId);

      // Refresh the list
      getNotifications();
    } catch (e) {
      // Silent fail
    }
  }
}

