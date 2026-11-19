part of 'get_trip_details_cubit.dart';

abstract class GetTripDetailsState extends Equatable {
  const GetTripDetailsState();

  @override
  List<Object> get props => [];
}

class GetTripDetailsInitial extends GetTripDetailsState {}

class GetTripDetailsLoading extends GetTripDetailsState {}

class GetTripDetailsSuccess extends GetTripDetailsState {
  final TripModel trip;

  const GetTripDetailsSuccess(this.trip);

  @override
  List<Object> get props => [trip];
}

class GetTripDetailsFailure extends GetTripDetailsState {
  final String errorMessage;

  const GetTripDetailsFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
