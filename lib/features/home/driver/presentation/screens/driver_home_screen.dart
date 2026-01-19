import 'package:ala_feen/core/utils/notifcations.dart/fcm.dart';
import 'package:ala_feen/core/utils/notifcations.dart/local.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/home_driver/home_driver_cubit.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/home_driver/home_driver_state.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/active_trip/active_trip_monitor_cubit.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/active_trip/active_trip_state.dart';
import 'package:ala_feen/features/home/driver/presentation/widgets/availability_toggle.dart';
import 'package:ala_feen/features/home/driver/presentation/widgets/custom_driver_drawer.dart';
import 'package:ala_feen/features/home/driver/presentation/widgets/driver_home_header.dart';
import 'package:ala_feen/features/home/driver/presentation/widgets/home_active_trip_banner.dart';
import 'package:ala_feen/features/home/driver/presentation/widgets/trips_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  static const String routeName = '/driver-home';

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isAvailable = false;

  @override
  initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final LocalNotifications localNotifications = LocalNotifications();
    await localNotifications.init();
    FcmService.instance.initFCM(localNotifications: localNotifications);

    if (mounted) {
      // Logic moved to BlocListener for reactivity
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeDriverCubit, HomeDriverState>(
      listener: (context, state) {
        if (state.status == HomeDriverStatus.success &&
            state.userModel?.id != null) {
          context.read<ActiveTripMonitorCubit>().monitorActiveTrip(
            state.userModel!.id!,
          );
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: const CustomDriverDrawer(),
        body: Column(
          children: [
            Stack(
              children: [
                DriverHomeHeader(
                  onMenuPressed: () => _scaffoldKey.currentState!.openDrawer(),
                ),
                Positioned(
                  bottom: 20.h,
                  left: 20.w,
                  right: 20.w,
                  child: AvailabilityToggle(
                    isAvailable: _isAvailable,
                    onToggle: (value) {
                      setState(() {
                        _isAvailable = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            BlocBuilder<ActiveTripMonitorCubit, ActiveTripState>(
              builder: (context, state) {
                if (state.status == ActiveTripStatus.active &&
                    state.activeTrip != null) {
                  return HomeActiveTripBanner(trip: state.activeTrip!);
                }
                return const SizedBox.shrink();
              },
            ),
            const Expanded(child: TripsList()),
          ],
        ),
      ),
    );
  }
}
