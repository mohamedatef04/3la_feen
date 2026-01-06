import 'package:ala_feen/core/widgets/logo_widget.dart';
import 'package:ala_feen/features/home/passenger/presentation/screens/accept_offer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopBarLogo extends StatelessWidget {
  const TopBarLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AcceptOfferScreen(),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 5,
            ),
          ],
        ),
        child: LogoWidget(height: 38.h),
      ),
    );
  }
}
