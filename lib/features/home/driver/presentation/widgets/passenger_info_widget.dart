import 'package:ala_feen/core/di/injection_container.dart';
import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/get_passenger_data/get_passenger_details_cubit.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/get_passenger_data/get_passenger_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PassengerInfoWidget extends StatelessWidget {
  final String passengerId;
  const PassengerInfoWidget({super.key, required this.passengerId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<GetPassengerDetailsCubit>()..getPassengerDetails(passengerId),
      child: BlocBuilder<GetPassengerDetailsCubit, GetPassengerDetailsState>(
        builder: (context, state) {
          if (state is GetPassengerDetailsSuccess) {
            final user = state.passengerModel;
            final hasImage =
                user.profilePic != null && user.profilePic!.isNotEmpty;

            return Row(
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundColor: AppColors.lightGrey,
                  backgroundImage: hasImage
                      ? NetworkImage(user.profilePic!)
                      : null,
                  child: !hasImage
                      ? Icon(
                          Icons.person,
                          color: AppColors.primary,
                          size: 24.sp,
                        )
                      : null,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name ?? 'راكب',
                        style: AppTextStyles.bold18(context).copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            user.rating?.toStringAsFixed(1) ?? '5.0',
                            style: AppTextStyles.regular12(context).copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          // Loading/Error state skeleton
          return Skeletonizer(
            enabled: true,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundColor: AppColors.lightGrey,
                ),
                SizedBox(width: 12.w),
                Container(
                  width: 100.w,
                  height: 20.h,
                  color: Colors.white,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
