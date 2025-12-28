import 'package:ala_feen/features/auth/data/data_source/auth_data_source.dart';
import 'package:ala_feen/features/auth/data/repos/auth_repo.dart';
import 'package:ala_feen/features/auth/data/repos/auth_repo_impl.dart';
import 'package:ala_feen/features/auth/presentation/cubits/forget_password_cubit/forget_password_cubit.dart';
import 'package:ala_feen/features/auth/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:ala_feen/features/auth/presentation/cubits/register_cubit/cubit/register_cubit.dart';
import 'package:ala_feen/features/auth/presentation/cubits/reset_password_cubit/reset_password_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final sl = GetIt.instance;

/// Initialize Dependency Injection
Future<void> init() async {
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);
  sl.registerLazySingleton<AuthDataSource>(
    () => AuthDataSourceImpl(sl.get<SupabaseClient>()),
  );
  sl.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(sl.get<AuthDataSource>()),
  );
  sl.registerFactory<RegisterCubit>(
    () => RegisterCubit(sl.get<AuthRepo>()),
  );
  sl.registerFactory<LoginCubit>(
    () => LoginCubit(sl.get<AuthRepo>()),
  );
  sl.registerFactory<ForgetPasswordCubit>(
    () => ForgetPasswordCubit(sl.get<AuthRepo>()),
  );
  sl.registerFactory<ResetPasswordCubit>(
    () => ResetPasswordCubit(sl.get<AuthRepo>()),
  );
}
