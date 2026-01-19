import 'package:ala_feen/core/utils/notifcations.dart/fcm.dart';
import 'package:ala_feen/core/utils/notifcations.dart/local.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/passenger_home_widgets/drawer_widgets/custom_passenger_drawer.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/home_google_maps_widget.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/passenger_home_widgets/top_bar_widgets/passenger_home_top_bar.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/passenger_home_widgets/home_widgets/passenger_home_bottom_section.dart';
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
  }

  Future<void> _initFCM() async {
    final LocalNotifications localNotifications = LocalNotifications();
    await localNotifications.init();
    await FcmService.instance.initFCM(localNotifications: localNotifications);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomPassengerDrawer(),
      body: Stack(
        children: [
          const HomeGoogleMapsWidget(),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: PassengerHomeTopBar(
              onMenuPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
          ),
          const PassengerHomeBottomSection(),
        ],
      ),
    );
  }
}
