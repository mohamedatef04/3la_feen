import 'package:ala_feen/core/di/injection_container.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ala_feen/core/utils/safe_emit.dart';

part 'accept_offer_state.dart';

class AcceptOfferCubit extends Cubit<AcceptOfferState> {
  AcceptOfferCubit() : super(AcceptOfferInitial());
  final supabaseClient = sl.get<SupabaseClient>();

  Future<void> acceptOffer(String offerId) async {
    try {
      safeEmit(AcceptOfferLoading());

      await supabaseClient.rpc(
        'accept_offer',
        params: {'p_offer_id': offerId},
      );

      safeEmit(AcceptOfferSuccess());
    } catch (e) {
      safeEmit(AcceptOfferFailure(errorMessage: e.toString()));
    }
  }
}

