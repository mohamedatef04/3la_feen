import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/features/home/passenger/data/models/trip_model.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/cancel_trip_cubit/cancel_trip_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/draw_polyline_cubit/draw_polyline_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/get_route_cubit/get_route_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/track_driver_cubit/track_driver_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/passenger_trip_monitor_cubit/passenger_trip_monitor_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/get_driver_data_cubit/get_driver_data_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/screens/track_driver_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ala_feen/core/di/injection_container.dart';

class BottomActionButtons extends StatefulWidget {
  final TripModel? trip;
  final String? driverName;
  final String? driverPhone;

  const BottomActionButtons({
    super.key,
    required this.trip,
    this.driverName,
    this.driverPhone,
  });

  @override
  State<BottomActionButtons> createState() => _BottomActionButtonsState();
}

class _BottomActionButtonsState extends State<BottomActionButtons> {
  bool _isLoadingMap = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CancelTripCubit>(),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Cancel Button
                Expanded(
                  child: BlocConsumer<CancelTripCubit, CancelTripState>(
                    listener: (context, state) {
                      if (state is CancelTripSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('trip.cancelled_success'.tr()),
                          ),
                        );
                        // Navigation will be handled by the trip monitor listener in the parent widget
                      } else if (state is CancelTripFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.errorMessage)),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is CancelTripLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return Container(
                        height: 56.h,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red, width: 2),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              if (widget.trip?.tripId != null) {
                                showDialog(
                                  context: context,
                                  builder: (dialogContext) => AlertDialog(
                                    title: Text('trip.cancel'.tr()),
                                    content: Text(
                                      'trip.cancel_confirm'.tr(),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(dialogContext),
                                        child: Text('common.no'.tr()),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(dialogContext);
                                          context
                                              .read<CancelTripCubit>()
                                              .cancelTrip(
                                                tripId: widget.trip!.tripId!,
                                              );
                                        },
                                        child: Text(
                                          'common.yes_cancel'.tr(),
                                          style: const TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            borderRadius: BorderRadius.circular(16.r),
                            child: Center(
                              child: Text(
                                'trip.cancel'.tr(),
                                style: AppTextStyles.bold14(context).copyWith(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                // Track Driver Button
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 56.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withValues(alpha: 0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          if (widget.trip != null) {
                            setState(() {
                              _isLoadingMap = true;
                            });
                            // Small delay to ensure the indicator is visible before the heavy map build
                            await Future.delayed(
                              const Duration(milliseconds: 100),
                            );
                            if (!context.mounted) return;

                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MultiBlocProvider(
                                  providers: [
                                    BlocProvider(
                                      create: (context) =>
                                          sl<TrackDriverCubit>(),
                                    ),
                                    BlocProvider(
                                      create: (context) => sl<GetRouteCubit>(),
                                    ),
                                    BlocProvider(
                                      create: (context) =>
                                          sl<DrawPolylineCubit>(),
                                    ),
                                    BlocProvider(
                                      create: (context) =>
                                          sl<PassengerTripMonitorCubit>(),
                                    ),
                                    BlocProvider(
                                      create: (context) =>
                                          sl<CancelTripCubit>(),
                                    ),
                                    BlocProvider(
                                      create: (context) =>
                                          sl<GetDriverDataCubit>(),
                                    ),
                                  ],
                                  child: TrackDriverScreen(
                                    trip: widget.trip!,
                                    driverName: widget.driverName,
                                    driverPhone: widget.driverPhone,
                                  ),
                                ),
                              ),
                            );

                            if (mounted) {
                              setState(() {
                                _isLoadingMap = false;
                              });
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('trip.loading_details'.tr()),
                              ),
                            );
                          }
                        },
                        borderRadius: BorderRadius.circular(16.r),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.my_location,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'passenger.track_captain'.tr(),
                                style: AppTextStyles.bold14(context).copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoadingMap)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.3),
                child: const Center(
                  child: CupertinoActivityIndicator(
                    color: Colors.white,
                    radius: 15,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
