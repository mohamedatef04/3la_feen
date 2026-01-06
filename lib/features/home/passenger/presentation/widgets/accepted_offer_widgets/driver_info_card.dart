import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DriverInfoCard extends StatelessWidget {
  const DriverInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
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
            style: AppTextStyles.bold16(context),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              // Driver Avatar
              _buildDriverAvatar(),
              SizedBox(width: 16.w),
              // Driver Details
              Expanded(
                child: _buildDriverDetails(context),
              ),
              // Contact Buttons
              _buildContactButtons(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDriverAvatar() {
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
            radius: 35.r,
            backgroundColor: Colors.grey[200],
            child: Icon(
              Icons.person,
              size: 35.sp,
              color: Colors.grey,
            ),
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
            size: 12.sp,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildDriverDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'أحمد محمد', // Placeholder
          style: AppTextStyles.bold16(context),
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

  Widget _buildContactButtons(BuildContext context) {
    return Column(
      children: [
        _buildContactButton(
          context,
          icon: Icons.phone,
          color: Colors.green,
        ),
        SizedBox(height: 8.h),
        _buildContactButton(
          context,
          icon: Icons.message,
          color: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildContactButton(
    BuildContext context, {
    required IconData icon,
    required Color color,
  }) {
    return Container(
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
    );
  }
}
