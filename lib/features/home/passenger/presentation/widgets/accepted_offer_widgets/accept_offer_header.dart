import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AcceptOfferHeader extends StatelessWidget {
  const AcceptOfferHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20.sp,
            ),
          ),
          Expanded(
            child: Text(
              'تفاصيل الرحلة',
              style: AppTextStyles.bold18(context),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: 40.w), // Balance the back button
        ],
      ),
    );
  }
}
