import 'package:ala_feen/features/home/driver/data/models/driver_model.dart';
import 'package:equatable/equatable.dart';

enum TripsStreamStatus { initial, loading, success, failure }

class TripsStreamState extends Equatable {
  final TripsStreamStatus status;
  final List<TripModel>? trips;
  final String? errorMessage;

  const TripsStreamState({
    required this.status,
    this.trips,
    this.errorMessage,
  });

  TripsStreamState copyWith({
    TripsStreamStatus? status,
    List<TripModel>? trips,
    String? errorMessage,
  }) {
    return TripsStreamState(
      status: status ?? this.status,
      trips: trips ?? this.trips,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, trips, errorMessage];
}
