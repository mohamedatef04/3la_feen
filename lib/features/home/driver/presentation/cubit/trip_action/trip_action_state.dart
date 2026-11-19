import 'package:ala_feen/features/home/passenger/data/models/trip_model.dart';
import 'package:equatable/equatable.dart';

enum TripActionStatus { initial, loading, pending, accepted, rejected, failure }

class TripActionState extends Equatable {
  final TripActionStatus status;
  final String? offerModel;
  final String? errorMessage;
  final TripModel? trip;

  const TripActionState({
    required this.status,
    this.offerModel,
    this.errorMessage,
    this.trip,
  });

  TripActionState copyWith({
    TripActionStatus? status,
    String? offerModel,
    String? errorMessage,
    TripModel? trip,
  }) {
    return TripActionState(
      status: status ?? this.status,
      offerModel: offerModel ?? this.offerModel,
      errorMessage: errorMessage ?? this.errorMessage,
      trip: trip ?? this.trip,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, offerModel, trip];
}
