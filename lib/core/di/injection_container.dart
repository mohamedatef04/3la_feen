import 'package:ala_feen/core/network/network_info.dart';
import 'package:ala_feen/features/auth/data/data_source/auth_data_source.dart';
import 'package:ala_feen/features/auth/data/repos/auth_repo.dart';
import 'package:ala_feen/features/auth/data/repos/auth_repo_impl.dart';
import 'package:ala_feen/features/auth/presentation/cubits/forget_password_cubit/forget_password_cubit.dart';
import 'package:ala_feen/features/auth/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:ala_feen/features/auth/presentation/cubits/register_cubit/cubit/register_cubit.dart';
import 'package:ala_feen/features/auth/presentation/cubits/reset_password_cubit/reset_password_cubit.dart';
import 'package:ala_feen/features/home/driver/data/dataSource/driver_remote_data_source.dart';
import 'package:ala_feen/features/home/driver/data/repo/driver_repo.dart';
import 'package:ala_feen/features/home/driver/data/repo/driver_repo_imp.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/home_driver/home_driver_cubit.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/trip_action/trip_action_cubit.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/trips_stream/trips_stream_cubit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final sl = GetIt.instance;

/// Initialize Dependency Injection
Future<void> init() async {
  //network
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      sl.get<Connectivity>(),
    ),
  );

  //
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
  sl.registerLazySingleton<DriverRemoteDataSource>(
    () => DriverRemoteDataSourceImpl(sl.get<SupabaseClient>()),
  );
  sl.registerLazySingleton<DriverRepo>(
    () => DriverRepoImp(sl.get<DriverRemoteDataSource>()),
  );

  sl.registerLazySingleton<HomeDriverCubit>(
    () => HomeDriverCubit(
      sl.get<DriverRepo>(),
      sl.get<NetworkInfo>(),
    ),
  );

  sl.registerLazySingleton<TripsStreamCubit>(
    () => TripsStreamCubit(
      sl.get<DriverRepo>(),
      sl.get<NetworkInfo>(),
    ),
  );

  sl.registerLazySingleton<TripActionCubit>(
    () => TripActionCubit(
      sl.get<DriverRepo>(),
      sl.get<NetworkInfo>(),
    ),
  );
}
