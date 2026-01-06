part of 'get_places_cubit.dart';

sealed class GetPlacesState extends Equatable {
  const GetPlacesState();

  @override
  List<Object> get props => [];
}

final class GetPlacesInitial extends GetPlacesState {}

final class GetPlacesLoading extends GetPlacesState {}

final class GetPlacesSuccess extends GetPlacesState {
  final List<PlaceModel> places;
  const GetPlacesSuccess({required this.places});
}

final class GetPlacesFailure extends GetPlacesState {
  final String errorMessage;
  const GetPlacesFailure({required this.errorMessage});
}
