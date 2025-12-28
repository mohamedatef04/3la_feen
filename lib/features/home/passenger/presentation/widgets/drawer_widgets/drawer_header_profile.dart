import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrawerHeaderProfile extends StatelessWidget {
  const DrawerHeaderProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 50.h, bottom: 20.h),
      color: AppColors.primary,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white, width: 2.w),
            ),
            child: CircleAvatar(
              radius: 50.r,
              backgroundImage: const NetworkImage(
                'https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D',
              ),
            ),
          ),
          SizedBox(height: 15.h),
          Text(
            '01200936120',
            style: AppTextStyles.bold20(context).copyWith(
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
