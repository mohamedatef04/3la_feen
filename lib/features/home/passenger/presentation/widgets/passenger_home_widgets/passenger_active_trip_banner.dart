import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/features/home/passenger/data/models/trip_model.dart';
import 'package:ala_feen/features/home/passenger/presentation/screens/track_driver_screen.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/track_driver_cubit/track_driver_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/get_route_cubit/get_route_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/draw_polyline_cubit/draw_polyline_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/passenger_trip_monitor_cubit/passenger_trip_monitor_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/cancel_trip_cubit/cancel_trip_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/get_driver_data_cubit/get_driver_data_cubit.dart';
import 'package:ala_feen/core/di/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PassengerActiveTripBanner extends StatelessWidget {
  final TripModel trip;

  const PassengerActiveTripBanner({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => sl<TrackDriverCubit>()),
                BlocProvider(create: (context) => sl<GetRouteCubit>()),
                BlocProvider(create: (context) => sl<DrawPolylineCubit>()),
                BlocProvider(
                  create: (context) => sl<PassengerTripMonitorCubit>(),
                ),
                BlocProvider(create: (context) => sl<CancelTripCubit>()),
                BlocProvider(create: (context) => sl<GetDriverDataCubit>()),
              ],
              child: TrackDriverScreen(
                trip: trip,
                // These might be null but TrackDriverScreen handles it
                driverName: null,
                driverPhone: null,
              ),
            ),
          ),
        );
      },
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
              child: const Icon(Icons.directions_car, color: Colors.white),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _getStatusTitle(trip.status),
                    style: AppTextStyles.bold14(
                      context,
                    ).copyWith(color: Colors.white),
                  ),
                  Text(
                    _getStatusSubtitle(trip.status, trip.distAddress ?? ''),
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

  String _getStatusTitle(String? status) {
    switch (status) {
      case 'driver_arrived':
        return 'الكابتن وصل بموقعك';
      case 'started':
        return 'أنت في الطريق الآن';
      default:
        return 'لديك رحلة نشطة حالياً';
    }
  }

  String _getStatusSubtitle(String? status, String destination) {
    switch (status) {
      case 'driver_arrived':
        return 'اتجه للسيارة لبدء الرحلة';
      case 'started':
        return 'وجهتك: $destination';
      default:
        return 'الكابتن في الطريق إليك';
    }
  }
}
