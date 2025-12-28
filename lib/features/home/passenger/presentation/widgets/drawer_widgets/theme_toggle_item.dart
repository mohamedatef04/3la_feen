import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/core/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ThemeToggleItem extends StatefulWidget {
  const ThemeToggleItem({super.key});

  @override
  State<ThemeToggleItem> createState() => _ThemeToggleItemState();
}

class _ThemeToggleItemState extends State<ThemeToggleItem> {
  bool isDarkMode = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 15.w,
        vertical: 10.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.brightness_6_outlined,
                color: AppColors.primary,
                size: 24.sp,
              ),
              SizedBox(width: 15.w),
              Text(
                AppStrings.darkMode,
                style: AppTextStyles.bold16(context).copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          Switch(
            value: isDarkMode,
            onChanged: (value) {
              setState(() {
                isDarkMode = value;
              });
            },
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
