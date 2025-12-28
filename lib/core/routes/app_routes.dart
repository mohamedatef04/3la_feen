import 'package:ala_feen/core/di/injection_container.dart';
import 'package:ala_feen/features/auth/presentation/cubits/register_cubit/cubit/register_cubit.dart';
import 'package:ala_feen/features/auth/presentation/screens/login_screen.dart';
import 'package:ala_feen/features/auth/presentation/screens/register_screen.dart';
import 'package:ala_feen/features/auth/presentation/screens/success_registration_view.dart';
import 'package:ala_feen/features/get_started/screens/get_started_view.dart';
import 'package:ala_feen/features/home/driver/presentation/screens/driver_home_screen.dart';
import 'package:ala_feen/features/home/driver/presentation/screens/account_screen.dart';
import 'package:ala_feen/features/home/driver/presentation/screens/history_screen.dart';
import 'package:ala_feen/features/home/driver/presentation/screens/notification_screen.dart';
import 'package:ala_feen/features/home/driver/presentation/screens/rates_screen.dart';
import 'package:ala_feen/features/home/passenger/presentation/screens/passenger_home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const PassengerHomeScreen(),
    ),
    GoRoute(
      path: LoginScreen.routeName,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: RegisterScreen.routeName,
      builder: (context, state) => BlocProvider(
        create: (context) => sl.get<RegisterCubit>(),
        child: const RegisterScreen(),
      ),
    ),
    GoRoute(
      path: SuccessRegistrationView.routeName,
      builder: (context, state) => const SuccessRegistrationView(),
    ),
    GoRoute(
      path: DriverHomeScreen.routeName,
      builder: (context, state) => const DriverHomeScreen(),
    ),
    GoRoute(
      path: AccountScreen.routeName,
      builder: (context, state) => const AccountScreen(),
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
  ],
);
