import 'package:ala_feen/features/auth/data/models/user_model.dart';
import 'package:ala_feen/features/home/passenger/data/repos/passenger_home_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ala_feen/core/utils/safe_emit.dart';

part 'user_data_state.dart';

class UserDataCubit extends Cubit<UserDataState> {
  final PassengerHomeRepo passengerHomeRepo;

  UserDataCubit(this.passengerHomeRepo) : super(UserDataInitial());

  Future<void> getUserData(String userId) async {
    safeEmit(UserDataLoading());
    final result = await passengerHomeRepo.getUserById(userId);
    result.fold(
      (failure) => safeEmit(UserDataFailure(errorMessage: failure.errorMessage)),
      (success) => safeEmit(UserDataSuccess(userModel: success)),
    );
  }
}

