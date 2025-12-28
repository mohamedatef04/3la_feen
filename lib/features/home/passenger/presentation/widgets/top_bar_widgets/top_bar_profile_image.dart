import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopBarProfileImage extends StatelessWidget {
  const TopBarProfileImage({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 28.r,
      backgroundColor: AppColors.primary,
      child: CircleAvatar(
        radius: 26.r,
        backgroundImage: const NetworkImage(
          'https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D',
        ),
        backgroundColor: AppColors.white,
      ),
    );
  }
}
