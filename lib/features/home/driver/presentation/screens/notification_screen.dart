import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/features/home/driver/presentation/widgets/driver_details_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  static const String routeName = '/notifications';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      body: Column(
        children: [
          const DriverDetailsHeader(
            title: 'الاشعارات',
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.all(15.w),
              itemCount: 4,
              separatorBuilder: (context, index) => SizedBox(height: 10.h),
              itemBuilder: (context, index) {
                return _buildNotificationItem(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Text(
              '9:45',
              style: AppTextStyles.regular10(context).copyWith(
                color: AppColors.greyColor,
              ),
            ),
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons
                      .settings_input_component, // Replacement for the hub-like icon in mockup
                  color: AppColors.primary,
                  size: 24.sp,
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ادارة التطبيق',
                        style: AppTextStyles.bold14(context).copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        'شكرا لتسجيلك معنا كودك الان رقم 986532',
                        style: AppTextStyles.regular12(context).copyWith(
                          color: AppColors.greyColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
