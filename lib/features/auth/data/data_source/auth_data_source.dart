import 'dart:io';

import 'package:ala_feen/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthDataSource {
  Future<String> registerUser({
    required String email,
    required String password,
  });
  Future<String> uploadImage(String path, String bucketName, String fileName);
  Future<void> saveUserData(UserModel user);
}

class AuthDataSourceImpl implements AuthDataSource {
  final SupabaseClient supabase;
  AuthDataSourceImpl(this.supabase);

  @override
  Future<String> registerUser({
    required String email,
    required String password,
  }) async {
    final result = await supabase.auth.signUp(email: email, password: password);
    return result.user!.id;
  }

  @override
  Future<String> uploadImage(
    String path,
    String bucketName,
    String fileName,
  ) async {
    final file = File(path);
    await supabase.storage.from(bucketName).upload(fileName, file);
    return supabase.storage.from(bucketName).getPublicUrl(fileName);
  }

  @override
  Future<void> saveUserData(UserModel user) async {
    await supabase.from('users').insert(user.toJson());
  }
}
