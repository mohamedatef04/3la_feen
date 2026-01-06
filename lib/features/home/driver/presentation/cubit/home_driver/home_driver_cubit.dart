import 'package:ala_feen/core/network/network_info.dart';
import 'package:ala_feen/core/utils/base_cubit.dart';
import 'package:ala_feen/features/home/driver/data/repo/driver_repo.dart';
import 'home_driver_state.dart';

class HomeDriverCubit extends BaseCubit<HomeDriverState> {
  final DriverRepo _driverRepo;

  HomeDriverCubit(this._driverRepo, NetworkInfo networkInfo)
    : super(
        const HomeDriverState(status: HomeDriverStatus.initial),
        networkInfo,
      ) {
    getDriverData();
  }

  Future<void> getDriverData() async {
    safeEmit(state.copyWith(status: HomeDriverStatus.loading));
    try {
      await checkNetwork();
      final driverData = await _driverRepo.getDriverData();
      safeEmit(
        state.copyWith(status: HomeDriverStatus.success, userModel: driverData),
      );
    } catch (e) {
      safeEmit(
        state.copyWith(
          status: HomeDriverStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
