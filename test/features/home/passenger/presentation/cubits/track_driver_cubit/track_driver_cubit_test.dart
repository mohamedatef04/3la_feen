import 'dart:async';

import 'package:ala_feen/core/errors/failures.dart';
import 'package:ala_feen/features/home/passenger/data/repos/passenger_trip_repo.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/track_driver_cubit/track_driver_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mocktail/mocktail.dart';

class MockPassengerTripRepo extends Mock implements PassengerTripRepo {}

void main() {
  const driverId = 'driver-1';
  const start = LatLng(30.04, 31.23);
  const moved = LatLng(30.05, 31.24);

  late MockPassengerTripRepo repo;
  late StreamController<LatLng> live;

  setUp(() {
    repo = MockPassengerTripRepo();
    live = StreamController<LatLng>.broadcast();
    when(
      () => repo.watchDriverLocation(driverId),
    ).thenAnswer((_) => live.stream);
  });

  tearDown(() => live.close());

  // A long poll interval keeps the backup timer out of these tests.
  TrackDriverCubit build() =>
      TrackDriverCubit(repo, pollInterval: const Duration(hours: 1));

  blocTest<TrackDriverCubit, TrackDriverState>(
    'emits the stored location first, then each realtime update',
    setUp: () => when(
      () => repo.fetchDriverLocation(driverId),
    ).thenAnswer((_) async => const Right(start)),
    build: build,
    act: (cubit) async {
      cubit.trackDriver(driverId);
      await Future<void>.delayed(Duration.zero);
      live.add(moved);
      await Future<void>.delayed(Duration.zero);
    },
    expect: () => [
      TrackDriverLoading(),
      isA<TrackDriverUpdate>().having((s) => s.driverLocation, 'loc', start),
      isA<TrackDriverUpdate>().having((s) => s.driverLocation, 'loc', moved),
    ],
  );

  blocTest<TrackDriverCubit, TrackDriverState>(
    'stays loading when the first fetch fails, and recovers on a realtime update',
    setUp: () => when(() => repo.fetchDriverLocation(driverId)).thenAnswer(
      (_) async => Left(ServerFailure(errorMessage: 'offline')),
    ),
    build: build,
    act: (cubit) async {
      cubit.trackDriver(driverId);
      await Future<void>.delayed(Duration.zero);
      live.add(moved);
      await Future<void>.delayed(Duration.zero);
    },
    expect: () => [
      TrackDriverLoading(),
      isA<TrackDriverUpdate>().having((s) => s.driverLocation, 'loc', moved),
    ],
  );
}
