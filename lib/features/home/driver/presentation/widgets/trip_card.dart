import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/core/utils/app_strings.dart';
import 'package:ala_feen/features/get_started/widgets/custom_button_widget.dart';
import 'package:ala_feen/features/home/driver/presentation/widgets/passenger_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TripCard extends StatelessWidget {
  const TripCard({
    super.key,
    required this.passengerId,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.price,
    required this.onAccept,
    required this.onNegotiate,
  });

  final String passengerId;
  final String pickupLocation;
  final String dropoffLocation;
  final String price;
  final VoidCallback onAccept;
  final Function(double price) onNegotiate;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12.r),
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
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Passenger Info (Name and Photo)
                  PassengerInfoWidget(passengerId: passengerId),
                  SizedBox(height: 12.h),
                  // Locations Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icons Column on the right
                      Column(
                        children: [
                          Icon(
                            Icons.radio_button_checked,
                            color: AppColors.primary,
                            size: 18.sp,
                          ),
                          Container(
                            width: 1.5.w,
                            height: 25.h,
                            color: AppColors.primary.withValues(alpha: 0.5),
                          ),
                          Icon(
                            Icons.location_on,
                            color: AppColors.primary,
                            size: 18.sp,
                          ),
                        ],
                      ),
                      SizedBox(width: 12.w),
                      // Text Column to the left of icons
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pickupLocation,
                              style: AppTextStyles.bold14(context).copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(height: 15.h),
                            Text(
                              dropoffLocation,
                              style: AppTextStyles.bold14(context).copyWith(
                                color: AppColors.primary,
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
            const Divider(height: 1, thickness: 1, color: AppColors.lightGrey),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Price on the right (first child in RTL Row)
                  Row(
                    children: [
                      Text(
                        '$price ${AppStrings.pound}',
                        style: AppTextStyles.bold18(context).copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          'EGP',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 7.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Buttons Row
                  Row(
                    children: [
                      CustomButtonWidget(
                        width: 100.w,
                        height: 35.h,
                        backgroundColor: Colors.transparent,
                        foregroundColor: AppColors.primary,
                        borderSide: const BorderSide(color: AppColors.primary),
                        onPressed: () {
                          _showNegotiateDialog(context);
                        },
                        child: Text(
                          'driver.negotiate'.tr(),
                          style: AppTextStyles.bold14(context),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      CustomButtonWidget(
                        onPressed: onAccept,
                        width: 100.w,
                        height: 35.h,
                        child: Text(
                          AppStrings.approve,
                          style: AppTextStyles.bold14(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNegotiateDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController(text: price);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('driver.negotiate_price'.tr(), textAlign: TextAlign.right),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: 'driver.enter_offer_price'.tr(),
            suffixText: 'units.egp'.tr(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.cancel'.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                onNegotiate(double.parse(controller.text));
                Navigator.pop(context);
              }
            },
            child: Text('driver.send_offer'.tr()),
          ),
        ],
      ),
    );
  }
}
