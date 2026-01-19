import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/features/home/driver/presentation/screens/active_trip_map_screen.dart';
import 'package:ala_feen/features/home/passenger/data/models/trip_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class HomeActiveTripBanner extends StatelessWidget {
  final TripModel trip;

  const HomeActiveTripBanner({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(ActiveTripMapScreen.routeName, extra: trip),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: const BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.map_outlined, color: Colors.white),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'رحلة نشطة حالياً',
                    style: AppTextStyles.bold14(
                      context,
                    ).copyWith(color: Colors.white),
                  ),
                  Text(
                    'نحو: ${trip.distAddress}',
                    style: AppTextStyles.regular12(
                      context,
                    ).copyWith(color: Colors.white70),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }
}
