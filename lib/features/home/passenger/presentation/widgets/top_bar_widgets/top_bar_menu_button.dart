import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopBarMenuButton extends StatelessWidget {
  const TopBarMenuButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: AppColors.lightGrey.withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.menu,
          color: AppColors.primary,
          size: 28.sp,
        ),
      ),
    );
  }
}
