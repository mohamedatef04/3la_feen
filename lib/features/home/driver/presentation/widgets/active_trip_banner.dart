import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/active_trip/active_trip_monitor_cubit.dart';
import 'package:ala_feen/features/home/passenger/data/models/trip_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ActiveTripBanner extends StatelessWidget {
  final TripModel trip;
  final double? remainingDistance;

  const ActiveTripBanner({
    super.key,
    required this.trip,
    this.remainingDistance,
  });

  @override
  Widget build(BuildContext context) {
    final bool isStarted = trip.status == 'started';
    String distanceText = '';
    if (remainingDistance != null) {
      if (remainingDistance! < 1000) {
        distanceText = '${remainingDistance!.toStringAsFixed(0)} متر';
      } else {
        distanceText = '${(remainingDistance! / 1000).toStringAsFixed(1)} كم';
      }
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person, color: Colors.blue, size: 24.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'العميل',
                      style: AppTextStyles.regular12(
                        context,
                      ).copyWith(color: Colors.grey),
                    ),
                    Text(
                      trip.passengerPhoneNumber ?? 'رقم غير معروف',
                      style: AppTextStyles.bold16(context),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  '${trip.tripPrice} ج.م',
                  style: AppTextStyles.bold14(
                    context,
                  ).copyWith(color: Colors.green),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.green, size: 20),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  trip.originAddress ?? '',
                  style: AppTextStyles.regular14(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              const Icon(Icons.flag, color: Colors.red, size: 20),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  trip.distAddress ?? '',
                  style: AppTextStyles.regular14(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          if (isStarted)
            ElevatedButton(
              onPressed: () {
                context.read<ActiveTripMonitorCubit>().updateTripStatus(
                  trip.tripId!,
                  'completed',
                );
                context.read<ActiveTripMonitorCubit>().clearActiveTrip();
                context.pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: Size(double.infinity, 50.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'إنهاء الرحلة',
                style: AppTextStyles.semiBold14(
                  context,
                ).copyWith(color: Colors.white),
              ),
            )
          else
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'توجه إلى نقطة الانطلاق',
                    style: AppTextStyles.bold14(
                      context,
                    ).copyWith(color: Colors.blue),
                  ),
                  if (distanceText.isNotEmpty) ...[
                    SizedBox(width: 8.w),
                    Text(
                      '($distanceText)',
                      style: AppTextStyles.bold14(
                        context,
                      ).copyWith(color: Colors.blue),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}
