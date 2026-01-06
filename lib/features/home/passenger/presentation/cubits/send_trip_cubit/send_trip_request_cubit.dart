import 'package:ala_feen/features/home/passenger/data/models/trip_model.dart';
import 'package:ala_feen/features/home/passenger/data/repos/passenger_home_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'send_trip_request_state.dart';

class SendTripRequestCubit extends Cubit<SendTripRequestState> {
  SendTripRequestCubit(this.passengerHomeRepo)
    : super(SendTripRequestInitial());
  final PassengerHomeRepo passengerHomeRepo;

  Future<void> sendTripRequest({required TripModel tripModel}) async {
    emit(SendTripRequestLoading());
    final result = await passengerHomeRepo.sendTripRequest(
      tripModel: tripModel,
    );
    result.fold(
      (failure) =>
          emit(SendTripRequestFailure(errorMessage: failure.errorMessage)),
      (trip) => emit(SendTripRequestSuccess(tripModel: trip)),
    );
  }
}
