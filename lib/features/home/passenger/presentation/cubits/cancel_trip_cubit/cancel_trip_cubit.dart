import 'package:ala_feen/core/utils/safe_emit.dart';
import 'package:ala_feen/features/home/passenger/data/repos/passenger_trip_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'cancel_trip_state.dart';

class CancelTripCubit extends Cubit<CancelTripState> {
  CancelTripCubit(this._repo) : super(CancelTripInitial());

  final PassengerTripRepo _repo;

  Future<void> cancelTrip({required String tripId}) async {
    safeEmit(CancelTripLoading());
    final result = await _repo.cancelTrip(tripId);
    result.fold(
      (failure) => safeEmit(CancelTripFailure(errorMessage: failure.errorMessage)),
      (_) => safeEmit(CancelTripSuccess()),
    );
  }
}
