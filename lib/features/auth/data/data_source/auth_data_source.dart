import 'dart:io';

import 'package:ala_feen/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthDataSource {
  Future<String> registerUser({
    required String email,
    required String password,
  });
  Future<String> loginUser({
    required String email,
    required String password,
  });
  Future<void> resetPassword({
    required String email,
  });
  Future<void> updatePassword(String newPassword);
  Future<String> uploadImage(String path, String bucketName, String fileName);
  Future<void> saveUserData(UserModel user);
  Future<String> getUserRole(String userId);
}

class AuthDataSourceImpl implements AuthDataSource {
  final SupabaseClient supabase;
  AuthDataSourceImpl(this.supabase);

  @override
  Future<String> getUserRole(String userId) async {
    final data = await supabase
        .from('users')
        .select('role')
        .eq('id', userId)
        .single();
    return data['role'] as String;
  }

  @override
  Future<String> registerUser({
    required String email,
    required String password,
  }) async {
    final result = await supabase.auth.signUp(email: email, password: password);
    return result.user!.id;
  }

  @override
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    final result = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    return result.user!.id;
  }

  @override
  Future<void> resetPassword({required String email}) async {
    // kIsWeb check might be needed if supporting web, but this is flutter mobile mostly?
    // Using deep link scheme configured in Supabase
    await supabase.auth.resetPasswordForEmail(
      email,
      redirectTo: 'alafeen://login-callback/reset-password',
    );
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

  @override
  Future<void> updatePassword(String newPassword) async {
    await supabase.auth.updateUser(
      UserAttributes(
        password: newPassword,
      ),
    );
  }
}
