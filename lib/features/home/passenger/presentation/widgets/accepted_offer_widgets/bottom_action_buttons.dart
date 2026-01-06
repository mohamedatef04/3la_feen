import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomActionButtons extends StatelessWidget {
  const BottomActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Cancel Button
          Expanded(
            child: Container(
              height: 56.h,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 2),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // TODO: Cancel trip logic
                  },
                  borderRadius: BorderRadius.circular(16.r),
                  child: Center(
                    child: Text(
                      'إلغاء الرحلة',
                      style: AppTextStyles.bold14(context).copyWith(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // Track Driver Button
          Expanded(
            flex: 2,
            child: Container(
              height: 56.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // TODO: Track driver logic
                  },
                  borderRadius: BorderRadius.circular(16.r),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.my_location,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'تتبع الكابتن',
                          style: AppTextStyles.bold14(context).copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
