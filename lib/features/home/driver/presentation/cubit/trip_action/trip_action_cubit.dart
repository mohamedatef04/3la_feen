import 'dart:async';

import 'package:ala_feen/core/network/network_info.dart';
import 'package:ala_feen/core/utils/base_cubit.dart';
import 'package:ala_feen/features/home/driver/data/repo/driver_repo.dart';
import 'package:ala_feen/features/home/passenger/data/models/offer_model.dart';
import 'trip_action_state.dart';

class TripActionCubit extends BaseCubit<TripActionState> {
  final DriverRepo _driverRepo;
  StreamSubscription? _offerSubscription;

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
      final createdOffer = await _driverRepo.makeOffer(offer: offer);
      safeEmit(state.copyWith(status: TripActionStatus.pending));
      monitorOfferStatus(offerId: createdOffer.id!);
    } catch (e) {
      safeEmit(
        state.copyWith(
          status: TripActionStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void monitorOfferStatus({required String offerId}) {
    _offerSubscription?.cancel();
    _offerSubscription = _driverRepo
        .getOfferStatus(offerId: offerId)
        .listen(
          (status) {
            if (status == null) return;
            final normalizedStatus = status.toLowerCase();
            TripActionStatus actionStatus = state.status;
            if (normalizedStatus == 'pending') {
              actionStatus = TripActionStatus.pending;
            } else if (normalizedStatus == 'accepted') {
              actionStatus = TripActionStatus.accepted;
            } else if (normalizedStatus == 'rejected') {
              actionStatus = TripActionStatus.rejected;
            }

            safeEmit(
              state.copyWith(
                status: actionStatus,
                offerModel: normalizedStatus,
              ),
            );
          },
          onError: (error) {
            // Log or handle error
          },
        );
  }

  @override
  Future<void> close() {
    _offerSubscription?.cancel();
    return super.close();
  }
}
