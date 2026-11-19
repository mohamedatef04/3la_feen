part of 'track_driver_cubit.dart';

abstract class TrackDriverState extends Equatable {
  const TrackDriverState();

  @override
  List<Object> get props => [];
}

class TrackDriverInitial extends TrackDriverState {}

class TrackDriverLoading extends TrackDriverState {}

class TrackDriverUpdate extends TrackDriverState {
  final LatLng driverLocation;
  final DateTime timestamp;

  const TrackDriverUpdate({
    required this.driverLocation,
    required this.timestamp,
  });

  @override
  List<Object> get props => [driverLocation, timestamp];
}

class TrackDriverFailure extends TrackDriverState {
  final String errorMessage;

  const TrackDriverFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
