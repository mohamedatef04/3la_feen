import 'package:ala_feen/features/auth/data/models/user_model.dart';
import 'package:ala_feen/features/home/passenger/data/repos/passenger_home_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ala_feen/core/utils/safe_emit.dart';

part 'get_driver_data_state.dart';

class GetDriverDataCubit extends Cubit<GetDriverDataState> {
  GetDriverDataCubit(this.passengerHomeRepo) : super(GetDriverDataInitial());
  final PassengerHomeRepo passengerHomeRepo;

  Future<void> getDriverData(String driverId) async {
    safeEmit(GetDriverDataLoading());
    final result = await passengerHomeRepo.getUserById(driverId);
    result.fold(
      (failure) =>
          safeEmit(GetDriverDataFailure(errorMessage: failure.errorMessage)),
      (driver) => safeEmit(GetDriverDataSuccess(driverModel: driver)),
    );
  }
}

