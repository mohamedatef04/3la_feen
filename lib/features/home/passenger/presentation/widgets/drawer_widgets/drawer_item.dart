import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: AppColors.primary,
        size: 24.sp,
      ),
      title: Text(
        title,
        style: AppTextStyles.bold18(context).copyWith(
          color: AppColors.primary,
        ),
      ),
      trailing: Icon(
        Icons.arrow_back_ios_new, // Arabic back icon
        color: AppColors.primary,
        size: 18.sp,
      ),
    );
  }
}
