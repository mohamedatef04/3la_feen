import 'dart:async';

import 'package:ala_feen/core/errors/failures.dart';
import 'package:ala_feen/features/home/passenger/data/models/trip_model.dart';
import 'package:ala_feen/features/home/passenger/data/repos/passenger_trip_repo.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/passenger_trip_monitor_cubit/passenger_trip_monitor_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPassengerTripRepo extends Mock implements PassengerTripRepo {}

void main() {
  const tripId = 'trip-1';

  late MockPassengerTripRepo repo;
  late StreamController<TripModel> live;
  late List<String> notifications;
  late PassengerTripMonitorCubit cubit;

  TripModel trip(String status) => TripModel(tripId: tripId, status: status);

  setUp(() {
    repo = MockPassengerTripRepo();
    live = StreamController<TripModel>.broadcast();
    notifications = [];
    when(() => repo.watchTrip(tripId)).thenAnswer((_) => live.stream);
    when(
      () => repo.fetchTrip(tripId),
    ).thenAnswer((_) async => Right(trip('accepted')));

    cubit = PassengerTripMonitorCubit(
      repo,
      notify: ({required title, required body, required payload}) =>
          notifications.add(title),
      pollInterval: const Duration(hours: 1),
    );
  });

  tearDown(() async {
    await cubit.close();
    await live.close();
  });

  Future<void> flush() => Future<void>.delayed(Duration.zero);

  test('loads the current status of the trip', () async {
    cubit.monitorTrip(tripId);
    expect(cubit.state.status, PassengerTripStatus.loading);

    await flush();

    expect(cubit.state.status, PassengerTripStatus.accepted);
    expect(cubit.state.trip?.tripId, tripId);
  });

  test('follows realtime status changes and notifies on each change', () async {
    cubit.monitorTrip(tripId);
    await flush();

    live.add(trip('driver_arrived'));
    await flush();
    live.add(trip('started'));
    await flush();

    expect(cubit.state.status, PassengerTripStatus.started);
    // Translations aren't loaded in unit tests, so tr() returns the key.
    expect(notifications, [
      'trip_status.driver_arrived_title',
      'trip_status.started_title',
    ]);
  });

  test('does not notify when the status repeats', () async {
    cubit.monitorTrip(tripId);
    await flush();

    live.add(trip('accepted'));
    await flush();

    expect(notifications, isEmpty);
  });

  group('monitorActiveTrip', () {
    test('starts monitoring the passenger\'s trip in progress', () async {
      when(
        () => repo.fetchLatestActiveTrip('passenger-1'),
      ).thenAnswer((_) async => Right(trip('started')));

      await cubit.monitorActiveTrip('passenger-1');
      await flush();

      verify(() => repo.watchTrip(tripId)).called(1);
      expect(cubit.state.status, PassengerTripStatus.accepted);
    });

    test('stays idle when there is no trip in progress', () async {
      when(
        () => repo.fetchLatestActiveTrip('passenger-1'),
      ).thenAnswer((_) async => const Right(null));

      await cubit.monitorActiveTrip('passenger-1');

      expect(cubit.state.status, PassengerTripStatus.initial);
      verifyNever(() => repo.watchTrip(any()));
    });

    test('stays idle when the lookup fails', () async {
      when(() => repo.fetchLatestActiveTrip('passenger-1')).thenAnswer(
        (_) async => Left(ServerFailure(errorMessage: 'offline')),
      );

      await cubit.monitorActiveTrip('passenger-1');

      expect(cubit.state.status, PassengerTripStatus.initial);
    });
  });

  test('maps database status strings to trip statuses', () {
    expect(
      PassengerTripMonitorCubit.statusFromString('driver_arrived'),
      PassengerTripStatus.driverArrived,
    );
    expect(
      PassengerTripMonitorCubit.statusFromString('cancelled'),
      PassengerTripStatus.cancelled,
    );
    expect(
      PassengerTripMonitorCubit.statusFromString(null),
      PassengerTripStatus.accepted,
    );
  });
}
