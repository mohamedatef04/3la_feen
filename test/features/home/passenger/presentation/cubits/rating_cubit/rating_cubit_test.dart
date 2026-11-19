import 'package:ala_feen/core/errors/failures.dart';
import 'package:ala_feen/features/home/passenger/data/repos/passenger_trip_repo.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/rating_cubit/rating_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPassengerTripRepo extends Mock implements PassengerTripRepo {}

void main() {
  late MockPassengerTripRepo repo;

  setUp(() => repo = MockPassengerTripRepo());

  void stubSubmit(Either<Failures, void> result) {
    when(
      () => repo.submitRating(
        tripId: 'trip-1',
        driverId: 'driver-1',
        passengerId: 'passenger-1',
        rating: 5,
        comment: 'Great ride',
      ),
    ).thenAnswer((_) async => result);
  }

  Future<void> rate(RatingCubit cubit) => cubit.submitRating(
    tripId: 'trip-1',
    driverId: 'driver-1',
    passengerId: 'passenger-1',
    rating: 5,
    comment: 'Great ride',
  );

  blocTest<RatingCubit, RatingState>(
    'emits [loading, success] when the rating is saved',
    setUp: () => stubSubmit(const Right(null)),
    build: () => RatingCubit(repo),
    act: rate,
    expect: () => [RatingLoading(), RatingSuccess()],
  );

  blocTest<RatingCubit, RatingState>(
    'emits [loading, failure] when the user is signed out',
    setUp: () =>
        stubSubmit(Left(ServerFailure(errorMessage: 'User not authenticated'))),
    build: () => RatingCubit(repo),
    act: rate,
    expect: () => [
      RatingLoading(),
      const RatingFailure(errorMessage: 'User not authenticated'),
    ],
  );
}
