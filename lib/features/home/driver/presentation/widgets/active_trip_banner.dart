import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:ala_feen/core/utils/app_strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/active_trip/active_trip_monitor_cubit.dart';
import 'package:ala_feen/features/home/passenger/data/models/trip_model.dart';
import 'package:ala_feen/features/chat/presentation/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ala_feen/core/di/injection_container.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/get_passenger_data/get_passenger_details_cubit.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/get_passenger_data/get_passenger_details_state.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class ActiveTripBanner extends StatelessWidget {
  final TripModel trip;
  final double? remainingDistance;
  final bool showStartTripButton;

  const ActiveTripBanner({
    super.key,
    required this.trip,
    this.remainingDistance,
    this.showStartTripButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = sl<GetPassengerDetailsCubit>();
        if (trip.passengerId != null) {
          cubit.getPassengerDetails(trip.passengerId!);
        }
        return cubit;
      },
      child: BlocBuilder<GetPassengerDetailsCubit, GetPassengerDetailsState>(
        builder: (context, state) {
          String passengerName = 'common.customer'.tr();
          String? passengerPhoto;

          if (state is GetPassengerDetailsSuccess) {
            passengerName = state.passengerModel.name ?? 'common.customer'.tr();
            passengerPhoto = state.passengerModel.profilePic;
          }

          final bool isStarted = trip.status == 'started';
          final bool isDriverArrived =
              trip.status == 'driver_arrived' || showStartTripButton;

          String distanceText = '';
          if (remainingDistance != null) {
            if (remainingDistance! < 1000) {
              distanceText = 'units.meters_long'.tr(
                namedArgs: {'value': remainingDistance!.toStringAsFixed(0)},
              );
            } else {
              distanceText = 'units.kilometers'.tr(
                namedArgs: {
                  'value': (remainingDistance! / 1000).toStringAsFixed(1),
                },
              );
            }
          }

          return Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
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
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 20.r,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: passengerPhoto != null
                            ? NetworkImage(passengerPhoto)
                            : null,
                        child: passengerPhoto == null
                            ? Icon(
                                Icons.person,
                                color: Theme.of(context).colorScheme.primary,
                                size: 24.sp,
                              )
                            : null,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state is GetPassengerDetailsLoading
                                ? 'common.loading'.tr()
                                : passengerName,
                            style: AppTextStyles.bold16(context).copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          if (trip.passengerPhoneNumber != null)
                            Text(
                              trip.passengerPhoneNumber!,
                              style: AppTextStyles.regular12(
                                context,
                              ).copyWith(color: Theme.of(context).hintColor),
                            ),
                        ],
                      ),
                    ),
                    // Chat button
                    IconButton(
                      onPressed: () => _openChat(context, passengerName),
                      icon: const Icon(Icons.chat, color: AppColors.primary),
                    ),
                    // Phone button
                    IconButton(
                      onPressed: () =>
                          _makePhoneCall(trip.passengerPhoneNumber),
                      icon: const Icon(Icons.phone, color: Colors.green),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        AppStrings.price(trip.tripPrice),
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
                    const Icon(
                      Icons.location_on,
                      color: Colors.green,
                      size: 20,
                    ),
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

                // Dynamic action button based on status
                if (isStarted)
                  // End Trip button when trip is in progress
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 8.w),
                        Text(
                          'trip.end'.tr(),
                          style: AppTextStyles.semiBold14(
                            context,
                          ).copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  )
                else if (isDriverArrived)
                  // Start Trip button when driver has arrived
                  ElevatedButton(
                    onPressed: () {
                      context.read<ActiveTripMonitorCubit>().updateTripStatus(
                        trip.tripId!,
                        'started',
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: Size(double.infinity, 50.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.play_arrow, color: Colors.white),
                        SizedBox(width: 8.w),
                        Text(
                          'trip.start'.tr(),
                          style: AppTextStyles.semiBold14(
                            context,
                          ).copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  )
                else
                  // Navigate to pickup instruction
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.navigation,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'driver.go_to_pickup'.tr(),
                          style:
                              AppTextStyles.bold14(
                                context,
                              ).copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        if (distanceText.isNotEmpty) ...[
                          SizedBox(width: 8.w),
                          Text(
                            '($distanceText)',
                            style:
                                AppTextStyles.bold14(
                                  context,
                                ).copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),

                // Cancel Trip button for driver (always visible until started)
                if (!isStarted) ...[
                  SizedBox(height: 8.h),
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          title: Text('trip.cancel'.tr()),
                          content: Text('trip.cancel_confirm'.tr()),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              child: Text('common.no'.tr()),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(dialogContext);
                                context
                                    .read<ActiveTripMonitorCubit>()
                                    .updateTripStatus(
                                      trip.tripId!,
                                      'cancelled',
                                    );
                              },
                              child: Text(
                                'common.yes_cancel'.tr(),
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text(
                      'trip.cancel'.tr(),
                      style: AppTextStyles.bold14(context).copyWith(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  void _openChat(BuildContext context, String passengerName) {
    if (trip.tripId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatScreen(
            tripId: trip.tripId!,
            otherUserName: passengerName,
          ),
        ),
      );
    }
  }

  void _makePhoneCall(String? phoneNumber) async {
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: phoneNumber,
      );
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      }
    }
  }
}
