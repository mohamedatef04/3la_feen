import 'package:ala_feen/features/auth/data/repos/auth_repo.dart';
import 'package:ala_feen/features/auth/presentation/cubits/forget_password_cubit/forget_password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final AuthRepo authRepo;

  ForgetPasswordCubit(this.authRepo) : super(ForgetPasswordInitial());

  Future<void> logInForForgotPassword({
    required String email,
  }) async {
    emit(ForgetPasswordLoading());

    final result = await authRepo.resetPassword(
      email: email,
    );
    if (!isClosed) {
      result.fold(
        (failure) =>
            emit(ForgetPasswordFailure(errorMessage: failure.errorMessage)),
        (_) => emit(ForgetPasswordSuccess()),
      );
    }
  }
}
