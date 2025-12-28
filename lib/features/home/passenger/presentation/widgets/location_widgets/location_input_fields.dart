import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:ala_feen/core/utils/app_strings.dart';
import 'package:ala_feen/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocationInputFields extends StatelessWidget {
  const LocationInputFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Stack(
        children: [
          Column(
            children: [
              CustomTextFormField(
                hintText: AppStrings.from,
                fillColor: Colors.grey[100],
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 12.h,
                ),
                prefixIcon: Icon(
                  Icons.trip_origin,
                  color: Colors.green,
                  size: 20.sp,
                ),
              ),
              SizedBox(height: 12.h),
              CustomTextFormField(
                hintText: AppStrings.to,
                autofocus: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 12.h,
                ),
                prefixIcon: Icon(
                  Icons.location_on,
                  color: AppColors.primary,
                  size: 24.sp,
                ),
              ),
            ],
          ),
          // Vertical Connecting Line
          Positioned(
            right: 25.w, // Aligned with the icons
            top: 40.h,
            bottom: 40.h,
            child: Container(
              width: 1.5.w,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
