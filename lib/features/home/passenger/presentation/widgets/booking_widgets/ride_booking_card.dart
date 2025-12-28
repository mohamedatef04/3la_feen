import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:ala_feen/core/utils/app_strings.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/booking_widgets/booking_card_header.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/booking_widgets/booking_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RideBookingCard extends StatelessWidget {
  const RideBookingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          spacing: 15.h,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BookingCardHeader(),
            const BookingSearchBar(hint: AppStrings.selectTheArea),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
