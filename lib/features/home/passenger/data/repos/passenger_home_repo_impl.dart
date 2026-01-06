import 'package:ala_feen/core/errors/failures.dart';
import 'package:ala_feen/features/auth/data/models/user_model.dart';
import 'package:ala_feen/features/home/passenger/data/data_source/passenger_data_source.dart';
import 'package:ala_feen/features/home/passenger/data/models/offer_model.dart';
import 'package:ala_feen/features/home/passenger/data/models/osrm_route_model.dart';
import 'package:ala_feen/features/home/passenger/data/models/place_model.dart';
import 'package:ala_feen/features/home/passenger/data/models/trip_model.dart';
import 'package:ala_feen/features/home/passenger/data/repos/passenger_home_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:location/location.dart';

class PassengerHomeRepoImpl implements PassengerHomeRepo {
  final PassengerDataSource passengerDataSource;
  PassengerHomeRepoImpl(this.passengerDataSource);

  @override
  Future<Either<Failures, void>> getCurrentLocation(
    void Function(LocationData)? onData,
  ) async {
    try {
      await passengerDataSource.getCurrentLocation(onData);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failures, List<PlaceModel>>> searchPlaces(String query) async {
    try {
      final places = await passengerDataSource.searchPlaces(query);
      return Right(places);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioExeption(e));
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failures, OsrmRouteModel>> getRoute({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) async {
    try {
      final route = await passengerDataSource.getRoute(
        startLat: startLat,
        startLng: startLng,
        endLat: endLat,
        endLng: endLng,
      );
      return Right(route);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioExeption(e));
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failures, TripModel>> sendTripRequest({
    required TripModel tripModel,
  }) async {
    try {
      final trip = await passengerDataSource.sendTripRequest(
        tripModel: tripModel,
      );
      return Right(trip);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioExeption(e));
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failures, UserModel>> getUserById(String userId) async {
    try {
      final user = await passengerDataSource.getUserById(userId);
      return Right(user);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioExeption(e));
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Stream<Either<Failures, OfferModel>> getOffersStream({
    required String tripId,
  }) {
    return passengerDataSource
        .getOffersStream(tripId: tripId)
        .map<Either<Failures, OfferModel>>(
          (offer) => Right(offer),
        )
        .handleError((error) {
          return Left(
            ServerFailure(errorMessage: error.toString()),
          );
        });
  }
}
