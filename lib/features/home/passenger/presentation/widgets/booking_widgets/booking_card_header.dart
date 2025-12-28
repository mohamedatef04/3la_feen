import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/core/utils/app_strings.dart';
import 'package:flutter/material.dart';

class BookingCardHeader extends StatelessWidget {
  const BookingCardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '${AppStrings.chooseYourTripSafely} :',
      style: AppTextStyles.bold18(context).copyWith(
        color: AppColors.primary,
      ),
    );
  }
}
