import 'package:ala_feen/core/di/injection_container.dart';
import 'package:ala_feen/core/utils/app_strings.dart';
import 'package:easy_localization/easy_localization.dart';
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
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Section: Driver & Price
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Driver Avatar
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.5),
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 28.r,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: driver.profilePic != null
                          ? NetworkImage(driver.profilePic!)
                          : null,
                      child: driver.profilePic == null
                          ? Icon(
                              Icons.person,
                              size: 28.sp,
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
                      driver.name ?? 'common.captain_short'.tr(),
                      style: AppTextStyles.bold18(context),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                          size: 18.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '4.9', // Placeholder as rating is not in driver model yet
                          style: AppTextStyles.bold14(context).copyWith(
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          width: 4.w,
                          height: 4.w,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        // Trip count could go here if available
                        Text(
                          'passenger.available_now'.tr(),
                          style: AppTextStyles.regular12(context).copyWith(
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Price Info
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    AppStrings.price(offer.offerPrice),
                    style: AppTextStyles.bold18(context).copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  _buildPriceComparisonBadge(context),
                ],
              ),
            ],
          ),

          if (driver.carPic != null) ...[
            SizedBox(height: 16.h),
            Divider(color: Colors.grey[100], height: 1),
            SizedBox(height: 16.h),
            // Car Image & Accept Button
            Row(
              children: [
                Container(
                  width: 80.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: Colors.grey[100],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.network(
                      driver.carPic!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Icon(
                        Icons.directions_car,
                        color: Colors.grey[400],
                        size: 30.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: SizedBox(
                    height: 50.h,
                    child: BlocConsumer<AcceptOfferCubit, AcceptOfferState>(
                      listener: (context, state) {
                        if (state is AcceptOfferSuccess) {
                          GoRouter.of(
                            context,
                          ).go(AcceptOfferScreen.routeName, extra: offer);
                        }
                      },
                      builder: (context, state) {
                        return CustomButtonWidget(
                          onPressed: () {
                            context.read<AcceptOfferCubit>().acceptOffer(
                              offer.id ?? '',
                            );
                          },
                          backgroundColor: Colors.green,
                          child: state is AcceptOfferLoading
                              ? const CupertinoActivityIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  'passenger.accept_offer'.tr(),
                                  style: AppTextStyles.bold16(
                                    context,
                                  ).copyWith(color: Colors.white),
                                ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
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
      text = 'passenger.below_request'.tr();
      color = Colors.green;
      icon = Icons.trending_down;
    } else if (offerVal > requestedVal) {
      text = 'passenger.above_request'.tr();
      color = Colors.orange[800]!;
      icon = Icons.trending_up;
    } else {
      text = 'passenger.same_as_request'.tr();
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
