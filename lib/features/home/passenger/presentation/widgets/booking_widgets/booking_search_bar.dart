import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/location_widgets/ride_location_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingSearchBar extends StatelessWidget {
  const BookingSearchBar({super.key, required this.hint});

  final String hint;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const RideLocationPopup(),
        );
      },
      child: Container(
        height: 45.h,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.5),
            width: 1.w,
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_on, color: AppColors.primary),
            SizedBox(width: 8.w),
            Text(hint, style: AppTextStyles.bold18(context)),
          ],
        ),
      ),
    );
  }
}
