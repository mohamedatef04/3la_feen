import 'package:ala_feen/features/auth/data/models/user_model.dart';
import 'package:ala_feen/features/home/driver/data/dataSource/driver_remote_data_source.dart';
import 'package:ala_feen/features/home/passenger/data/models/trip_model.dart';
import 'package:ala_feen/features/home/driver/data/models/offer_model.dart';
import 'package:ala_feen/features/home/passenger/data/models/offer_model.dart';
import 'package:ala_feen/features/home/passenger/data/models/trip_model.dart';
import 'package:ala_feen/features/home/driver/data/repo/driver_repo.dart';

class DriverRepoImp implements DriverRepo {
  final DriverRemoteDataSource remoteDataSource;

  DriverRepoImp(this.remoteDataSource);
  @override
  Future<UserModel?> getDriverData() {
    try {
      return remoteDataSource.getDriverData();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<List<TripModel>> getTrips() {
    try {
      return remoteDataSource.getTrips();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<OfferModel> makeOffer({required OfferModel offer}) {
    try {
      return remoteDataSource.makeOffer(offer: offer);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<String?> getOfferStatus({required String offerId}) {
    try {
      return remoteDataSource.getOfferStatus(offerId: offerId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<TripModel?> getActiveTrip({required String driverId}) {
    try {
      return remoteDataSource.getActiveTrip(driverId: driverId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateTripStatus({
    required String tripId,
    required String status,
  }) {
    try {
      return remoteDataSource.updateTripStatus(tripId: tripId, status: status);
    } catch (e) {
      rethrow;
    }
  }
}
