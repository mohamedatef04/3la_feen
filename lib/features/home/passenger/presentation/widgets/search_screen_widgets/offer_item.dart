import 'dart:developer';

import 'package:ala_feen/core/di/injection_container.dart';
import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/features/get_started/widgets/custom_button_widget.dart';
import 'package:ala_feen/features/home/passenger/data/models/offer_model.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/accept_offer_cubit/accept_offer_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/get_driver_data_cubit/get_driver_data_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/screens/accept_offer_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class OfferItem extends StatelessWidget {
  final OfferModel offer;
  final num requestedPrice;
  const OfferItem({
    super.key,
    required this.offer,
    required this.requestedPrice,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              sl.get<GetDriverDataCubit>()..getDriverData(offer.driverId ?? ''),
        ),
        BlocProvider(
          create: (context) => sl.get<AcceptOfferCubit>(),
        ),
      ],
      child: BlocBuilder<GetDriverDataCubit, GetDriverDataState>(
        builder: (context, state) {
          if (state is GetDriverDataSuccess) {
            final driver = state.driverModel;
            return _buildOfferCard(context, driver);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildOfferCard(BuildContext context, dynamic driver) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h, left: 20.w, right: 20.w),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: Column(
          children: [
            // Top Section: Driver & Price
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  // Driver Image with Border & Verified Badge
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 30.r,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: driver.profilePic != null
                              ? NetworkImage(driver.profilePic!)
                              : null,
                          child: driver.profilePic == null
                              ? Icon(
                                  Icons.person,
                                  size: 30.sp,
                                  color: Colors.grey,
                                )
                              : null,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check,
                          size: 10.sp,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 12.w),
                  // Driver Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          driver.name ?? 'كابتن',
                          style: AppTextStyles.bold16(context),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 16.sp),
                            SizedBox(width: 4.w),
                            Text(
                              '4.9',
                              style: AppTextStyles.bold14(context).copyWith(
                                color: Colors.grey[800],
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '(١٤٢ رحلة)',
                              style: AppTextStyles.regular12(context).copyWith(
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Price Badge with Comparison
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildPriceComparisonBadge(context),
                      SizedBox(height: 8.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 10.h,
                        ),
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
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${offer.offerPrice}',
                              style: AppTextStyles.bold18(context).copyWith(
                                color: Colors.white,
                                height: 1,
                              ),
                            ),
                            Text(
                              'ج.م',
                              style: AppTextStyles.bold12(context).copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Middle Section: Car Info in a Row
            if (driver.carPic != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.grey[50]!.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: Colors.grey[100]!),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.network(
                            driver.carPic!,
                            width: 100.w,
                            height: 100.h,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'موديل السيارة:',
                              style: AppTextStyles.regular12(context).copyWith(
                                color: Colors.grey[500],
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'تويوتا كامري 2020', // Placeholder for model name
                              style: AppTextStyles.bold12(context),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            BlocConsumer<AcceptOfferCubit, AcceptOfferState>(
              listener: (context, state) {
                if (state is AcceptOfferSuccess) {
                  log('offer accepted successfully');
                  GoRouter.of(context).go(AcceptOfferScreen.routeName);
                }
                if (state is AcceptOfferFailure) {
                  log('offer accepted failed ${state.errorMessage}');
                }
              },
              builder: (context, state) {
                return Padding(
                  padding: EdgeInsets.all(16.w),
                  child: CustomButtonWidget(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    child: state is AcceptOfferLoading
                        ? const CupertinoActivityIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            'قبول',
                            style: AppTextStyles.bold14(context),
                          ),
                    onPressed: () {
                      context.read<AcceptOfferCubit>().acceptOffer(
                        offer.id ?? '',
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceComparisonBadge(BuildContext context) {
    final offerVal = offer.offerPrice ?? 0;
    final requestedVal = requestedPrice;

    String text;
    Color color;
    IconData icon;

    if (offerVal < requestedVal) {
      text = 'أقل من طلبك';
      color = Colors.green;
      icon = Icons.trending_down;
    } else if (offerVal > requestedVal) {
      text = 'أعلى من طلبك';
      color = Colors.orange[800]!;
      icon = Icons.trending_up;
    } else {
      text = 'نفس طلبك';
      color = Colors.blue;
      icon = Icons.unfold_more_double_outlined;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12.sp),
          SizedBox(width: 4.w),
          Text(
            text,
            style: AppTextStyles.bold10(context).copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
