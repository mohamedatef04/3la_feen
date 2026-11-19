import 'package:ala_feen/core/utils/safe_emit.dart';
import 'package:ala_feen/features/home/passenger/data/repos/passenger_trip_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'rating_state.dart';

class RatingCubit extends Cubit<RatingState> {
  RatingCubit(this._repo) : super(RatingInitial());

  final PassengerTripRepo _repo;

  Future<void> submitRating({
    required String tripId,
    required String driverId,
    required String passengerId,
    required int rating,
    String? comment,
  }) async {
    safeEmit(RatingLoading());
    final result = await _repo.submitRating(
      tripId: tripId,
      driverId: driverId,
      passengerId: passengerId,
      rating: rating,
      comment: comment,
    );
    result.fold(
      (failure) => safeEmit(RatingFailure(errorMessage: failure.errorMessage)),
      (_) => safeEmit(RatingSuccess()),
    );
  }
}
