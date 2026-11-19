import 'package:ala_feen/features/home/passenger/presentation/cubits/get_passenger_data_cubit/get_passenger_data_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/get_route_cubit/get_route_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/passenger_home_widgets/booking_widgets/ride_booking_card.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/passenger_home_widgets/booking_widgets/route_details_card.dart';
import 'package:ala_feen/core/utils/responsive_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PassengerHomeBottomSection extends StatelessWidget {
  const PassengerHomeBottomSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ResponsiveContainer(
        maxWidth: 600,
        child: BlocBuilder<GetPassengerDataCubit, GetPassengerDataState>(
          builder: (context, passengerState) {
            String phone = '';
            if (passengerState is GetPassengerDataSuccess) {
              phone = passengerState.userModel.phone ?? '';
            }
            return BlocBuilder<GetRouteCubit, GetRouteState>(
              builder: (context, state) {
                if (state is GetRouteSuccess &&
                    state.route.routes != null &&
                    state.route.routes!.isNotEmpty) {
                  return RouteDetailsCard(
                    route: state.route.routes![0],
                    startLocation: state.startLocation,
                    endLocation: state.endLocation,
                    startLat: state.startLat,
                    startLng: state.startLng,
                    endLat: state.endLat,
                    endLng: state.endLng,
                    passengerPhoneNumber: phone,
                  );
                }
                return const RideBookingCard();
              },
            );
          },
        ),
      ),
    );
  }
}
