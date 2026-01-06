import 'package:equatable/equatable.dart';

enum TripActionStatus { initial, loading, pending, accepted, rejected, failure }

class TripActionState extends Equatable {
  final TripActionStatus status;
  final String? offerModel;
  final String? errorMessage;

  const TripActionState({
    required this.status,
    this.offerModel,
    this.errorMessage,
  });

  TripActionState copyWith({
    TripActionStatus? status,
    String? offerModel,
    String? errorMessage,
  }) {
    return TripActionState(
      status: status ?? this.status,
      offerModel: offerModel ?? this.offerModel,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, offerModel];
}
