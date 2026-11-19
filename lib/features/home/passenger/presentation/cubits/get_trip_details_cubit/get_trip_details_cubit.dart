import 'package:ala_feen/features/home/passenger/data/models/trip_model.dart';
import 'package:ala_feen/features/home/passenger/data/repos/passenger_home_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ala_feen/core/utils/safe_emit.dart';

part 'get_trip_details_state.dart';

class GetTripDetailsCubit extends Cubit<GetTripDetailsState> {
  final PassengerHomeRepo passengerHomeRepo;
  GetTripDetailsCubit(this.passengerHomeRepo) : super(GetTripDetailsInitial());

  Future<void> getTripDetails(String tripId) async {
    safeEmit(GetTripDetailsLoading());
    final result = await passengerHomeRepo.getTripById(tripId);
    result.fold(
      (failure) => safeEmit(GetTripDetailsFailure(failure.errorMessage)),
      (trip) => safeEmit(GetTripDetailsSuccess(trip)),
    );
  }
}

