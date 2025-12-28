import 'package:ala_feen/assets.dart';
import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/core/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UnavailableStateWidget extends StatelessWidget {
  const UnavailableStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 50.h),
        Image.asset(
          Assets.images.sleeping_2_png,
          height: 300.h,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.bed_rounded,
              size: 200.sp,
              color: AppColors.primary.withValues(alpha: 0.2),
            );
          },
        ),
        SizedBox(height: 20.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Text(
            AppStrings.tripsWillAppearWhenYouBecomeAvailable,
            textAlign: TextAlign.center,
            style: AppTextStyles.bold16(context).copyWith(
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
