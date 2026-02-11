import 'package:ala_feen/features/home/passenger/data/models/osrm_route_model.dart';
import 'package:ala_feen/features/home/passenger/data/repos/passenger_home_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ala_feen/core/utils/safe_emit.dart';

part 'get_route_state.dart';

class GetRouteCubit extends Cubit<GetRouteState> {
  GetRouteCubit(this.passengerHomeRepo) : super(GetRouteInitial());
  final PassengerHomeRepo passengerHomeRepo;

  Future<void> getRoute({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
    required String startLocation,
    required String endLocation,
  }) async {
    safeEmit(GetRouteLoading());
    final result = await passengerHomeRepo.getRoute(
      startLat: startLat,
      startLng: startLng,
      endLat: endLat,
      endLng: endLng,
    );
    result.fold(
      (failure) => safeEmit(GetRouteFailure(errorMessage: failure.errorMessage)),
      (route) => safeEmit(
        GetRouteSuccess(
          route: route,
          startLocation: startLocation,
          endLocation: endLocation,
          startLat: startLat,
          startLng: startLng,
          endLat: endLat,
          endLng: endLng,
        ),
      ),
    );
  }

  void reset() {
    safeEmit(GetRouteInitial());
  }
}

