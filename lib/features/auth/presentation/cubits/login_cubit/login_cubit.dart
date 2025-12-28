import 'package:ala_feen/features/auth/data/repos/auth_repo.dart';
import 'package:ala_feen/features/auth/presentation/cubits/login_cubit/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepo authRepo;

  LoginCubit(this.authRepo) : super(LoginInitial());

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());

    final result = await authRepo.loginUser(
      email: email,
      password: password,
    );
    if (!isClosed) {
      await result.fold(
        (failure) async =>
            emit(LoginFailure(errorMessage: failure.errorMessage)),
        (userId) async {
          final roleResult = await authRepo.getUserRole(userId: userId);
          if (!isClosed) {
            roleResult.fold(
              (failure) =>
                  emit(LoginFailure(errorMessage: failure.errorMessage)),
              (role) => emit(LoginSuccess(userId: userId, role: role)),
            );
          }
        },
      );
    }
  }
}
