import 'package:ala_feen/core/api/api_service.dart';
import 'package:ala_feen/core/services/current_location_track_service.dart';
import 'package:ala_feen/core/network/network_info.dart';
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
import 'package:ala_feen/features/home/passenger/presentation/cubits/get_trip_details_cubit/get_trip_details_cubit.dart';
import 'package:ala_feen/features/home/driver/data/dataSource/driver_remote_data_source.dart';
import 'package:ala_feen/features/home/driver/data/repo/driver_repo.dart';
import 'package:ala_feen/features/home/driver/data/repo/driver_repo_imp.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/active_trip/active_trip_monitor_cubit.dart';
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
  sl.registerFactory<GetTripDetailsCubit>(
    () => GetTripDetailsCubit(sl.get<PassengerHomeRepo>()),
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
  sl.registerLazySingleton<ActiveTripMonitorCubit>(
    () => ActiveTripMonitorCubit(sl.get<DriverRepo>(), sl.get<NetworkInfo>()),
  );
}
