part of 'track_my_location_cubit.dart';

sealed class TrackMyLocationState extends Equatable {
  const TrackMyLocationState();

  @override
  List<Object> get props => [];
}

final class TrackMyLocationInitial extends TrackMyLocationState {}

final class TrackMyLocationLoading extends TrackMyLocationState {}

final class TrackMyLocationSuccess extends TrackMyLocationState {}

final class TrackMyLocationFailure extends TrackMyLocationState {
  final String errorMessage;
  const TrackMyLocationFailure({required this.errorMessage});
}
