part of 'accept_offer_cubit.dart';

sealed class AcceptOfferState extends Equatable {
  const AcceptOfferState();

  @override
  List<Object> get props => [];
}

final class AcceptOfferInitial extends AcceptOfferState {}

final class AcceptOfferLoading extends AcceptOfferState {}

final class AcceptOfferSuccess extends AcceptOfferState {}

final class AcceptOfferFailure extends AcceptOfferState {
  final String errorMessage;
  const AcceptOfferFailure({required this.errorMessage});
}
