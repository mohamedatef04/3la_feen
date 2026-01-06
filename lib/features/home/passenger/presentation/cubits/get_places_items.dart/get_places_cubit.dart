import 'package:ala_feen/features/home/passenger/data/models/place_model.dart';
import 'package:ala_feen/features/home/passenger/data/repos/passenger_home_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'get_places_state.dart';

class GetPlacesCubit extends Cubit<GetPlacesState> {
  GetPlacesCubit(this.passengerHomeRepo) : super(GetPlacesInitial());
  final PassengerHomeRepo passengerHomeRepo;

  Future<void> searchPlaces(String query) async {
    emit(GetPlacesLoading());
    final result = await passengerHomeRepo.searchPlaces(query);
    result.fold(
      (failure) => emit(GetPlacesFailure(errorMessage: failure.errorMessage)),
      (places) => emit(GetPlacesSuccess(places: places)),
    );
  }

  void reset() {
    emit(GetPlacesInitial());
  }
}
