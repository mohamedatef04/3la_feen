import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/core/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChooseOnMapButton extends StatelessWidget {
  const ChooseOnMapButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            AppStrings.chooseOnMap,
            style: AppTextStyles.bold14(context).copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          SizedBox(width: 8.w),
          Icon(
            Icons.location_on_outlined,
            color: Theme.of(context).colorScheme.primary,
            size: 20.sp,
          ),
        ],
      ),
    );
  }
}
