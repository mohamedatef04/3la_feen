import 'dart:async';
import 'package:ala_feen/core/network/network_info.dart';
import 'package:ala_feen/core/utils/base_cubit.dart';
import 'package:ala_feen/features/home/driver/data/repo/driver_repo.dart';
import 'package:ala_feen/features/home/passenger/data/models/trip_model.dart';
import 'active_trip_state.dart';
import 'package:ala_feen/core/utils/safe_emit.dart';

class ActiveTripMonitorCubit extends BaseCubit<ActiveTripState> {
  final DriverRepo driverRepo;
  StreamSubscription? _activeTripSubscription;

  ActiveTripMonitorCubit(this.driverRepo, NetworkInfo networkInfo)
    : super(
        const ActiveTripState(status: ActiveTripStatus.initial),
        networkInfo,
      );

  void monitorActiveTrip(String driverId) {
    _activeTripSubscription?.cancel();
    _activeTripSubscription = driverRepo
        .getActiveTrip(driverId: driverId)
        .listen(
          (trip) {
            if (trip != null) {
              setActiveTrip(trip);
            } else {
              if (state.status == ActiveTripStatus.active) {
                clearActiveTrip();
              }
            }
          },
        );
  }

  void setActiveTrip(TripModel trip) {
    safeEmit(
      state.copyWith(
        status: ActiveTripStatus.active,
        activeTrip: trip,
      ),
    );
  }

  void clearActiveTrip() {
    safeEmit(const ActiveTripState(status: ActiveTripStatus.initial));
  }

  Future<void> updateTripStatus(String tripId, String status) async {
    try {
      await driverRepo.updateTripStatus(tripId: tripId, status: status);
    } catch (e) {
      safeEmit(
        state.copyWith(
          status: ActiveTripStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _activeTripSubscription?.cancel();
    return super.close();
  }
}


