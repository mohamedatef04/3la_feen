import 'package:ala_feen/core/di/injection_container.dart';
import 'package:ala_feen/core/utils/app_strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/features/home/passenger/data/models/trip_model.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/rating_cubit/rating_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class TripCompletedScreen extends StatefulWidget {
  static const String routeName = '/trip-completed';
  final TripModel trip;
  final String driverName;

  const TripCompletedScreen({
    super.key,
    required this.trip,
    required this.driverName,
  });

  @override
  State<TripCompletedScreen> createState() => _TripCompletedScreenState();
}

class _TripCompletedScreenState extends State<TripCompletedScreen> {
  int _selectedRating = 0;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<RatingCubit>(),
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<RatingCubit, RatingState>(
            listener: (context, state) {
              if (state is RatingSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('rating.thanks'.tr())),
                );
                context.go('/');
              } else if (state is RatingFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage)),
                );
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  children: [
                    SizedBox(height: 40.h),
                    // Success Icon
                    Container(
                      width: 120.w,
                      height: 120.w,
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 80.sp,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'trip.completed_title'.tr(),
                      style: AppTextStyles.bold25(context),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'app.thanks_for_riding'.tr(),
                      style: AppTextStyles.regular14(context).copyWith(
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40.h),

                    // Trip Summary Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildInfoRow(
                            context,
                            Icons.location_on,
                            'trip.from'.tr(),
                            widget.trip.origin ?? 'trip.pickup'.tr(),
                          ),
                          Divider(height: 24.h),
                          _buildInfoRow(
                            context,
                            Icons.flag,
                            'trip.to'.tr(),
                            widget.trip.destination ?? 'trip.destination'.tr(),
                          ),
                          Divider(height: 24.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'trip.total_fare'.tr(),
                                style: AppTextStyles.bold14(context),
                              ),
                              Text(
                                AppStrings.price(widget.trip.price ?? 0),
                                style: AppTextStyles.bold18(context).copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32.h),

                    // Rating Section
                    Text(
                      'passenger.rate_trip_with'.tr(
                        namedArgs: {'name': widget.driverName},
                      ),
                      style: AppTextStyles.bold16(context),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedRating = index + 1;
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Icon(
                              index < _selectedRating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 40.sp,
                            ),
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 24.h),

                    // Comment Field
                    TextField(
                      controller: _commentController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'passenger.add_comment'.tr(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        filled: true,
                        fillColor:
                            Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[800]
                            : Colors.grey[100],
                      ),
                    ),
                    SizedBox(height: 32.h),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 56.h,
                      child: ElevatedButton(
                        onPressed: state is RatingLoading
                            ? null
                            : () {
                                if (_selectedRating > 0 &&
                                    widget.trip.tripId != null &&
                                    widget.trip.driverId != null) {
                                  context.read<RatingCubit>().submitRating(
                                    tripId: widget.trip.tripId!,
                                    driverId: widget.trip.driverId!,
                                    passengerId: widget.trip.passengerId!,
                                    rating: _selectedRating,
                                    comment: _commentController.text.isEmpty
                                        ? null
                                        : _commentController.text,
                                  );
                                } else if (_selectedRating == 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'rating.select_rating'.tr(),
                                      ),
                                    ),
                                  );
                                } else {
                                  // Skip rating and go home
                                  context.go('/');
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        child: state is RatingLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'rating.submit'.tr(),
                                style: AppTextStyles.bold16(context).copyWith(
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Skip Button
                    TextButton(
                      onPressed: () => context.go('/'),
                      child: Text(
                        'common.skip'.tr(),
                        style: AppTextStyles.regular14(context).copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20.sp),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.regular12(context).copyWith(
                  color: Colors.grey[500],
                ),
              ),
              Text(
                value,
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
}
