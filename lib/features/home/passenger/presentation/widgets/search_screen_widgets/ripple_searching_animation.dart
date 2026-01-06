import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/get_passenger_data_cubit/get_passenger_data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RippleSearchingAnimation extends StatefulWidget {
  const RippleSearchingAnimation({
    super.key,
  });

  @override
  State<RippleSearchingAnimation> createState() =>
      _RippleSearchingAnimationState();
}

class _RippleSearchingAnimationState extends State<RippleSearchingAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildRipple(0.0),
          _buildRipple(0.33),
          _buildRipple(0.66),
          _buildCentralAvatar(),
        ],
      ),
    );
  }

  Widget _buildRipple(double delay) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double progress = (_controller.value + delay) % 1.0;
        double size = 80.w + (progress * 240.w);
        double opacity = 0.5 * (1.0 - progress);

        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary.withValues(alpha: opacity),
              width: 1.5,
            ),
          ),
        );
      },
    );
  }

  Widget _buildCentralAvatar() {
    return BlocBuilder<GetPassengerDataCubit, GetPassengerDataState>(
      builder: (context, state) {
        if (state is GetPassengerDataSuccess) {
          imageUrl = state.userModel.profilePic;
        }
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.2),
              width: 8.w,
            ),
          ),
          child: CircleAvatar(
            radius: 45.r,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 42.r,
              backgroundColor: Colors.grey[200],
              backgroundImage: imageUrl != null
                  ? NetworkImage(imageUrl!)
                  : null,
              child: imageUrl == null
                  ? Icon(Icons.person, size: 40.sp, color: Colors.grey)
                  : null,
            ),
          ),
        );
      },
    );
  }
}
