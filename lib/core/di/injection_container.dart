import 'package:ala_feen/core/api/api_service.dart';
import 'package:ala_feen/core/services/current_location_track_service.dart';
import 'package:ala_feen/features/auth/data/data_source/auth_data_source.dart';
import 'package:ala_feen/features/auth/data/repos/auth_repo.dart';
import 'package:ala_feen/features/auth/data/repos/auth_repo_impl.dart';
import 'package:ala_feen/features/auth/presentation/cubits/forget_password_cubit/forget_password_cubit.dart';
import 'package:ala_feen/features/auth/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:ala_feen/features/auth/presentation/cubits/register_cubit/cubit/register_cubit.dart';
import 'package:ala_feen/features/auth/presentation/cubits/reset_password_cubit/reset_password_cubit.dart';
import 'package:ala_feen/features/home/passenger/data/data_source/passenger_data_source.dart';
import 'package:ala_feen/features/home/passenger/data/repos/passenger_home_repo.dart';
import 'package:ala_feen/features/home/passenger/data/repos/passenger_home_repo_impl.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/accept_offer_cubit/accept_offer_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/draw_polyline_cubit/draw_polyline_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/get_driver_data_cubit/get_driver_data_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/get_offers_stream_cubit/get_prices_offers_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/get_passenger_data_cubit/get_passenger_data_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/get_places_items.dart/get_places_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/get_route_cubit/get_route_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/send_trip_cubit/send_trip_request_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/track_my_location_cubit/track_my_location_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final sl = GetIt.instance;

/// Initialize Dependency Injection
Future<void> init() async {
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);
  sl.registerLazySingleton<ApiService>(
    () => ApiService(),
  );
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
  //* passenger home
  sl.registerLazySingleton<CurrentLocationTrackService>(
    () => CurrentLocationTrackService(),
  );
  sl.registerLazySingleton<PassengerDataSource>(
    () => PassengerDataSourceImpl(
      sl.get<CurrentLocationTrackService>(),
      sl.get<ApiService>(),
      sl.get<SupabaseClient>(),
    ),
  );
  sl.registerLazySingleton<PassengerHomeRepo>(
    () => PassengerHomeRepoImpl(sl.get<PassengerDataSource>()),
  );
  sl.registerFactory<TrackMyLocationCubit>(
    () => TrackMyLocationCubit(sl.get<PassengerHomeRepo>()),
  );
  sl.registerFactory<DrawPolylineCubit>(
    () => DrawPolylineCubit(),
  );
  sl.registerFactory<GetPlacesCubit>(
    () => GetPlacesCubit(sl.get<PassengerHomeRepo>()),
  );
  sl.registerFactory<GetRouteCubit>(
    () => GetRouteCubit(sl.get<PassengerHomeRepo>()),
  );
  sl.registerFactory<SendTripRequestCubit>(
    () => SendTripRequestCubit(sl.get<PassengerHomeRepo>()),
  );
  sl.registerFactory<GetPassengerDataCubit>(
    () => GetPassengerDataCubit(sl.get<PassengerHomeRepo>()),
  );

  sl.registerFactory<GetDriverDataCubit>(
    () => GetDriverDataCubit(sl.get<PassengerHomeRepo>()),
  );
  sl.registerFactory<GetPricesOffersCubit>(
    () => GetPricesOffersCubit(sl.get<PassengerHomeRepo>()),
  );
  sl.registerFactory<AcceptOfferCubit>(
    () => AcceptOfferCubit(),
  );
}
