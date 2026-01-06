import 'package:ala_feen/features/auth/data/models/user_model.dart';
import 'package:ala_feen/features/home/passenger/data/models/offer_model.dart';
import 'package:ala_feen/features/home/passenger/data/models/trip_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class DriverRemoteDataSource {
  Future<UserModel?> getDriverData();
  Stream<List<TripModel>> getTrips();
  Future<OfferModel> makeOffer({required OfferModel offer});
  Stream<String?> getOfferStatus({required String offerId});
}

class DriverRemoteDataSourceImpl implements DriverRemoteDataSource {
  final SupabaseClient supabaseClient;
  DriverRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<UserModel?> getDriverData() async {
    try {
      final data = await supabaseClient
          .from('users')
          .select()
          .eq('id', supabaseClient.auth.currentUser!.id)
          .single();
      return UserModel.fromJson(data);
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
}
