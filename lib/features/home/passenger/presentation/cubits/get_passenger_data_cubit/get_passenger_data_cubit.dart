import 'package:ala_feen/features/auth/data/models/user_model.dart';
import 'package:ala_feen/features/home/passenger/data/repos/passenger_home_repo.dart';
import 'package:ala_feen/core/di/injection_container.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ala_feen/core/utils/safe_emit.dart';

part 'get_passenger_data_state.dart';

class GetPassengerDataCubit extends Cubit<GetPassengerDataState> {
  GetPassengerDataCubit(this.passengerHomeRepo)
    : super(GetPassengerDataInitial());
  final PassengerHomeRepo passengerHomeRepo;

  Future<void> getPassengerData({String? userId}) async {
    safeEmit(GetPassengerDataLoading());
    final targetUserId = userId ?? sl<SupabaseClient>().auth.currentUser!.id;
    final result = await passengerHomeRepo.getUserById(targetUserId);
    result.fold(
      (failure) =>
          safeEmit(GetPassengerDataFailure(errorMessage: failure.errorMessage)),
      (success) => safeEmit(GetPassengerDataSuccess(userModel: success)),
    );
  }
}

