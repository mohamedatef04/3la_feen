import 'package:ala_feen/features/home/passenger/data/models/place_model.dart';
import 'package:ala_feen/features/home/passenger/data/repos/passenger_home_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ala_feen/core/utils/safe_emit.dart';

part 'get_places_state.dart';

class GetPlacesCubit extends Cubit<GetPlacesState> {
  GetPlacesCubit(this.passengerHomeRepo) : super(GetPlacesInitial());
  final PassengerHomeRepo passengerHomeRepo;

  Future<void> searchPlaces(String query) async {
    safeEmit(GetPlacesLoading());
    final result = await passengerHomeRepo.searchPlaces(query);
    result.fold(
      (failure) => safeEmit(GetPlacesFailure(errorMessage: failure.errorMessage)),
      (places) => safeEmit(GetPlacesSuccess(places: places)),
    );
  }

  void reset() {
    safeEmit(GetPlacesInitial());
  }
}

