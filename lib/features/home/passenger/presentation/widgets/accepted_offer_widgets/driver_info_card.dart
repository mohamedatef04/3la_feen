import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/features/auth/data/models/user_model.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/get_driver_data_cubit/get_driver_data_cubit.dart';
import 'package:ala_feen/features/chat/presentation/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverInfoCard extends StatelessWidget {
  final String tripId;
  const DriverInfoCard({super.key, required this.tripId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetDriverDataCubit, GetDriverDataState>(
      builder: (context, state) {
        if (state is GetDriverDataSuccess) {
          return Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'passenger.captain_info'.tr(),
                  style: AppTextStyles.bold14(context),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    // Driver Avatar
                    _buildDriverAvatar(context, state.driverModel),
                    SizedBox(width: 16.w),
                    // Driver Details
                    Expanded(
                      child: _buildDriverDetails(context, state.driverModel),
                    ),
                    // Contact Buttons
                    _buildContactButtons(context, state.driverModel),
                  ],
                ),
              ],
            ),
          );
        } else if (state is GetDriverDataFailure) {
          return Center(
            child: Text(state.errorMessage),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildDriverAvatar(BuildContext context, UserModel driver) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary,
              width: 2,
            ),
          ),
          child: CircleAvatar(
            radius: 30.r,
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? Theme.of(context).colorScheme.surfaceContainerHighest
                : Colors.grey[200],
            backgroundImage: driver.profilePic != null
                ? NetworkImage(driver.profilePic!)
                : null,
            child: driver.profilePic == null
                ? Icon(
                    Icons.person,
                    size: 30.sp,
                    color: Theme.of(
                      context,
                    ).iconTheme.color?.withValues(alpha: 0.5),
                  )
                : null,
          ),
        ),
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check,
            size: 10.sp,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildDriverDetails(BuildContext context, UserModel driver) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          driver.name ?? '',
          style: AppTextStyles.bold14(context),
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            Icon(Icons.star, color: Colors.amber, size: 16.sp),
            SizedBox(width: 4.w),
            Text(
              '4.9',
              style: AppTextStyles.bold14(context).copyWith(
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            SizedBox(width: 4.w),
          ],
        ),
        SizedBox(height: 8.h),

        // Car Info
      ],
    );
  }

  Widget _buildContactButtons(BuildContext context, UserModel driver) {
    return Column(
      children: [
        _buildContactButton(
          context,
          icon: Icons.phone,
          color: Colors.green,
          onTap: () async {
            if (driver.phone != null) {
              final Uri launchUri = Uri(
                scheme: 'tel',
                path: driver.phone,
              );
              if (await canLaunchUrl(launchUri)) {
                await launchUrl(launchUri);
              }
            }
          },
        ),
        SizedBox(height: 8.h),
        _buildContactButton(
          context,
          icon: Icons.message,
          color: AppColors.primary,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatScreen(
                  tripId: tripId,
                  otherUserName: driver.name ?? 'common.captain'.tr(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildContactButton(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
          ),
        ),
        child: Icon(
          icon,
          size: 20.sp,
          color: color,
        ),
      ),
    );
  }
}
