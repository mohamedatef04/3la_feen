import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/features/auth/data/models/user_model.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/get_driver_data_cubit/get_driver_data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DriverInfoCard extends StatelessWidget {
  const DriverInfoCard({super.key});

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
                  'معلومات الكابتن',
                  style: AppTextStyles.bold14(context),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    // Driver Avatar
                    _buildDriverAvatar(state.driverModel),
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

  Widget _buildDriverAvatar(UserModel driver) {
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
            backgroundColor: Colors.grey[200],
            backgroundImage: driver.profilePic != null
                ? NetworkImage(driver.profilePic!)
                : null,
            child: driver.profilePic == null
                ? Icon(
                    Icons.person,
                    size: 30.sp,
                    color: Colors.grey,
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
                color: Colors.grey[800],
              ),
            ),
            SizedBox(width: 4.w),
            Text(
              '(١٤٢ رحلة)',
              style: AppTextStyles.regular12(context).copyWith(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        // Car Info
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 6.h,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.directions_car,
                size: 16.sp,
                color: AppColors.primary,
              ),
              SizedBox(width: 6.w),
              Text(
                'تويوتا كامري 2020',
                style: AppTextStyles.medium12(context),
              ),
            ],
          ),
        ),
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
          onTap: () {
            // Handle phone button tap
          },
        ),
        SizedBox(height: 8.h),
        _buildContactButton(
          context,
          icon: Icons.message,
          color: AppColors.primary,
          onTap: () {
            // Handle message button tap
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
      onTap: () {
        // Handle contact button tap
      },
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
