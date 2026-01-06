import 'package:ala_feen/core/functions/show_snack_bar.dart';
import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/core/utils/app_strings.dart';
import 'package:ala_feen/features/get_started/widgets/custom_button_widget.dart';
import 'package:ala_feen/features/home/passenger/data/models/osrm_route_model.dart'
    as osrm;
import 'package:ala_feen/features/home/passenger/data/models/trip_model.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/send_trip_cubit/send_trip_request_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/draw_polyline_cubit/draw_polyline_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/get_route_cubit/get_route_cubit.dart';
import 'package:ala_feen/core/di/injection_container.dart';
import 'package:ala_feen/features/home/passenger/presentation/screens/searching_for_drivers_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RouteDetailsCard extends StatefulWidget {
  final osrm.Route route;
  final String startLocation;
  final String endLocation;
  final double startLat;
  final double startLng;
  final double endLat;
  final double endLng;
  final String passengerPhoneNumber;

  const RouteDetailsCard({
    super.key,
    required this.route,
    required this.startLocation,
    required this.endLocation,
    required this.startLat,
    required this.startLng,
    required this.endLat,
    required this.endLng,
    required this.passengerPhoneNumber,
  });

  @override
  State<RouteDetailsCard> createState() => _RouteDetailsCardState();
}

class _RouteDetailsCardState extends State<RouteDetailsCard> {
  late TextEditingController costController;

  @override
  void initState() {
    super.initState();
    costController = TextEditingController();
  }

  @override
  void dispose() {
    costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final distanceKm = ((widget.route.distance ?? 0) / 1000).toStringAsFixed(1);
    final durationMin = ((widget.route.duration ?? 0) / 60).toStringAsFixed(0);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: MediaQuery.of(context).size.height / 3,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.tripDetails,
                  style: AppTextStyles.bold18(context).copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    context.read<DrawPolylineCubit>().clearRoute();
                    context.read<GetRouteCubit>().reset();
                  },
                  icon: const Icon(Icons.close, color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            _buildLocationRow(
              context,
              icon: Icons.trip_origin,
              iconColor: Colors.green,
              label: '${AppStrings.from}:',
              location: widget.startLocation,
            ),
            SizedBox(height: 4.h),

            _buildLocationRow(
              context,
              icon: Icons.location_on,
              iconColor: Theme.of(context).colorScheme.primary,
              label: '${AppStrings.to}:',
              location: widget.endLocation,
            ),
            SizedBox(height: 12.h),

            Row(
              children: [
                _buildCompactInfoItem(
                  context,
                  icon: Icons.directions_car,
                  value: '$distanceKm ${AppStrings.km}',
                ),
                SizedBox(width: 15.w),
                _buildCompactInfoItem(
                  context,
                  icon: Icons.access_time,
                  value: '$durationMin ${AppStrings.minute}',
                ),
              ],
            ),
            SizedBox(height: 12.h),

            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: costController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: AppStrings.enterCost,
                      suffixText: AppStrings.egp,
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surfaceContainer,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 12.h,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                BlocConsumer<SendTripRequestCubit, SendTripRequestState>(
                  listener: (context, state) {
                    if (state is SendTripRequestSuccess) {
                      GoRouter.of(context).push(
                        SearchingForDriversScreen.routeName,
                        extra: state.tripModel,
                      );
                    } else if (state is SendTripRequestFailure) {
                      showCustomSnackBar(context, state.errorMessage);
                    }
                  },
                  builder: (context, state) {
                    return Expanded(
                      flex: 3,
                      child: CustomButtonWidget(
                        onPressed: () {
                          context.read<SendTripRequestCubit>().sendTripRequest(
                            tripModel: TripModel(
                              passengerId:
                                  sl<SupabaseClient>().auth.currentUser?.id,
                              originLat: widget.startLat.toString(),
                              originLng: widget.startLng.toString(),
                              originAddress: widget.startLocation,
                              distLat: widget.endLat.toString(),
                              distLng: widget.endLng.toString(),
                              distAddress: widget.endLocation,
                              tripDistance: distanceKm,
                              tripDuration: durationMin,
                              tripPrice: num.parse(costController.text),
                              passengerPhoneNumber: widget.passengerPhoneNumber,
                              status: 'searching',
                            ),
                          );
                        },
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(
                          context,
                        ).colorScheme.onPrimary,
                        child: state is SendTripRequestLoading
                            ? CupertinoActivityIndicator(
                                color: Theme.of(context).colorScheme.onPrimary,
                              )
                            : Text(
                                AppStrings.searchForDriver,
                                style: AppTextStyles.bold14(context).copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactInfoItem(
    BuildContext context, {
    required IconData icon,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 18.sp,
            ),
            SizedBox(width: 8.w),
            Flexible(
              child: Text(
                value,
                style: AppTextStyles.bold14(context).copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationRow(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String label,
    required String location,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 20.sp),
        SizedBox(width: 10.w),
        Text(
          label,
          style: AppTextStyles.bold14(context).copyWith(color: Colors.grey),
        ),
        SizedBox(width: 5.w),
        Expanded(
          child: Text(
            location,
            style: AppTextStyles.semiBold14(context),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
