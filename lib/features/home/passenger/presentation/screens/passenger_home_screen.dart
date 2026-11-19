import 'package:ala_feen/core/utils/notifications/fcm.dart';
import 'package:ala_feen/core/utils/notifications/local.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/passenger_trip_monitor_cubit/passenger_trip_monitor_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/get_passenger_data_cubit/get_passenger_data_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/passenger_home_widgets/drawer_widgets/custom_passenger_drawer.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/home_google_maps_widget.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/passenger_home_widgets/top_bar_widgets/passenger_home_top_bar.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/passenger_home_widgets/home_widgets/passenger_home_bottom_section.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/passenger_home_widgets/passenger_active_trip_banner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class PassengerHomeScreen extends StatefulWidget {
  const PassengerHomeScreen({super.key});

  static const String routeName = '/passenger-home';

  @override
  State<PassengerHomeScreen> createState() => _PassengerHomeScreenState();
}

class _PassengerHomeScreenState extends State<PassengerHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _initFCM();
    // Monitor active trip if data is already loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<GetPassengerDataCubit>().state;
      if (state is GetPassengerDataSuccess && state.userModel.id != null) {
        context.read<PassengerTripMonitorCubit>().monitorActiveTrip(
          state.userModel.id!,
        );
      }
    });
  }

  Future<void> _initFCM() async {
    final LocalNotifications localNotifications = LocalNotifications();
    await localNotifications.init();
    await FcmService.instance.initFCM(localNotifications: localNotifications);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetPassengerDataCubit, GetPassengerDataState>(
      listener: (context, state) {
        if (state is GetPassengerDataSuccess && state.userModel.id != null) {
          context.read<PassengerTripMonitorCubit>().monitorActiveTrip(
            state.userModel.id!,
          );
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: const CustomPassengerDrawer(),
        body: Stack(
          children: [
            const HomeGoogleMapsWidget(),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  PassengerHomeTopBar(
                    onMenuPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                  BlocBuilder<
                    PassengerTripMonitorCubit,
                    PassengerTripMonitorState
                  >(
                    builder: (context, state) {
                      if (state.status != PassengerTripStatus.initial &&
                          state.status != PassengerTripStatus.loading &&
                          state.status != PassengerTripStatus.cancelled &&
                          state.status != PassengerTripStatus.completed &&
                          state.trip != null) {
                        return PassengerActiveTripBanner(trip: state.trip!);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
            const PassengerHomeBottomSection(),
          ],
        ),
      ),
    );
  }
}
