import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/core/utils/app_strings.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/home_driver/home_driver_cubit.dart';
import 'package:ala_feen/features/home/driver/presentation/screens/account_screen.dart';
import 'package:ala_feen/features/home/driver/presentation/screens/history_screen.dart';
import 'package:ala_feen/features/home/driver/presentation/screens/notification_screen.dart';
import 'package:ala_feen/features/home/driver/presentation/screens/rates_screen.dart';
import 'package:ala_feen/features/home/driver/presentation/widgets/custom_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CustomDriverDrawer extends StatelessWidget {
  const CustomDriverDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 280.w,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: 60.h,
              bottom: 20.h,
              right: 20.w,
              left: 20.w,
            ),
            color: AppColors.primary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      context.watch<HomeDriverCubit>().state.userModel?.name ??
                          '',
                      style: AppTextStyles.bold18(context).copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      context.watch<HomeDriverCubit>().state.userModel?.phone ??
                          '',
                      style: AppTextStyles.bold16(context).copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 15.w),
                const CustomProfileAvatar(isDrawer: true),
              ],
            ),
          ),
          Expanded(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    context,
                    icon: Icons.person_outline,
                    title: AppStrings.account,
                    onTap: () => context.push(AccountScreen.routeName),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.notifications_none,
                    title: AppStrings.notifications,
                    onTap: () => context.push(NotificationScreen.routeName),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.star_border,
                    title: AppStrings.ratings,
                    onTap: () => context.push(RatesScreen.routeName),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.history,
                    title: AppStrings.history,
                    onTap: () => context.push(HistoryScreen.routeName),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.logout,
                    title: AppStrings.logout,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
        size: 24.sp,
      ),
      title: Text(
        title,
        style: AppTextStyles.medium16(context).copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Theme.of(context).colorScheme.primary,
        size: 16.sp,
      ),
      onTap: onTap,
    );
  }
}
