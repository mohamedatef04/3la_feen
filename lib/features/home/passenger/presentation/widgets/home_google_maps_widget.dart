import 'package:ala_feen/core/utils/map_style.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ala_feen/core/cubits/cubit/theme_toggle_cubit.dart';
import 'package:ala_feen/core/functions/show_snack_bar.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/draw_polyline_cubit/draw_polyline_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/track_my_location_cubit/track_my_location_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeGoogleMapsWidget extends StatefulWidget {
  const HomeGoogleMapsWidget({super.key});

  @override
  State<HomeGoogleMapsWidget> createState() => _HomeGoogleMapsWidgetState();
}

class _HomeGoogleMapsWidgetState extends State<HomeGoogleMapsWidget> {
  late CameraPosition initialCameraPosition;
  GoogleMapController? mapController;
  String? _mapStyle;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  bool isFirstLocationUpdate = true;
  bool _isMapLoading = true;

  @override
  void initState() {
    initialCameraPosition = const CameraPosition(
      target: LatLng(27.686582867452735, 30.94757040769661),
      zoom: 7,
    );
    super.initState();
  }

  Future<void> _setMapStyle({Brightness? brightness}) async {
    final style = await MapStyle.load(
      brightness ?? Theme.of(context).brightness,
    );
    if (mounted) setState(() => _mapStyle = style);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ThemeToggleCubit, ThemeData>(
          listener: (context, state) {
            _setMapStyle(brightness: state.brightness);
          },
        ),
        BlocListener<TrackMyLocationCubit, TrackMyLocationState>(
          listener: (context, state) {
            if (state is TrackMyLocationFailure) {
              showCustomSnackBar(
                context,
                state.errorMessage,
                isError: true,
              );
              // Stop loading if location fails
              setState(() {
                _isMapLoading = false;
              });
            }
          },
        ),
        BlocListener<DrawPolylineCubit, DrawPolylineState>(
          listener: (context, state) {
            setState(() {
              polylines = state.polylines;
              // Preserve the 'my_location' marker if it exists
              Marker? myLocationMarker;
              try {
                myLocationMarker = markers.firstWhere(
                  (m) => m.markerId.value == 'my_location',
                );
              } catch (_) {
                myLocationMarker = null;
              }

              markers = {...state.markers};
              if (myLocationMarker != null) {
                markers.add(myLocationMarker);
              }
            });

            if (state.bounds != null && mapController != null) {
              mapController!.animateCamera(
                CameraUpdate.newLatLngBounds(state.bounds!, 50),
              );
            }
          },
        ),
      ],
      child: Stack(
        children: [
          GoogleMap(
            style: _mapStyle,
            initialCameraPosition: initialCameraPosition,
            onMapCreated: (controller) {
              mapController = controller;
              _setMapStyle();
              // Start tracking location when map is created
              context.read<TrackMyLocationCubit>().getCurrentLocation(
                (locationData) {
                  if (!mounted) return;
                  final latLng = LatLng(
                    locationData.latitude!,
                    locationData.longitude!,
                  );
                  if (isFirstLocationUpdate && mapController != null) {
                    mapController!.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: latLng,
                          zoom: 15,
                        ),
                      ),
                    );
                    isFirstLocationUpdate = false;
                    setState(() {
                      _isMapLoading = false;
                    });
                  } else {
                    // In case it's not the first update but we're still loading
                    if (_isMapLoading) {
                      setState(() {
                        _isMapLoading = false;
                      });
                    }
                  }
                  setState(() {
                    // Update only the position of the existing 'my_location' marker
                    markers.removeWhere(
                      (m) => m.markerId.value == 'my_location',
                    );
                    markers.add(
                      Marker(
                        markerId: const MarkerId('my_location'),
                        position: latLng,
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueAzure,
                        ),
                        infoWindow: InfoWindow(
                          title: 'map.my_current_location'.tr(),
                        ),
                      ),
                    );
                  });
                },
              );

              // Fallback timeout
              Future.delayed(const Duration(seconds: 5), () {
                if (mounted && _isMapLoading) {
                  setState(() {
                    _isMapLoading = false;
                  });
                }
              });
            },
            mapType: MapType.normal,
            zoomControlsEnabled: false,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            markers: markers,
            polylines: polylines,
          ),
          if (_isMapLoading)
            Positioned.fill(
              child: Skeletonizer(
                enabled: true,
                child: Container(
                  color: Colors.grey[300],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
