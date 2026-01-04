import 'package:ala_feen/core/network/network_info.dart';
import 'package:ala_feen/core/utils/base_cubit.dart';
import 'package:ala_feen/features/home/driver/data/models/offer_model.dart';
import 'package:ala_feen/features/home/driver/data/repo/driver_repo.dart';
import 'trip_action_state.dart';

class TripActionCubit extends BaseCubit<TripActionState> {
  final DriverRepo _driverRepo;

  TripActionCubit(this._driverRepo, NetworkInfo networkInfo)
    : super(
        const TripActionState(status: TripActionStatus.initial),
        networkInfo,
      );

  Future<void> makeOffer({required OfferModel offer}) async {
    safeEmit(
      state.copyWith(
        status: TripActionStatus.loading,
      ),
    );
    try {
      await checkNetwork();
      await _driverRepo.makeOffer(offer: offer);
      safeEmit(state.copyWith(status: TripActionStatus.success));
    } catch (e) {
      safeEmit(
        state.copyWith(
          status: TripActionStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
