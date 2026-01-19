import 'package:ala_feen/features/home/passenger/data/models/trip_model.dart';
import 'package:equatable/equatable.dart';

enum ActiveTripStatus { initial, active, completed, cancelled, failure }

class ActiveTripState extends Equatable {
  final ActiveTripStatus status;
  final TripModel? activeTrip;
  final String? errorMessage;

  const ActiveTripState({
    required this.status,
    this.activeTrip,
    this.errorMessage,
  });

  ActiveTripState copyWith({
    ActiveTripStatus? status,
    TripModel? activeTrip,
    String? errorMessage,
  }) {
    return ActiveTripState(
      status: status ?? this.status,
      activeTrip: activeTrip ?? this.activeTrip,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, activeTrip, errorMessage];
}
