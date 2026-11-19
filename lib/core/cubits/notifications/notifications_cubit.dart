import 'package:ala_feen/core/models/notification_model.dart';
import 'package:ala_feen/core/repos/notifications_repo.dart';
import 'package:ala_feen/core/utils/safe_emit.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this._repo) : super(NotificationsInitial());

  final NotificationsRepo _repo;

  Future<void> getNotifications() async {
    safeEmit(NotificationsLoading());
    await _load();
  }

  /// Marks one notification as read, then reloads the list in place.
  /// A failure keeps the current list; the item simply stays unread.
  Future<void> markAsRead(String notificationId) async {
    final result = await _repo.markAsRead(notificationId);
    if (result.isRight()) await _load();
  }

  Future<void> markAllAsRead() async {
    final result = await _repo.markAllAsRead();
    if (result.isRight()) await _load();
  }

  Future<void> _load() async {
    final result = await _repo.getNotifications();
    result.fold(
      (failure) =>
          safeEmit(NotificationsFailure(errorMessage: failure.errorMessage)),
      (notifications) =>
          safeEmit(NotificationsSuccess(notifications: notifications)),
    );
  }
}
