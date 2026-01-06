import 'package:ala_feen/features/home/passenger/presentation/widgets/passenger_home_widgets/top_bar_widgets/top_bar_logo.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/passenger_home_widgets/top_bar_widgets/top_bar_menu_button.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/passenger_home_widgets/top_bar_widgets/top_bar_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PassengerHomeTopBar extends StatelessWidget {
  const PassengerHomeTopBar({super.key, required this.onMenuPressed});

  final VoidCallback onMenuPressed;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          child: Row(
            children: [
              TopBarMenuButton(onPressed: onMenuPressed),
              const Spacer(),
              const TopBarLogo(),
              const Spacer(),
              const TopBarProfileImage(),
            ],
          ),
        ),
      ),
    );
  }
}
