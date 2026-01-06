import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/core/utils/app_strings.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/get_places_items.dart/get_places_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/get_route_cubit/get_route_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/draw_polyline_cubit/draw_polyline_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/track_my_location_cubit/track_my_location_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/passenger_home_widgets/location_widgets/ride_location_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RideBookingCard extends StatefulWidget {
  const RideBookingCard({super.key});

  @override
  State<RideBookingCard> createState() => _RideBookingCardState();
}

class _RideBookingCardState extends State<RideBookingCard> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
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
            Text(
              '${AppStrings.chooseYourTripSafely} :',
              style: AppTextStyles.bold18(context).copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            GestureDetector(
              onTap: () async {
                final drawPolylineCubit = context.read<DrawPolylineCubit>();
                final getPlacesCubit = context.read<GetPlacesCubit>();
                final getRouteCubit = context.read<GetRouteCubit>();
                final trackMyLocationCubit = context
                    .read<TrackMyLocationCubit>();

                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: drawPolylineCubit),
                      BlocProvider.value(value: getPlacesCubit),
                      BlocProvider.value(value: getRouteCubit),
                      BlocProvider.value(value: trackMyLocationCubit),
                    ],
                    child: const RideLocationPopup(),
                  ),
                );
              },
              child: Container(
                height: 45.h,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.5),
                    width: 1.w,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      AppStrings.selectTheArea,
                      style: AppTextStyles.bold18(context),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
