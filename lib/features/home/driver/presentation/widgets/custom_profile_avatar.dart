import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/home_driver/home_driver_cubit.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/home_driver/home_driver_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomProfileAvatar extends StatelessWidget {
  final bool isDrawer;
  const CustomProfileAvatar({super.key, required this.isDrawer});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: CircleAvatar(
        radius: isDrawer ? 35.r : 25.r,
        backgroundImage:
            context.watch<HomeDriverCubit>().state.userModel?.profilePic != null
            ? NetworkImage(
                context.watch<HomeDriverCubit>().state.userModel?.profilePic ??
                    '',
              )
            : null,
        backgroundColor: AppColors.white,
        child: Icon(
          Icons.person,
          color: AppColors.black,
          size: isDrawer ? 40.sp : 24.sp,
        ),
      ),
    return BlocBuilder<HomeDriverCubit, HomeDriverState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: CircleAvatar(
            radius: isDrawer ? 35.r : 25.r,
            backgroundImage: state.userModel?.profilePic != null
                ? NetworkImage(
                    state.userModel?.profilePic ?? '',
                  )
                : null,
            backgroundColor: AppColors.white,
            child: state.userModel?.profilePic != null
                ? null
                : Icon(
                    Icons.person,
                    color: AppColors.black,
                    size: isDrawer ? 40.sp : 24.sp,
                  ),
          ),
        );
      },
    );
  }
}
