import 'package:ala_feen/features/auth/data/repos/auth_repo.dart';
import 'package:ala_feen/features/auth/presentation/cubits/reset_password_cubit/reset_password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ala_feen/core/utils/safe_emit.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final AuthRepo authRepo;

  ResetPasswordCubit(this.authRepo) : super(ResetPasswordInitial());

  Future<void> resetPassword({
    required String newPassword,
  }) async {
    safeEmit(ResetPasswordLoading());

    final result = await authRepo.updatePassword(
      newPassword: newPassword,
    );

    if (!isClosed) {
      result.fold(
        (failure) =>
            safeEmit(ResetPasswordFailure(errorMessage: failure.errorMessage)),
        (_) => safeEmit(ResetPasswordSuccess()),
      );
    }
  }
}

