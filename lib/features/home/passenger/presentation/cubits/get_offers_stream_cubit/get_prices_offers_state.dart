part of 'get_prices_offers_cubit.dart';

sealed class GetPricesOffersState extends Equatable {
  const GetPricesOffersState();

  @override
  List<Object> get props => [];
}

final class GetPricesOffersInitial extends GetPricesOffersState {}

final class GetPricesOffersLoading extends GetPricesOffersState {}

final class GetPricesOffersSuccess extends GetPricesOffersState {
  final List<OfferModel> offers;

  const GetPricesOffersSuccess({required this.offers});

  @override
  List<Object> get props => [offers];
}

final class GetPricesOffersError extends GetPricesOffersState {
  final String message;

  const GetPricesOffersError(this.message);
}
