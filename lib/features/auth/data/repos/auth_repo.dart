import 'package:ala_feen/core/errors/failures.dart';
import 'package:ala_feen/features/auth/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepo {
  Future<Either<Failures, String>> registerUser({
    required String email,
    required String password,
  });

  Future<Either<Failures, String>> loginUser({
    required String email,
    required String password,
  });

  Future<Either<Failures, void>> resetPassword({
    required String email,
  });

  Future<Either<Failures, String>> uploadImage({
    required String path,
    required String bucketName,
    required String fileName,
  });

  Future<Either<Failures, void>> saveUserData({
    required UserModel user,
  });

  Future<Either<Failures, void>> updatePassword({
    required String newPassword,
  });

  Future<Either<Failures, String>> getUserRole({
    required String userId,
  });
}
