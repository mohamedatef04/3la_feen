import 'package:ala_feen/core/errors/custom_exeption.dart';
import 'package:ala_feen/core/errors/error_handler.dart';
import 'package:ala_feen/core/errors/failures.dart';
import 'package:ala_feen/features/home/passenger/data/data_source/passenger_trip_data_source.dart';
import 'package:ala_feen/features/home/passenger/data/models/trip_model.dart';
import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class PassengerTripRepo {
  Future<Either<Failures, TripModel?>> fetchTrip(String tripId);
  Future<Either<Failures, TripModel?>> fetchLatestActiveTrip(
    String passengerId,
  );
  Stream<TripModel> watchTrip(String tripId);
  Future<Either<Failures, LatLng?>> fetchDriverLocation(String driverId);
  Stream<LatLng> watchDriverLocation(String driverId);
  Future<Either<Failures, void>> cancelTrip(String tripId);
  Future<Either<Failures, void>> submitRating({
    required String tripId,
    required String driverId,
    required String passengerId,
    required int rating,
    String? comment,
  });
}

class PassengerTripRepoImpl implements PassengerTripRepo {
  PassengerTripRepoImpl(this._dataSource);

  final PassengerTripDataSource _dataSource;

  @override
  Future<Either<Failures, TripModel?>> fetchTrip(String tripId) =>
      _guard(() => _dataSource.fetchTrip(tripId));

  @override
  Future<Either<Failures, TripModel?>> fetchLatestActiveTrip(
    String passengerId,
  ) => _guard(() => _dataSource.fetchLatestActiveTrip(passengerId));

  @override
  Stream<TripModel> watchTrip(String tripId) => _dataSource.watchTrip(tripId);

  @override
  Future<Either<Failures, LatLng?>> fetchDriverLocation(String driverId) =>
      _guard(() => _dataSource.fetchDriverLocation(driverId));

  @override
  Stream<LatLng> watchDriverLocation(String driverId) =>
      _dataSource.watchDriverLocation(driverId);

  @override
  Future<Either<Failures, void>> cancelTrip(String tripId) =>
      _guard(() => _dataSource.cancelTrip(tripId));

  @override
  Future<Either<Failures, void>> submitRating({
    required String tripId,
    required String driverId,
    required String passengerId,
    required int rating,
    String? comment,
  }) => _guard(
    () => _dataSource.submitRating(
      tripId: tripId,
      driverId: driverId,
      passengerId: passengerId,
      rating: rating,
      comment: comment,
    ),
  );

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
