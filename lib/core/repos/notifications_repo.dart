import 'package:ala_feen/core/errors/custom_exeption.dart';
import 'package:ala_feen/core/errors/error_handler.dart';
import 'package:ala_feen/core/errors/failures.dart';
import 'package:ala_feen/core/models/notification_model.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// In-app notifications of the signed-in user.
abstract class NotificationsRepo {
  Future<Either<Failures, List<NotificationModel>>> getNotifications();
  Future<Either<Failures, void>> markAsRead(String notificationId);
  Future<Either<Failures, void>> markAllAsRead();
}

class NotificationsRepoImpl implements NotificationsRepo {
  NotificationsRepoImpl(this._supabase);

  final SupabaseClient _supabase;

  String get _userId {
    final id = _supabase.auth.currentUser?.id;
    if (id == null) {
      throw const CustomExeption(errorMessage: 'User not logged in');
    }
    return id;
  }

  @override
  Future<Either<Failures, List<NotificationModel>>> getNotifications() =>
      _guard(() async {
        final rows = await _supabase
            .from('notifications')
            .select()
            .eq('user_id', _userId)
            .order('created_at', ascending: false);
        return rows.map(NotificationModel.fromJson).toList();
      });

  @override
  Future<Either<Failures, void>> markAsRead(String notificationId) =>
      _guard(() async {
        await _supabase
            .from('notifications')
            .update({'is_read': true})
            .eq('id', notificationId);
      });

  @override
  Future<Either<Failures, void>> markAllAsRead() => _guard(() async {
    await _supabase
        .from('notifications')
        .update({'is_read': true})
        .eq('user_id', _userId);
  });

  Future<Either<Failures, T>> _guard<T>(Future<T> Function() call) async {
    try {
      return Right(await call());
    } on CustomExeption catch (e) {
      return Left(ServerFailure(errorMessage: e.errorMessage));
    } catch (e) {
      return Left(ServerFailure(errorMessage: ErrorHandler.getMessage(e)));
    }
  }
}
