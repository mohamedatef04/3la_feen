part of 'cancel_trip_cubit.dart';

abstract class CancelTripState extends Equatable {
  const CancelTripState();

  @override
  List<Object> get props => [];
}

class CancelTripInitial extends CancelTripState {}

class CancelTripLoading extends CancelTripState {}

class CancelTripSuccess extends CancelTripState {}

class CancelTripFailure extends CancelTripState {
  final String errorMessage;

  const CancelTripFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
