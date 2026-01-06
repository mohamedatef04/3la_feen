import 'package:ala_feen/features/home/passenger/presentation/widgets/passenger_home_widgets/drawer_widgets/custom_passenger_drawer.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/home_google_maps_widget.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/passenger_home_widgets/top_bar_widgets/passenger_home_top_bar.dart';
import 'package:ala_feen/features/home/passenger/presentation/widgets/passenger_home_widgets/home_widgets/passenger_home_bottom_section.dart';
import 'package:flutter/material.dart';

class PassengerHomeScreen extends StatelessWidget {
  const PassengerHomeScreen({super.key});

  static const String routeName = '/passenger-home';

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
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
                scaffoldKey.currentState?.openDrawer();
              },
            ),
          ),
          const PassengerHomeBottomSection(),
        ],
      ),
    );
  }
}
