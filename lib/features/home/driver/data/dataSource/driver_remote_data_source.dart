import 'package:ala_feen/core/errors/custom_exeption.dart';
import 'package:ala_feen/features/auth/data/models/user_model.dart';
import 'package:ala_feen/features/home/passenger/data/models/trip_model.dart';
import 'package:ala_feen/features/home/passenger/data/models/offer_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class DriverRemoteDataSource {
  Future<UserModel?> getDriverData();
  Stream<List<TripModel>> getTrips();
  Future<OfferModel> makeOffer({required OfferModel offer});
  Stream<String?> getOfferStatus({required String offerId});
  Stream<TripModel?> getActiveTrip({required String driverId});
  Future<void> updateTripStatus({
    required String tripId,
    required String status,
  });
  Future<UserModel?> getPassengerData(String passengerId);
  Future<List<Map<String, dynamic>>> getMyRatings();
}

class DriverRemoteDataSourceImpl implements DriverRemoteDataSource {
  final SupabaseClient supabaseClient;
  DriverRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<Map<String, dynamic>>> getMyRatings() async {
    final driverId = supabaseClient.auth.currentUser?.id;
    if (driverId == null) {
      throw const CustomExeption(errorMessage: 'User not authenticated');
    }
    return supabaseClient
        .from('trip_ratings')
        .select()
        .eq('driver_id', driverId)
        .order('created_at', ascending: false);
  }

  @override
  Future<UserModel?> getDriverData() async {
    try {
      final data = await supabaseClient
          .from('users')
          .select()
          .eq('id', supabaseClient.auth.currentUser!.id)
          .single();

      // Fetch average rating
      final ratingsResponse = await supabaseClient
          .from('trip_ratings')
          .select('rating')
          .eq('driver_id', supabaseClient.auth.currentUser!.id);

      double? averageRating;
      if (ratingsResponse.isNotEmpty) {
        final totalRating = ratingsResponse.fold<int>(
          0,
          (sum, item) => sum + (item['rating'] as int),
        );
        averageRating = totalRating / ratingsResponse.length;
      }

      return UserModel.fromJson(data).copyWith(rating: averageRating);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<List<TripModel>> getTrips() {
    try {
      return supabaseClient.from('trips').stream(primaryKey: ['id']).map((
        data,
      ) {
        return data.map((e) => TripModel.fromJson(e)).toList();
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<OfferModel> makeOffer({required OfferModel offer}) async {
    try {
      final data = await supabaseClient
          .from('offers')
          .insert(offer.toJson())
          .select()
          .single();
      return OfferModel.fromJson(data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<String?> getOfferStatus({required String offerId}) {
    try {
      return supabaseClient
          .from('offers')
          .stream(primaryKey: ['id'])
          .eq('id', offerId)
          .map((data) {
            if (data.isEmpty) {
              return null;
            }
            return data.first['status'].toString();
          });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<TripModel?> getActiveTrip({required String driverId}) {
    try {
      return supabaseClient
          .from('trips')
          .stream(primaryKey: ['id'])
          .eq('driver_id', driverId)
          .map((data) {
            if (data.isEmpty) return null;

            // Active statuses: accepted, driver_arrived, started
            final activeStatuses = ['accepted', 'driver_arrived', 'started'];
            final activeTrips = data.where((e) {
              final status = e['status']?.toString();
              return activeStatuses.contains(status);
            });

            if (activeTrips.isEmpty) return null;

            return TripModel.fromJson(activeTrips.first);
          });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateTripStatus({
    required String tripId,
    required String status,
  }) async {
    try {
      await supabaseClient
          .from('trips')
          .update({'status': status})
          .eq('id', tripId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel?> getPassengerData(String passengerId) async {
    try {
      final data = await supabaseClient
          .from('users')
          .select()
          .eq('id', passengerId)
          .single();
      return UserModel.fromJson(data);
    } catch (e) {
      rethrow;
    }
  }
}
