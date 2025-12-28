import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/core/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocationPopupHeader extends StatelessWidget {
  const LocationPopupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.close,
              size: 20.sp,
              color: Colors.black,
            ),
          ),
        ),
        const Spacer(),
        Text(
          AppStrings.enterYourPath,
          style: AppTextStyles.bold18(context).copyWith(
            color: Colors.black,
          ),
        ),
        const Spacer(),
        SizedBox(width: 30.w), // Balance for the close button
      ],
    );
  }
}
