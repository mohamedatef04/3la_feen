import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeGoogleMapsWidget extends StatefulWidget {
  const HomeGoogleMapsWidget({super.key});

  @override
  State<HomeGoogleMapsWidget> createState() => _HomeGoogleMapsWidgetState();
}

class _HomeGoogleMapsWidgetState extends State<HomeGoogleMapsWidget> {
  late CameraPosition initialCameraPosition;
  late GoogleMapController mapController;
  String? mapStyle;
  @override
  void initState() {
    initialCameraPosition = const CameraPosition(
      target: LatLng(30.046555254564122, 31.234774235031885),
      zoom: 13,
    );

    super.initState();
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: initialCameraPosition,
          cameraTargetBounds: CameraTargetBounds(
            LatLngBounds(
              southwest: const LatLng(30.36226629559752, 30.912662177999945),
              northeast: const LatLng(30.36226629559752, 30.912662177999945),
            ),
          ),
          onMapCreated: (controller) {
            mapController = controller;
          },

          mapType: MapType.normal,

          zoomControlsEnabled: false,
        ),
      ],
    );
  }
}
