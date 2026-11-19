import 'package:ala_feen/features/home/passenger/presentation/cubits/get_passenger_data_cubit/get_passenger_data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TopBarProfileImage extends StatelessWidget {
  const TopBarProfileImage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetPassengerDataCubit, GetPassengerDataState>(
      builder: (context, state) {
        if (state is GetPassengerDataSuccess) {
          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.onSurface,
                width: 2.w,
              ),
            ),
            child: CircleAvatar(
              radius: 26.r,
              backgroundImage: NetworkImage(
                state.userModel.profilePic ?? '',
              ),
              backgroundColor: Theme.of(context).colorScheme.surface,
            ),
          );
        } else if (state is GetPassengerDataFailure) {
          return const Icon(Icons.error);
        } else {
          return Skeletonizer(
            enabled: true,
            enableSwitchAnimation: true,
            child: CircleAvatar(
              radius: 28.r,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: CircleAvatar(
                radius: 26.r,
                backgroundColor: Theme.of(context).colorScheme.surface,
              ),
            ),
          );
        }
      },
    );
  }
}
