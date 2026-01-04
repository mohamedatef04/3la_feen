import 'package:ala_feen/features/auth/data/models/user_model.dart';
import 'package:ala_feen/features/home/driver/data/models/driver_model.dart';
import 'package:ala_feen/features/home/driver/data/models/offer_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class DriverRemoteDataSource {
  Future<UserModel?> getDriverData();
  Stream<List<TripModel>> getTrips();
  Future<void> updateStatus({required String id});
  Future<void> makeOffer({required OfferModel offer});
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
  Future<void> updateStatus({required String id}) async {
    try {
      await supabaseClient
          .from('trips')
          .update({
            'status': 'accepted',
            'driver_id': supabaseClient.auth.currentUser!.id,
          })
          .eq('id', id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> makeOffer({required OfferModel offer}) async {
    try {
      await supabaseClient.from('offers').insert(offer.toJson());
    } catch (e) {
      rethrow;
    }
  }
}
