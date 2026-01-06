import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/accepted_offer_widgets/accept_offer_header.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/accepted_offer_widgets/bottom_action_buttons.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/accepted_offer_widgets/driver_info_card.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/accepted_offer_widgets/estimated_arrival_card.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/accepted_offer_widgets/success_icon_widget.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/accepted_offer_widgets/trip_details_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AcceptOfferScreen extends StatelessWidget {
  static const String routeName = '/accept_offer';

  const AcceptOfferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            const AcceptOfferHeader(),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),

                    // Success Animation/Icon
                    const SuccessIconWidget(),

                    SizedBox(height: 24.h),

                    // Success Message
                    Text(
                      'تم قبول العرض بنجاح!',
                      style: AppTextStyles.bold25(context),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 8.h),

                    Text(
                      'الكابتن في الطريق إليك',
                      style: AppTextStyles.regular14(context).copyWith(
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 32.h),

                    // Driver Info Card
                    const DriverInfoCard(),

                    SizedBox(height: 16.h),

                    // Trip Details Card
                    const TripDetailsCard(),

                    SizedBox(height: 16.h),

                    // Estimated Arrival Card
                    const EstimatedArrivalCard(),

                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),

            // Bottom Action Buttons
            const BottomActionButtons(),
          ],
        ),
      ),
    );
  }
}
