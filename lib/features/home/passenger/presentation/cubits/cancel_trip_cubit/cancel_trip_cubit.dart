import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ala_feen/core/utils/safe_emit.dart';

part 'cancel_trip_state.dart';

class CancelTripCubit extends Cubit<CancelTripState> {
  final SupabaseClient _supabase = Supabase.instance.client;

  CancelTripCubit() : super(CancelTripInitial());

  Future<void> cancelTrip({required String tripId}) async {
    safeEmit(CancelTripLoading());
    try {
      await _supabase
          .from('trips')
          .update({'status': 'cancelled'})
          .eq('id', tripId);

      safeEmit(CancelTripSuccess());
    } catch (e) {
      safeEmit(CancelTripFailure(errorMessage: e.toString()));
    }
  }
}

