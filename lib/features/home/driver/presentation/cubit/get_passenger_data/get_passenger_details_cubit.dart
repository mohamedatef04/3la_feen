import 'package:ala_feen/features/home/driver/data/repo/driver_repo.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/get_passenger_data/get_passenger_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ala_feen/core/utils/safe_emit.dart';

class GetPassengerDetailsCubit extends Cubit<GetPassengerDetailsState> {
  final DriverRepo driverRepo;

  GetPassengerDetailsCubit(this.driverRepo)
    : super(GetPassengerDetailsInitial());

  Future<void> getPassengerDetails(String passengerId) async {
    safeEmit(GetPassengerDetailsLoading());
    try {
      final passenger = await driverRepo.getPassengerData(passengerId);
      if (passenger != null) {
        safeEmit(GetPassengerDetailsSuccess(passengerModel: passenger));
      } else {
        safeEmit(
          const GetPassengerDetailsFailure(errorMessage: 'Passenger not found'),
        );
      }
    } catch (e) {
      safeEmit(GetPassengerDetailsFailure(errorMessage: e.toString()));
    }
  }
}

