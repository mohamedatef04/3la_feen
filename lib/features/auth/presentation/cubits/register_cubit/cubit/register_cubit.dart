import 'dart:io';

import 'package:ala_feen/features/auth/data/models/user_model.dart';
import 'package:ala_feen/features/auth/data/repos/auth_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:path/path.dart' as p;

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this.authRepo) : super(RegisterInitial());
  final AuthRepo authRepo;

  Future<void> registerUser({
    required UserModel user,
    File? profilePic,
    File? cardIdPic,
    File? carPic,
    File? licensePic,
  }) async {
    emit(RegisterLoading());

    // 1. Auth Registration
    final result = await authRepo.registerUser(
      email: user.email!,
      password: user.password!,
    );

    await result.fold(
      (failure) async {
        if (!isClosed) {
          emit(RegisterError(errorMessage: failure.errorMessage));
        }
      },
      (userId) async {
        try {
          String? profilePicUrl;
          String? cardIdPicUrl;
          String? carPicUrl;
          String? licensePicUrl;

          // Helper to get consistent file names with extensions
          String getFileName(File file, String prefix) {
            final extension = p.extension(file.path);
            return '$prefix/$userId$extension';
          }

          // 2. Upload Images
          if (profilePic != null) {
            final uploadResult = await authRepo.uploadImage(
              path: profilePic.path,
              bucketName: 'profiles_pic',
              fileName: getFileName(profilePic, 'profiles'),
            );
            uploadResult.fold(
              (f) => throw Exception(f.errorMessage),
              (url) => profilePicUrl = url,
            );
          }

          if (cardIdPic != null) {
            final uploadResult = await authRepo.uploadImage(
              path: cardIdPic.path,
              bucketName: 'driver_data',
              fileName: getFileName(cardIdPic, 'ids'),
            );
            uploadResult.fold(
              (f) => throw Exception(f.errorMessage),
              (url) => cardIdPicUrl = url,
            );
          }

          if (carPic != null) {
            final uploadResult = await authRepo.uploadImage(
              path: carPic.path,
              bucketName: 'driver_data',
              fileName: getFileName(carPic, 'cars'),
            );
            uploadResult.fold(
              (f) => throw Exception(f.errorMessage),
              (url) => carPicUrl = url,
            );
          }

          if (licensePic != null) {
            final uploadResult = await authRepo.uploadImage(
              path: licensePic.path,
              bucketName: 'driver_data',
              fileName: getFileName(licensePic, 'licenses'),
            );
            uploadResult.fold(
              (f) => throw Exception(f.errorMessage),
              (url) => licensePicUrl = url,
            );
          }

          // 3. Save User Data to DB
          final updatedUser = UserModel(
            id: userId,
            name: user.name,
            email: user.email,
            phone: user.phone,
            role: user.role,
            profilePic: profilePicUrl,
            cardIdPic: cardIdPicUrl,
            carPic: carPicUrl,
            licensePic: licensePicUrl,
          );

          final dbResult = await authRepo.saveUserData(user: updatedUser);
          if (!isClosed) {
            dbResult.fold(
              (failure) =>
                  emit(RegisterError(errorMessage: failure.errorMessage)),
              (_) => emit(RegisterSuccess()),
            );
          }
        } catch (e) {
          if (!isClosed) {
            emit(RegisterError(errorMessage: e.toString()));
          }
        }
      },
    );
  }
}
