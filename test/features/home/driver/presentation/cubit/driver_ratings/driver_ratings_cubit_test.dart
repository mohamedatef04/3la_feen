import 'package:ala_feen/core/errors/failures.dart';
import 'package:ala_feen/features/home/driver/data/repo/driver_repo.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/driver_ratings/driver_ratings_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDriverRepo extends Mock implements DriverRepo {}

void main() {
  late MockDriverRepo repo;

  setUp(() => repo = MockDriverRepo());

  final ratings = [
    {'rating': 5, 'comment': 'Great'},
    {'rating': 4, 'comment': null},
  ];

  blocTest<DriverRatingsCubit, DriverRatingsState>(
    'emits [loading, success] with the driver\'s ratings',
    setUp: () =>
        when(() => repo.getMyRatings()).thenAnswer((_) async => Right(ratings)),
    build: () => DriverRatingsCubit(repo),
    act: (cubit) => cubit.getDriverRatings(),
    expect: () => [DriverRatingsLoading(), DriverRatingsSuccess(ratings)],
  );

  blocTest<DriverRatingsCubit, DriverRatingsState>(
    'emits [loading, success] with an empty list when there are no ratings',
    setUp: () => when(
      () => repo.getMyRatings(),
    ).thenAnswer((_) async => const Right([])),
    build: () => DriverRatingsCubit(repo),
    act: (cubit) => cubit.getDriverRatings(),
    expect: () => [DriverRatingsLoading(), const DriverRatingsSuccess([])],
  );

  blocTest<DriverRatingsCubit, DriverRatingsState>(
    'emits [loading, failure] when the ratings cannot be loaded',
    setUp: () => when(() => repo.getMyRatings()).thenAnswer(
      (_) async => Left(ServerFailure(errorMessage: 'No internet')),
    ),
    build: () => DriverRatingsCubit(repo),
    act: (cubit) => cubit.getDriverRatings(),
    expect: () => [
      DriverRatingsLoading(),
      const DriverRatingsFailure('No internet'),
    ],
  );
}
