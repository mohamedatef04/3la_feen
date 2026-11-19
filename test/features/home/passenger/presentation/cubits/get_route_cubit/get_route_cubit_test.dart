import 'package:ala_feen/core/errors/failures.dart';
import 'package:ala_feen/features/home/passenger/data/models/osrm_route_model.dart';
import 'package:ala_feen/features/home/passenger/data/repos/passenger_home_repo.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/get_route_cubit/get_route_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPassengerHomeRepo extends Mock implements PassengerHomeRepo {}

void main() {
  late MockPassengerHomeRepo repo;
  final route = OsrmRouteModel(code: 'Ok');

  setUp(() => repo = MockPassengerHomeRepo());

  void stubRoute(Either<Failures, OsrmRouteModel> result) {
    when(
      () => repo.getRoute(
        startLat: 30.04,
        startLng: 31.23,
        endLat: 30.11,
        endLng: 31.41,
      ),
    ).thenAnswer((_) async => result);
  }

  Future<void> requestRoute(GetRouteCubit cubit) => cubit.getRoute(
    startLat: 30.04,
    startLng: 31.23,
    endLat: 30.11,
    endLng: 31.41,
    startLocation: 'Tahrir',
    endLocation: 'Airport',
  );

  blocTest<GetRouteCubit, GetRouteState>(
    'emits [loading, success] carrying the route and both endpoints',
    setUp: () => stubRoute(Right(route)),
    build: () => GetRouteCubit(repo),
    act: requestRoute,
    expect: () => [
      GetRouteLoading(),
      GetRouteSuccess(
        route: route,
        startLocation: 'Tahrir',
        endLocation: 'Airport',
        startLat: 30.04,
        startLng: 31.23,
        endLat: 30.11,
        endLng: 31.41,
      ),
    ],
  );

  blocTest<GetRouteCubit, GetRouteState>(
    'emits [loading, failure] when the routing service fails',
    setUp: () =>
        stubRoute(Left(ServerFailure(errorMessage: 'Route not found'))),
    build: () => GetRouteCubit(repo),
    act: requestRoute,
    expect: () => [
      GetRouteLoading(),
      const GetRouteFailure(errorMessage: 'Route not found'),
    ],
  );

  blocTest<GetRouteCubit, GetRouteState>(
    'reset returns to the initial state',
    seed: () => const GetRouteFailure(errorMessage: 'x'),
    build: () => GetRouteCubit(repo),
    act: (cubit) => cubit.reset(),
    expect: () => [GetRouteInitial()],
  );
}
