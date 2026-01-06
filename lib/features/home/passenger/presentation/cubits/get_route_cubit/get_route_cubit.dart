import 'package:ala_feen/features/home/passenger/data/models/osrm_route_model.dart';
import 'package:ala_feen/features/home/passenger/data/repos/passenger_home_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

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
    emit(GetRouteLoading());
    final result = await passengerHomeRepo.getRoute(
      startLat: startLat,
      startLng: startLng,
      endLat: endLat,
      endLng: endLng,
    );
    result.fold(
      (failure) => emit(GetRouteFailure(errorMessage: failure.errorMessage)),
      (route) => emit(
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
    emit(GetRouteInitial());
  }
}
