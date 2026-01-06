import 'package:ala_feen/features/auth/data/models/user_model.dart';
import 'package:ala_feen/features/home/passenger/data/repos/passenger_home_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'get_driver_data_state.dart';

class GetDriverDataCubit extends Cubit<GetDriverDataState> {
  GetDriverDataCubit(this.passengerHomeRepo) : super(GetDriverDataInitial());
  final PassengerHomeRepo passengerHomeRepo;

  Future<void> getDriverData(String driverId) async {
    emit(GetDriverDataLoading());
    final result = await passengerHomeRepo.getUserById(driverId);
    result.fold(
      (failure) =>
          emit(GetDriverDataFailure(errorMessage: failure.errorMessage)),
      (driver) => emit(GetDriverDataSuccess(driverModel: driver)),
    );
  }
}
