import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/get_passenger_data_cubit/get_passenger_data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrawerHeaderProfile extends StatelessWidget {
  const DrawerHeaderProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetPassengerDataCubit, GetPassengerDataState>(
      builder: (context, state) {
        if (state is GetPassengerDataSuccess) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 50.h, bottom: 20.h),
            color: Theme.of(context).colorScheme.primary,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.onSurface,
                      width: 2.w,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 50.r,
                    backgroundImage: NetworkImage(
                      state.userModel.profilePic ?? '',
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
                Text(
                  state.userModel.phone ?? '',
                  style: AppTextStyles.bold20(context).copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          );
        } else if (state is GetPassengerDataFailure) {
          return const Icon(Icons.error);
        } else {
          return const Icon(Icons.error);
        }
      },
    );
  }
}
