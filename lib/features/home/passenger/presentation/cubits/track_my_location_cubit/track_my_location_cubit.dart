import 'package:ala_feen/features/home/passenger/data/repos/passenger_home_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:location/location.dart';
import 'package:ala_feen/core/utils/safe_emit.dart';
part 'track_my_location_state.dart';

class TrackMyLocationCubit extends Cubit<TrackMyLocationState> {
  TrackMyLocationCubit(this.passengerHomeRepo)
    : super(TrackMyLocationInitial());
  final PassengerHomeRepo passengerHomeRepo;

  void getCurrentLocation(void Function(LocationData)? onData) async {
    safeEmit(TrackMyLocationLoading());
    final result = await passengerHomeRepo.getCurrentLocation(onData);
    result.fold(
      (failure) =>
          safeEmit(TrackMyLocationFailure(errorMessage: failure.errorMessage)),
      (success) => safeEmit(TrackMyLocationSuccess()),
    );
  }
}

