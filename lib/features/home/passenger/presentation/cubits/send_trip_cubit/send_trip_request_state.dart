part of 'send_trip_request_cubit.dart';

sealed class SendTripRequestState extends Equatable {
  const SendTripRequestState();

  @override
  List<Object> get props => [];
}

final class SendTripRequestInitial extends SendTripRequestState {}

final class SendTripRequestLoading extends SendTripRequestState {}

final class SendTripRequestSuccess extends SendTripRequestState {
  final TripModel tripModel;

  const SendTripRequestSuccess({required this.tripModel});

  @override
  List<Object> get props => [tripModel];
}

final class SendTripRequestFailure extends SendTripRequestState {
  final String errorMessage;

  const SendTripRequestFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
