import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ala_feen/core/utils/safe_emit.dart';

part 'driver_ratings_state.dart';

class DriverRatingsCubit extends Cubit<DriverRatingsState> {
  final SupabaseClient _supabase = Supabase.instance.client;

  DriverRatingsCubit() : super(DriverRatingsInitial());

  Future<void> getDriverRatings() async {
    safeEmit(DriverRatingsLoading());
    try {
      final driverId = _supabase.auth.currentUser?.id;
      if (driverId == null) {
        safeEmit(const DriverRatingsFailure('User not authenticated'));
        return;
      }

      final response = await _supabase
          .from('trip_ratings')
          .select()
          .eq('driver_id', driverId)
          .order('created_at', ascending: false);

      safeEmit(DriverRatingsSuccess(response));
    } catch (e) {
      safeEmit(DriverRatingsFailure(e.toString()));
    }
  }
}

