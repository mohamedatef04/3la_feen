import 'package:ala_feen/core/errors/failures.dart';
import 'package:ala_feen/features/auth/data/models/user_model.dart';
import 'package:ala_feen/features/home/passenger/data/models/offer_model.dart';
import 'package:ala_feen/features/home/passenger/data/models/osrm_route_model.dart';
import 'package:ala_feen/features/home/passenger/data/models/place_model.dart';
import 'package:ala_feen/features/home/passenger/data/models/trip_model.dart';
import 'package:dartz/dartz.dart';
import 'package:location/location.dart';

abstract class PassengerHomeRepo {
  Future<Either<Failures, void>> getCurrentLocation(
    void Function(LocationData)? onData,
  );
  Future<Either<Failures, List<PlaceModel>>> searchPlaces(String query);
  Future<Either<Failures, OsrmRouteModel>> getRoute({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  });
  Future<Either<Failures, TripModel>> sendTripRequest({
    required TripModel tripModel,
  });
  Future<Either<Failures, UserModel>> getUserById(String userId);
  Stream<Either<Failures, OfferModel>> getOffersStream({
    required String tripId,
  });
}
