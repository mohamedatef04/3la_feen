import 'package:ala_feen/core/cubits/notifications/notifications_cubit.dart';
import 'package:ala_feen/core/errors/failures.dart';
import 'package:ala_feen/core/models/notification_model.dart';
import 'package:ala_feen/core/repos/notifications_repo.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationsRepo extends Mock implements NotificationsRepo {}

void main() {
  late MockNotificationsRepo repo;
  final unread = <NotificationModel>[NotificationModel()];
  final read = <NotificationModel>[];

  setUp(() => repo = MockNotificationsRepo());

  group('getNotifications', () {
    blocTest<NotificationsCubit, NotificationsState>(
      'emits [loading, success] with the user\'s notifications',
      setUp: () => when(
        () => repo.getNotifications(),
      ).thenAnswer((_) async => Right(unread)),
      build: () => NotificationsCubit(repo),
      act: (cubit) => cubit.getNotifications(),
      expect: () => [
        NotificationsLoading(),
        NotificationsSuccess(notifications: unread),
      ],
    );

    blocTest<NotificationsCubit, NotificationsState>(
      'emits [loading, failure] when the user is signed out',
      setUp: () => when(() => repo.getNotifications()).thenAnswer(
        (_) async => Left(ServerFailure(errorMessage: 'User not logged in')),
      ),
      build: () => NotificationsCubit(repo),
      act: (cubit) => cubit.getNotifications(),
      expect: () => [
        NotificationsLoading(),
        const NotificationsFailure(errorMessage: 'User not logged in'),
      ],
    );
  });

  group('markAsRead', () {
    blocTest<NotificationsCubit, NotificationsState>(
      'reloads the list without a loading flash when marking succeeds',
      setUp: () {
        when(
          () => repo.markAsRead('n-1'),
        ).thenAnswer((_) async => const Right(null));
        when(
          () => repo.getNotifications(),
        ).thenAnswer((_) async => Right(read));
      },
      build: () => NotificationsCubit(repo),
      seed: () => NotificationsSuccess(notifications: unread),
      act: (cubit) => cubit.markAsRead('n-1'),
      expect: () => [NotificationsSuccess(notifications: read)],
    );

    blocTest<NotificationsCubit, NotificationsState>(
      'keeps the current list when marking fails',
      setUp: () => when(() => repo.markAsRead('n-1')).thenAnswer(
        (_) async => Left(ServerFailure(errorMessage: 'offline')),
      ),
      build: () => NotificationsCubit(repo),
      seed: () => NotificationsSuccess(notifications: unread),
      act: (cubit) => cubit.markAsRead('n-1'),
      expect: () => <NotificationsState>[],
      verify: (_) => verifyNever(() => repo.getNotifications()),
    );
  });

  blocTest<NotificationsCubit, NotificationsState>(
    'markAllAsRead reloads the list when it succeeds',
    setUp: () {
      when(
        () => repo.markAllAsRead(),
      ).thenAnswer((_) async => const Right(null));
      when(() => repo.getNotifications()).thenAnswer((_) async => Right(read));
    },
    build: () => NotificationsCubit(repo),
    act: (cubit) => cubit.markAllAsRead(),
    expect: () => [NotificationsSuccess(notifications: read)],
  );
}
