import 'package:ala_feen/core/utils/app_strings.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/passenger_home_widgets/drawer_widgets/drawer_header_profile.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/passenger_home_widgets/drawer_widgets/drawer_item.dart';
import 'package:ala_feen/core/widgets/theme_toggle_item.dart';
import 'package:ala_feen/features/auth/presentation/cubits/logout_cubit/logout_cubit.dart';
import 'package:ala_feen/features/auth/presentation/cubits/logout_cubit/logout_state.dart';
import 'package:ala_feen/features/auth/presentation/screens/login_screen.dart';
import 'package:ala_feen/core/di/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CustomPassengerDrawer extends StatelessWidget {
  const CustomPassengerDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250.w,
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          const DrawerHeaderProfile(),
          Expanded(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                children: [
                  // Notifications Item removed
                  /*
                  DrawerItem(
                    icon: Icons.notifications_none,
                    title: AppStrings.notifications,
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/notifications');
                    },
                  ),
                  */
                  BlocProvider(
                    create: (context) => sl<LogoutCubit>(),
                    child: BlocConsumer<LogoutCubit, LogoutState>(
                      listener: (context, state) {
                        if (state is LogoutSuccess) {
                          context.go(LoginScreen.routeName);
                        } else if (state is LogoutFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.errorMessage)),
                          );
                        }
                      },
                      builder: (context, state) {
                        return DrawerItem(
                          icon: Icons.logout,
                          title: AppStrings.logout,
                          onTap: () {
                            context.read<LogoutCubit>().logout();
                          },
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  const ThemeToggleItem(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
