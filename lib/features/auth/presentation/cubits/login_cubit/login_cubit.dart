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
      result.fold(
        (failure) => emit(LoginFailure(errorMessage: failure.errorMessage)),
        (user) => emit(LoginSuccess(user: user)),
      );
    }
  }
}
