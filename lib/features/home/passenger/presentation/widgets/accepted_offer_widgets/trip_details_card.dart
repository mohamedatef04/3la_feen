import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:ala_feen/core/utils/app_strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/get_trip_details_cubit/get_trip_details_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/accepted_offer_widgets/dotted_line_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TripDetailsCard extends StatelessWidget {
  const TripDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetTripDetailsCubit, GetTripDetailsState>(
      builder: (context, state) {
        if (state is GetTripDetailsSuccess) {
          return Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'trip.details'.tr(),
                  style: AppTextStyles.bold14(context),
                ),
                SizedBox(height: 16.h),
                // From Location
                _buildLocationRow(
                  context,
                  icon: Icons.circle,
                  iconColor: Colors.green,
                  title: 'trip.from'.tr(),
                  location: state.trip.originAddress ?? '',
                ),
                SizedBox(height: 12.h),
                // Dotted Line
                Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: CustomPaint(
                    size: Size(2, 30.h),
                    painter: DottedLinePainter(),
                  ),
                ),
                SizedBox(height: 12.h),
                // To Location
                _buildLocationRow(
                  context,
                  icon: Icons.location_on,
                  iconColor: Colors.red,
                  title: 'trip.to'.tr(),
                  location: state.trip.distAddress ?? '',
                ),
                SizedBox(height: 20.h),
                // Trip Stats
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        context,
                        icon: Icons.access_time,
                        label: 'trip.duration_short'.tr(),
                        value: state.trip.tripDuration ?? '',
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _buildStatItem(
                        context,
                        icon: Icons.straighten,
                        label: 'trip.distance'.tr(),
                        value: state.trip.tripDistance ?? '',
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _buildStatItem(
                        context,
                        icon: Icons.payments,
                        label: 'trip.price'.tr(),
                        value: AppStrings.price(state.trip.tripPrice),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else if (state is GetTripDetailsFailure) {
          return Center(
            child: Text(state.errorMessage),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildLocationRow(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String location,
  }) {
    return Row(
      children: [
        Container(
          width: 24.w,
          height: 24.w,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 14.sp,
            color: iconColor,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.regular12(context).copyWith(
                  color: Colors.grey[500],
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                location,
                style: AppTextStyles.medium14(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 20.sp,
            color: AppColors.primary,
          ),
          SizedBox(height: 6.h),
          Text(
            value,
            style: AppTextStyles.bold12(context),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: AppTextStyles.regular10(context).copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
