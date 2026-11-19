part of 'notifications_cubit.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsSuccess extends NotificationsState {
  final List<NotificationModel> notifications;

  const NotificationsSuccess({required this.notifications});

  @override
  List<Object> get props => [notifications];
}

class NotificationsFailure extends NotificationsState {
  final String errorMessage;

  const NotificationsFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
