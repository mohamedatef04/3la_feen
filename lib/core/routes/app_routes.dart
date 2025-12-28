import 'package:ala_feen/core/di/injection_container.dart';
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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const GetStartedView(),
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
      path: '/login-callback/reset-password',
      redirect: (context, state) => ResetPasswordScreen.routeName,
    ),
  ],
);
