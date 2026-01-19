import 'package:ala_feen/features/auth/data/models/user_model.dart';
import 'package:ala_feen/features/home/passenger/data/models/trip_model.dart';
import 'package:ala_feen/features/home/driver/data/models/offer_model.dart';
import 'package:ala_feen/features/home/passenger/data/models/offer_model.dart';
import 'package:ala_feen/features/home/passenger/data/models/trip_model.dart';

abstract class DriverRepo {
  Future<UserModel?> getDriverData();
  Stream<List<TripModel>> getTrips();
  Future<OfferModel> makeOffer({required OfferModel offer});
  Stream<String?> getOfferStatus({required String offerId});
  Stream<TripModel?> getActiveTrip({required String driverId});
  Future<void> updateTripStatus({
    required String tripId,
    required String status,
  });
}
