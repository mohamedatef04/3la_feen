import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ala_feen/core/utils/safe_emit.dart';

part 'rating_state.dart';

class RatingCubit extends Cubit<RatingState> {
  final SupabaseClient _supabase = Supabase.instance.client;

  RatingCubit() : super(RatingInitial());

  Future<void> submitRating({
    required String tripId,
    required String driverId,
    required String passengerId,
    required int rating,
    String? comment,
  }) async {
    safeEmit(RatingLoading());

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        safeEmit(const RatingFailure(errorMessage: 'User not authenticated'));
        return;
      }

      await _supabase.from('trip_ratings').insert({
        'trip_id': tripId,
        'driver_id': driverId,
        'passenger_id': passengerId,
        'rating': rating,
        'comment': comment,
      });

      safeEmit(RatingSuccess());
    } catch (e) {
      safeEmit(RatingFailure(errorMessage: e.toString()));
    }
  }
}
