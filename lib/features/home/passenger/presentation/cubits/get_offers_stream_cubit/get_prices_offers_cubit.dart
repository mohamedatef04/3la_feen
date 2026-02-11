import 'dart:async';

import 'package:ala_feen/features/home/passenger/data/models/offer_model.dart';
import 'package:ala_feen/features/home/passenger/data/repos/passenger_home_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ala_feen/core/utils/safe_emit.dart';

part 'get_prices_offers_state.dart';

class GetPricesOffersCubit extends Cubit<GetPricesOffersState> {
  GetPricesOffersCubit(this.passengerHomeRepo)
    : super(GetPricesOffersInitial());
  final PassengerHomeRepo passengerHomeRepo;
  StreamSubscription? _subscription;
  final List<OfferModel> _offers = [];

  void listenToOffers(String tripId) {
    _offers.clear();
    safeEmit(GetPricesOffersLoading());
    _subscription?.cancel();
    _subscription = passengerHomeRepo.getOffersStream(tripId: tripId).listen((
      either,
    ) {
      either.fold(
        (failure) => safeEmit(GetPricesOffersError(failure.errorMessage)),
        (offer) {
          _offers.add(offer);
          safeEmit(GetPricesOffersSuccess(offers: List.from(_offers)));
        },
      );
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

