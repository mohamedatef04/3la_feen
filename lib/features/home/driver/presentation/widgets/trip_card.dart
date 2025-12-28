import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/core/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TripCard extends StatelessWidget {
  const TripCard({
    super.key,
    required this.phoneNumber,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.price,
    required this.onAccept,
  });

  final String phoneNumber;
  final String pickupLocation;
  final String dropoffLocation;
  final String price;
  final VoidCallback onAccept;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Phone Number (Aligned to start in RTL is right)
                  Text(
                    phoneNumber,
                    style: AppTextStyles.bold20(context).copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  // Locations Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icons Column on the right
                      Column(
                        children: [
                          Icon(
                            Icons.radio_button_checked,
                            color: AppColors.primary,
                            size: 18.sp,
                          ),
                          Container(
                            width: 1.5.w,
                            height: 25.h,
                            color: AppColors.primary.withValues(alpha: 0.5),
                          ),
                          Icon(
                            Icons.location_on,
                            color: AppColors.primary,
                            size: 18.sp,
                          ),
                        ],
                      ),
                      SizedBox(width: 12.w),
                      // Text Column to the left of icons
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pickupLocation,
                              style: AppTextStyles.bold14(context).copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(height: 15.h),
                            Text(
                              dropoffLocation,
                              style: AppTextStyles.bold14(context).copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: AppColors.lightGrey),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Price on the right (first child in RTL Row)
                  Row(
                    children: [
                      Text(
                        '$price ${AppStrings.pound}',
                        style: AppTextStyles.bold18(context).copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          'EGP',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 7.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Accept Button on the left (second child in RTL Row)
                  ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 25.w,
                        vertical: 6.h,
                      ),
                    ),
                    child: Text(
                      AppStrings.approve,
                      style: AppTextStyles.bold16(context).copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
