import 'package:ala_feen/core/errors/failures.dart';
import 'package:ala_feen/features/auth/data/repos/auth_repo.dart';
import 'package:ala_feen/features/auth/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:ala_feen/features/auth/presentation/cubits/login_cubit/login_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

void main() {
  late MockAuthRepo authRepo;

  const email = 'rider@example.com';
  const password = 'secret123';
  const userId = 'user-1';

  setUp(() => authRepo = MockAuthRepo());

  void stubLogin(Either<Failures, String> result) {
    when(
      () => authRepo.loginUser(email: email, password: password),
    ).thenAnswer((_) async => result);
  }

  void stubRole(Either<Failures, String> result) {
    when(
      () => authRepo.getUserRole(userId: userId),
    ).thenAnswer((_) async => result);
  }

  test('initial state is LoginInitial', () {
    expect(LoginCubit(authRepo).state, isA<LoginInitial>());
  });

  group('loginUser', () {
    blocTest<LoginCubit, LoginState>(
      'emits [loading, success] with the user id and role when login and role lookup succeed',
      setUp: () {
        stubLogin(const Right(userId));
        stubRole(const Right('driver'));
      },
      build: () => LoginCubit(authRepo),
      act: (cubit) => cubit.loginUser(email: email, password: password),
      expect: () => [
        isA<LoginLoading>(),
        isA<LoginSuccess>()
            .having((s) => s.userId, 'userId', userId)
            .having((s) => s.role, 'role', 'driver'),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'emits [loading, failure] and skips the role lookup when login fails',
      setUp: () => stubLogin(Left(ServerFailure(errorMessage: 'Invalid credentials'))),
      build: () => LoginCubit(authRepo),
      act: (cubit) => cubit.loginUser(email: email, password: password),
      expect: () => [
        isA<LoginLoading>(),
        isA<LoginFailure>().having(
          (s) => s.errorMessage,
          'errorMessage',
          'Invalid credentials',
        ),
      ],
      verify: (_) => verifyNever(
        () => authRepo.getUserRole(userId: any(named: 'userId')),
      ),
    );

    blocTest<LoginCubit, LoginState>(
      'emits [loading, failure] when login succeeds but the role lookup fails',
      setUp: () {
        stubLogin(const Right(userId));
        stubRole(Left(ServerFailure(errorMessage: 'User not found')));
      },
      build: () => LoginCubit(authRepo),
      act: (cubit) => cubit.loginUser(email: email, password: password),
      expect: () => [
        isA<LoginLoading>(),
        isA<LoginFailure>().having(
          (s) => s.errorMessage,
          'errorMessage',
          'User not found',
        ),
      ],
    );
  });
}
