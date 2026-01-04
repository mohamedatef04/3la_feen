import 'dart:async';
import 'package:ala_feen/core/network/network_info.dart';
import 'package:ala_feen/core/utils/base_cubit.dart';
import 'package:ala_feen/features/home/driver/data/models/driver_model.dart';
import 'package:ala_feen/features/home/driver/data/repo/driver_repo.dart';
import 'trips_stream_state.dart';

class TripsStreamCubit extends BaseCubit<TripsStreamState> {
  final DriverRepo _driverRepo;
  StreamSubscription<List<TripModel>>? _tripsSubscription;

  TripsStreamCubit(this._driverRepo, NetworkInfo networkInfo)
    : super(
        const TripsStreamState(status: TripsStreamStatus.initial),
        networkInfo,
      ) {
    getTrips();
  }

  Future<void> getTrips() async {
    safeEmit(state.copyWith(status: TripsStreamStatus.loading));
    try {
      await checkNetwork();
      await _tripsSubscription?.cancel();
      _tripsSubscription = _driverRepo.getTrips().listen(
        (trips) {
          final availableTrips = trips
              .where((trip) => trip.status == "searching")
              .toList();
          safeEmit(
            state.copyWith(
              status: TripsStreamStatus.success,
              trips: availableTrips,
            ),
          );
        },
        onError: (e) {
          safeEmit(
            state.copyWith(
              status: TripsStreamStatus.failure,
              errorMessage: e.toString(),
            ),
          );
        },
      );
    } catch (e) {
      safeEmit(
        state.copyWith(
          status: TripsStreamStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> updateStatus({required String id}) async {
    safeEmit(state.copyWith(status: TripsStreamStatus.loading));
    try {
      await checkNetwork();
      await _driverRepo.updateStatus(id: id);
      safeEmit(
        state.copyWith(
          status: TripsStreamStatus.success,
        ),
      );
    } catch (e) {
      safeEmit(
        state.copyWith(
          status: TripsStreamStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _tripsSubscription?.cancel();
    return super.close();
  }
}
