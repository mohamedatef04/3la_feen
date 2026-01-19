import 'dart:developer';

import 'package:ala_feen/assets.dart';
import 'package:ala_feen/core/di/injection_container.dart';
import 'package:ala_feen/features/auth/data/repos/auth_repo.dart';
import 'package:ala_feen/features/auth/presentation/cubits/forget_password_cubit/forget_password_cubit.dart';
import 'package:ala_feen/features/auth/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:ala_feen/features/auth/presentation/cubits/register_cubit/cubit/register_cubit.dart';
import 'package:ala_feen/features/auth/presentation/cubits/reset_password_cubit/reset_password_cubit.dart';
import 'package:ala_feen/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:ala_feen/features/auth/presentation/screens/login_screen.dart';
import 'package:ala_feen/features/auth/presentation/screens/register_screen.dart';
import 'package:ala_feen/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:ala_feen/features/auth/presentation/screens/success_registration_view.dart';
import 'package:ala_feen/features/get_started/screens/get_started_view.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/home_driver/home_driver_cubit.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/trip_action/trip_action_cubit.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/trips_stream/trips_stream_cubit.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/active_trip/active_trip_monitor_cubit.dart';
import 'package:ala_feen/features/home/driver/presentation/screens/driver_home_screen.dart';
import 'package:ala_feen/features/home/driver/presentation/screens/driver_offer_accepted_screen.dart';
import 'package:ala_feen/features/home/driver/presentation/screens/active_trip_map_screen.dart';
import 'package:ala_feen/features/home/driver/presentation/screens/account_screen.dart';
import 'package:ala_feen/features/home/driver/presentation/screens/history_screen.dart';
import 'package:ala_feen/features/home/driver/presentation/screens/notification_screen.dart';
import 'package:ala_feen/features/home/driver/presentation/screens/rates_screen.dart';
import 'package:ala_feen/features/home/passenger/data/models/trip_model.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/get_offers_stream_cubit/get_prices_offers_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/track_my_location_cubit/track_my_location_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/draw_polyline_cubit/draw_polyline_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/get_passenger_data_cubit/get_passenger_data_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/get_places_items.dart/get_places_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/get_route_cubit/get_route_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/send_trip_cubit/send_trip_request_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/screens/passenger_home_screen.dart';
import 'package:ala_feen/features/home/passenger/presentation/screens/searching_for_drivers_widget.dart';
import 'package:ala_feen/features/home/passenger/presentation/screens/accept_offer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        final userId = Supabase.instance.client.auth.currentUser?.id;
        log('userId: $userId');

        if (userId == null) {
          return const GetStartedView();
        }

        return FutureBuilder<Widget>(
          future: _getHomeScreenForUser(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(
                  child: Lottie.asset(
                    Assets.images.loading_lottie_json,
                    width: 200,
                    height: 200,
                  ),
                ),
              );
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return const GetStartedView();
            }

            return snapshot.data!;
          },
        );
      },
    ),
    GoRoute(
      path: LoginScreen.routeName,
      builder: (context, state) => BlocProvider(
        create: (context) => sl.get<LoginCubit>(),
        child: const LoginScreen(),
      ),
    ),
    GoRoute(
      path: RegisterScreen.routeName,
      builder: (context, state) => BlocProvider(
        create: (context) => sl.get<RegisterCubit>(),
        child: const RegisterScreen(),
      ),
    ),
    GoRoute(
      path: ForgetPasswordScreen.routeName,
      builder: (context, state) => BlocProvider(
        create: (context) => sl.get<ForgetPasswordCubit>(),
        child: const ForgetPasswordScreen(),
      ),
    ),
    GoRoute(
      path: SuccessRegistrationView.routeName,
      builder: (context, state) => const SuccessRegistrationView(),
    ),
    GoRoute(
      path: ResetPasswordScreen.routeName,
      builder: (context, state) => BlocProvider(
        create: (context) => sl.get<ResetPasswordCubit>(),
        child: const ResetPasswordScreen(),
      ),
    ),
    // Handle Supabase deep link callback paths
    GoRoute(
      path: ResetPasswordScreen.routeName,
      redirect: (context, state) => ResetPasswordScreen.routeName,
    ),
    GoRoute(
      path: DriverHomeScreen.routeName,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: sl.get<HomeDriverCubit>()),
          BlocProvider.value(value: sl.get<TripsStreamCubit>()),
          BlocProvider.value(value: sl.get<TripActionCubit>()),
          BlocProvider.value(value: sl.get<ActiveTripMonitorCubit>()),
        ],
        child: const DriverHomeScreen(),
      ),
    ),
    GoRoute(
      path: DriverOfferAcceptedScreen.routeName,
      builder: (context, state) {
        final trip = state.extra as TripModel;
        return BlocProvider.value(
          value: sl.get<ActiveTripMonitorCubit>(),
          child: DriverOfferAcceptedScreen(trip: trip),
        );
      },
    ),
    GoRoute(
      path: ActiveTripMapScreen.routeName,
      builder: (context, state) {
        final trip = state.extra as TripModel;
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: sl.get<ActiveTripMonitorCubit>()),
            BlocProvider(create: (context) => sl.get<TrackMyLocationCubit>()),
            BlocProvider(create: (context) => sl.get<GetRouteCubit>()),
            BlocProvider(create: (context) => sl.get<DrawPolylineCubit>()),
          ],
          child: ActiveTripMapScreen(trip: trip),
        );
      },
    ),
    GoRoute(
      path: AccountScreen.routeName,
      builder: (context, state) => BlocProvider(
        create: (context) => sl.get<HomeDriverCubit>(),
        child: const AccountScreen(),
      ),
    ),
    GoRoute(
      path: NotificationScreen.routeName,
      builder: (context, state) => const NotificationScreen(),
    ),
    GoRoute(
      path: RatesScreen.routeName,
      builder: (context, state) => const RatesScreen(),
    ),
    GoRoute(
      path: HistoryScreen.routeName,
      builder: (context, state) => const HistoryScreen(),
    ),
    GoRoute(
      path: PassengerHomeScreen.routeName,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => sl.get<TrackMyLocationCubit>()),
          BlocProvider(create: (context) => sl.get<DrawPolylineCubit>()),
          BlocProvider(create: (context) => sl.get<GetPlacesCubit>()),
          BlocProvider(create: (context) => sl.get<GetRouteCubit>()),
          BlocProvider(create: (context) => sl.get<SendTripRequestCubit>()),
          BlocProvider(
            create: (context) =>
                sl.get<GetPassengerDataCubit>()..getPassengerData(),
          ),
        ],
        child: const PassengerHomeScreen(),
      ),
    ),
    GoRoute(
      path: SearchingForDriversScreen.routeName,
      builder: (context, state) {
        final tripModel = state.extra as TripModel;
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  sl.get<GetPassengerDataCubit>()..getPassengerData(),
            ),
            BlocProvider(create: (context) => sl.get<GetPricesOffersCubit>()),
          ],
          child: SearchingForDriversScreen(tripModel: tripModel),
        );
      },
    ),
    GoRoute(
      path: AcceptOfferScreen.routeName,
      builder: (context, state) => const AcceptOfferScreen(),
    ),
  ],
);

