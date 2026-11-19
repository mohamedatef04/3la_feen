import 'package:ala_feen/features/auth/data/repos/auth_repo.dart';
import 'package:ala_feen/features/auth/presentation/cubits/login_cubit/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ala_feen/core/utils/safe_emit.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepo authRepo;

  LoginCubit(this.authRepo) : super(LoginInitial());

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    safeEmit(LoginLoading());

    final result = await authRepo.loginUser(
      email: email,
      password: password,
    );
    if (!isClosed) {
      await result.fold(
        (failure) async =>
            safeEmit(LoginFailure(errorMessage: failure.errorMessage)),
        (userId) async {
          final roleResult = await authRepo.getUserRole(userId: userId);
          if (!isClosed) {
            roleResult.fold(
              (failure) =>
                  safeEmit(LoginFailure(errorMessage: failure.errorMessage)),
              (role) => safeEmit(LoginSuccess(userId: userId, role: role)),
            );
          }
        },
      );
    }
  }
}

