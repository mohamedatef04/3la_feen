part of 'passenger_trip_monitor_cubit.dart';

enum PassengerTripStatus {
  initial,
  loading,
  accepted,
  driverArrived,
  started,
  completed,
  cancelled,
  failure,
}

class PassengerTripMonitorState extends Equatable {
  final PassengerTripStatus status;
  final TripModel? trip;
  final String? errorMessage;
  final DateTime? timestamp;

  const PassengerTripMonitorState({
    required this.status,
    this.trip,
    this.errorMessage,
    this.timestamp,
  });

  PassengerTripMonitorState copyWith({
    PassengerTripStatus? status,
    TripModel? trip,
    String? errorMessage,
    DateTime? timestamp,
  }) {
    return PassengerTripMonitorState(
      status: status ?? this.status,
      trip: trip ?? this.trip,
      errorMessage: errorMessage ?? this.errorMessage,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  List<Object?> get props => [status, trip, errorMessage, timestamp];
}
