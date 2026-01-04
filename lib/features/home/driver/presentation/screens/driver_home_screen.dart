import 'package:ala_feen/core/utils/notifcations.dart/fcm.dart';
import 'package:ala_feen/core/utils/notifcations.dart/local.dart';
import 'package:ala_feen/features/home/driver/presentation/widgets/availability_toggle.dart';
import 'package:ala_feen/features/home/driver/presentation/widgets/custom_driver_drawer.dart';
import 'package:ala_feen/features/home/driver/presentation/widgets/driver_home_header.dart';
import 'package:ala_feen/features/home/driver/presentation/widgets/trips_list.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          const Expanded(child: TripsList()),
        ],
      ),
    );
  }
}
