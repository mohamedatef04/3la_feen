import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:ala_feen/features/home/driver/presentation/widgets/custom_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DriverHomeHeader extends StatelessWidget {
  const DriverHomeHeader({
    super.key,
    required this.onMenuPressed,
  });

  final VoidCallback onMenuPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180.h,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20.r),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: onMenuPressed,
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.menu,
                        color: AppColors.white,
                        size: 30.sp,
                      ),
                    ),
                  ),
                  const CustomProfileAvatar(isDrawer: false),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
