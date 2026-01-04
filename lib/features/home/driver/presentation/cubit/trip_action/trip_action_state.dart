import 'package:equatable/equatable.dart';

enum TripActionStatus { initial, loading, success, failure }

class TripActionState extends Equatable {
  final TripActionStatus status;
  final String? errorMessage;

  const TripActionState({
    required this.status,
    this.errorMessage,
  });

  TripActionState copyWith({
    TripActionStatus? status,
    String? errorMessage,
  }) {
    return TripActionState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
  ];
}
