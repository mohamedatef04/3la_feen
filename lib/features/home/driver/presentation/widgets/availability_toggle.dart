import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:ala_feen/core/utils/app_strings.dart';
import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AvailabilityToggle extends StatelessWidget {
  const AvailabilityToggle({
    super.key,
    required this.isAvailable,
    required this.onToggle,
  });

  final bool isAvailable;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppStrings.availableTrips,
            style: AppTextStyles.bold18(context).copyWith(
              color: AppColors.white,
            ),
          ),
          Transform.scale(
            scale: 1.2,
            child: Switch(
              value: isAvailable,
              onChanged: onToggle,
              activeThumbColor: Colors.green,
              activeTrackColor: AppColors.white,
              inactiveThumbColor: Colors.red,
              inactiveTrackColor: AppColors.white,
              trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }
}
