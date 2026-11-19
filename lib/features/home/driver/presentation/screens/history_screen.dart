import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/features/home/driver/presentation/widgets/driver_details_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  static const String routeName = '/history';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      body: Column(
        children: [
          DriverDetailsHeader(
            title: 'menu.history'.tr(),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.all(15.w),
              itemCount: 4,
              separatorBuilder: (context, index) => SizedBox(height: 10.h),
              itemBuilder: (context, index) {
                return _buildHistoryCard(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
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
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '0123456789',
              style: AppTextStyles.bold16(context).copyWith(
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Icon(
                      Icons.radio_button_checked,
                      color: AppColors.primary,
                      size: 16.sp,
                    ),
                    Container(
                      width: 1.w,
                      height: 20.h,
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                    Icon(
                      Icons.location_on,
                      color: AppColors.primary,
                      size: 16.sp,
                    ),
                  ],
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'placeholder.address_one'.tr(),
                        style: AppTextStyles.medium12(
                          context,
                        ).copyWith(color: AppColors.greyColor),
                      ),
                      SizedBox(height: 15.h),
                      Text(
                        'placeholder.address_two'.tr(),
                        style: AppTextStyles.medium12(
                          context,
                        ).copyWith(color: AppColors.greyColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
