import 'package:ala_feen/core/errors/failures.dart';
import 'package:ala_feen/features/home/passenger/data/models/trip_model.dart';
import 'package:ala_feen/features/home/passenger/data/repos/passenger_home_repo.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/send_trip_cubit/send_trip_request_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPassengerHomeRepo extends Mock implements PassengerHomeRepo {}

void main() {
  late MockPassengerHomeRepo repo;

  final request = TripModel(
    passengerId: 'passenger-1',
    originAddress: 'Tahrir Square',
    distAddress: 'Cairo Airport',
    tripPrice: 150,
    status: 'pending',
  );
  final savedTrip = TripModel(
    tripId: 'trip-42',
    passengerId: 'passenger-1',
    status: 'pending',
  );

  setUp(() => repo = MockPassengerHomeRepo());

  test('initial state is SendTripRequestInitial', () {
    expect(SendTripRequestCubit(repo).state, SendTripRequestInitial());
  });

  blocTest<SendTripRequestCubit, SendTripRequestState>(
    'emits [loading, success] with the saved trip when the request is stored',
    setUp: () => when(
      () => repo.sendTripRequest(tripModel: request),
    ).thenAnswer((_) async => Right(savedTrip)),
    build: () => SendTripRequestCubit(repo),
    act: (cubit) => cubit.sendTripRequest(tripModel: request),
    expect: () => [
      SendTripRequestLoading(),
      SendTripRequestSuccess(tripModel: savedTrip),
    ],
    verify: (_) =>
        verify(() => repo.sendTripRequest(tripModel: request)).called(1),
  );

  blocTest<SendTripRequestCubit, SendTripRequestState>(
    'emits [loading, failure] with the repository message when the request fails',
    setUp: () => when(
      () => repo.sendTripRequest(tripModel: request),
    ).thenAnswer((_) async => Left(ServerFailure(errorMessage: 'No internet'))),
    build: () => SendTripRequestCubit(repo),
    act: (cubit) => cubit.sendTripRequest(tripModel: request),
    expect: () => [
      SendTripRequestLoading(),
      const SendTripRequestFailure(errorMessage: 'No internet'),
    ],
  );

  test('failure states with different messages are not equal', () {
    expect(
      const SendTripRequestFailure(errorMessage: 'a'),
      isNot(const SendTripRequestFailure(errorMessage: 'b')),
    );
  });
}
