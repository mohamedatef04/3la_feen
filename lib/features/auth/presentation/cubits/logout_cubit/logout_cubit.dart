import 'package:ala_feen/core/di/injection_container.dart';
import 'package:ala_feen/features/auth/data/repos/auth_repo.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/active_trip/active_trip_monitor_cubit.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/home_driver/home_driver_cubit.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/trip_action/trip_action_cubit.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/trips_stream/trips_stream_cubit.dart';
import 'package:bloc/bloc.dart';
import 'logout_state.dart';
import 'package:ala_feen/core/utils/safe_emit.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final AuthRepo _authRepo;

  LogoutCubit(this._authRepo) : super(LogoutInitial());

  Future<void> logout() async {
    safeEmit(LogoutLoading());
    final result = await _authRepo.logout();
    result.fold(
      (failure) => safeEmit(LogoutFailure(errorMessage: failure.errorMessage)),
      (success) {
        // Reset singletons to clear their state for the next user
        if (sl.isRegistered<HomeDriverCubit>()) {
          sl.resetLazySingleton<HomeDriverCubit>();
        }
        if (sl.isRegistered<TripsStreamCubit>()) {
          sl.resetLazySingleton<TripsStreamCubit>();
        }
        if (sl.isRegistered<TripActionCubit>()) {
          sl.resetLazySingleton<TripActionCubit>();
        }
        if (sl.isRegistered<ActiveTripMonitorCubit>()) {
          sl.resetLazySingleton<ActiveTripMonitorCubit>();
        }
        safeEmit(LogoutSuccess());
      },
    );
  }
}