// Helper function to get the appropriate home screen based on user role
Future<Widget> _getHomeScreenForUser(String userId) async {
  try {
    final authRepo = sl.get<AuthRepo>();
    final roleResult = await authRepo.getUserRole(userId: userId);

    return roleResult.fold(
      (failure) {
        return const GetStartedView();
      },
      (role) {
        if (role == 'driver') {
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(value: sl.get<HomeDriverCubit>()),
              BlocProvider.value(value: sl.get<TripsStreamCubit>()),
              BlocProvider.value(value: sl.get<TripActionCubit>()),
            ],
            child: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: sl.get<HomeDriverCubit>()),
                BlocProvider.value(value: sl.get<TripsStreamCubit>()),
                BlocProvider.value(value: sl.get<TripActionCubit>()),
                BlocProvider.value(value: sl.get<ActiveTripMonitorCubit>()),
              ],
              child: const DriverHomeScreen(),
            ),
          );
        } else if (role == 'passenger') {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl.get<TrackMyLocationCubit>()),
              BlocProvider(create: (context) => sl.get<DrawPolylineCubit>()),
              BlocProvider(create: (context) => sl.get<GetPlacesCubit>()),
              BlocProvider(create: (context) => sl.get<GetRouteCubit>()),
              BlocProvider(create: (context) => sl.get<SendTripRequestCubit>()),
              BlocProvider(
                create: (context) =>
                    sl.get<GetPassengerDataCubit>()..getPassengerData(),
              ),
            ],
            child: const PassengerHomeScreen(),
          );
        }
        return const GetStartedView();
      },
    );
  } catch (e) {
    return const GetStartedView();
  }
}
