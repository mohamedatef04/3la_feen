import 'package:ala_feen/core/errors/failures.dart';
import 'package:ala_feen/features/auth/data/data_source/auth_data_source.dart';
import 'package:ala_feen/features/auth/data/models/user_model.dart';
import 'package:ala_feen/features/auth/data/repos/auth_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthDataSource authDataSource;
  AuthRepoImpl(this.authDataSource);

  @override
  Future<Either<Failures, String>> registerUser({
    required String email,
    required String password,
  }) async {
    try {
      final result = await authDataSource.registerUser(
        email: email,
        password: password,
      );
      return Right(result);
    } catch (e) {
      if (e is AuthException) {
        return Left(ServerFailure(errorMessage: e.message));
      }
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failures, UserModel>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final result = await authDataSource.loginUser(
        email: email,
        password: password,
      );
      return Right(UserModel.fromJson(result));
    } catch (e) {
      if (e is AuthException) {
        return Left(ServerFailure(errorMessage: e.message));
      }
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failures, void>> resetPassword({
    required String email,
  }) async {
    try {
      await authDataSource.resetPassword(email: email);
      return const Right(null);
    } catch (e) {
      if (e is AuthException) {
        return Left(ServerFailure(errorMessage: e.message));
      }
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failures, String>> uploadImage({
    required String path,
    required String bucketName,
    required String fileName,
  }) async {
    try {
      final result = await authDataSource.uploadImage(
        path,
        bucketName,
        fileName,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failures, void>> saveUserData({
    required UserModel user,
  }) async {
    try {
      await authDataSource.saveUserData(user);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failures, void>> updatePassword({
    required String newPassword,
  }) async {
    try {
      await authDataSource.updatePassword(newPassword);
      return const Right(null);
    } catch (e) {
      if (e is AuthException) {
        return Left(ServerFailure(errorMessage: e.message));
      }
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
