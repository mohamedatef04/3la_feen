import 'package:ala_feen/core/errors/failures.dart';
import 'package:ala_feen/features/home/passenger/data/repos/passenger_trip_repo.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/cancel_trip_cubit/cancel_trip_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPassengerTripRepo extends Mock implements PassengerTripRepo {}

void main() {
  late MockPassengerTripRepo repo;

  setUp(() => repo = MockPassengerTripRepo());

  blocTest<CancelTripCubit, CancelTripState>(
    'emits [loading, success] when the trip is cancelled',
    setUp: () => when(
      () => repo.cancelTrip('trip-1'),
    ).thenAnswer((_) async => const Right(null)),
    build: () => CancelTripCubit(repo),
    act: (cubit) => cubit.cancelTrip(tripId: 'trip-1'),
    expect: () => [CancelTripLoading(), CancelTripSuccess()],
  );

  blocTest<CancelTripCubit, CancelTripState>(
    'emits [loading, failure] with the repository message when cancelling fails',
    setUp: () => when(() => repo.cancelTrip('trip-1')).thenAnswer(
      (_) async => Left(ServerFailure(errorMessage: 'No internet')),
    ),
    build: () => CancelTripCubit(repo),
    act: (cubit) => cubit.cancelTrip(tripId: 'trip-1'),
    expect: () => [
      CancelTripLoading(),
      const CancelTripFailure(errorMessage: 'No internet'),
    ],
  );
}
