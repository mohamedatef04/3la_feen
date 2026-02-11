import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:ala_feen/core/utils/marker_utils.dart';
import 'package:ala_feen/features/home/passenger/data/models/trip_model.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/draw_polyline_cubit/draw_polyline_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/get_route_cubit/get_route_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/track_driver_cubit/track_driver_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/passenger_trip_monitor_cubit/passenger_trip_monitor_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/cancel_trip_cubit/cancel_trip_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/get_driver_data_cubit/get_driver_data_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/screens/trip_completed_screen.dart';
import 'package:ala_feen/features/chat/presentation/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ala_feen/core/utils/decode_polykine.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'dart:math' show cos, sqrt, asin;

class TrackDriverScreen extends StatefulWidget {
  static const String routeName = '/track-driver';
  final TripModel trip;
  final String? driverName;
  final String? driverPhone;

  const TrackDriverScreen({
    super.key,
    required this.trip,
    this.driverName,
    this.driverPhone,
  });

  @override
  State<TrackDriverScreen> createState() => _TrackDriverScreenState();
}

class _TrackDriverScreenState extends State<TrackDriverScreen> {
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  LatLng? driverLocation;
  String? distanceText;
  String? durationText;
  late TripModel currentTrip;
  bool _isMapLoading = true;

  @override
  void initState() {
    super.initState();
    currentTrip = widget.trip;

    if (widget.trip.driverId != null) {
      context.read<TrackDriverCubit>().trackDriver(widget.trip.driverId!);
      // Fetch driver details if they weren't passed (e.g., from home banner)
      if (widget.driverName == null) {
        context.read<GetDriverDataCubit>().getDriverData(widget.trip.driverId!);
      }
    }
    if (widget.trip.tripId != null) {
      context.read<PassengerTripMonitorCubit>().monitorTrip(
        widget.trip.tripId!,
      );
    }
    // _initMarkers will be called after first driver location update or immediately if we have data
    // We defer route drawing slightly to ensure we have driver location for the "Driver->Pickup" leg
  }

  void _initMarkers({LatLng? driverPos}) {
    markers.clear(); // Clear existing to avoid duplicates on re-init

    // Pickup location (person marker - my location)
    markers.add(
      Marker(
        markerId: const MarkerId('pickup'),
        position: LatLng(
          double.parse(widget.trip.originLat ?? '0'),
          double.parse(widget.trip.originLng ?? '0'),
        ),
        icon: MarkerUtils.personMarker,
        infoWindow: const InfoWindow(title: 'موقعي'),
      ),
    );
    // Destination (station marker)
    markers.add(
      Marker(
        markerId: const MarkerId('destination'),
        position: LatLng(
          double.parse(widget.trip.distLat ?? '0'),
          double.parse(widget.trip.distLng ?? '0'),
        ),
        icon: MarkerUtils.stationMarker,
        infoWindow: const InfoWindow(title: 'الوجهة'),
      ),
    );

    // Dynamic Route Drawing
    if (currentTrip.status == 'started') {
      // Trip Started: Draw Route from Pickup -> Destination
      context.read<GetRouteCubit>().getRoute(
        startLat: _safeParseDouble(currentTrip.originLat),
        startLng: _safeParseDouble(currentTrip.originLng),
        endLat: _safeParseDouble(currentTrip.distLat),
        endLng: _safeParseDouble(currentTrip.distLng),
        startLocation: 'Start',
        endLocation: 'End',
      );
    } else {
      // Driver Coming: Draw Route from Driver -> Pickup
      // We need driver location for this.
      if (driverPos != null) {
        context.read<GetRouteCubit>().getRoute(
          startLat: driverPos.latitude,
          startLng: driverPos.longitude,
          endLat: _safeParseDouble(currentTrip.originLat),
          endLng: _safeParseDouble(currentTrip.originLng),
          startLocation: 'Driver',
          endLocation: 'Pickup',
        );
      }
    }
  }

  double _safeParseDouble(String? value) {
    if (value == null || value.isEmpty) return 0.0;
    try {
      return double.parse(value);
    } catch (e) {
      return 0.0;
    }
  }

  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    var p = 0.017453292519943295;
    var c = cos;
    var a =
        0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // km
  }

  void _updateDriverMarker(LatLng position) {
    // Calculate distance based on current trip status
    double destLat;
    double destLng;

    if (currentTrip.status == 'started') {
      // If trip started, calculate distance to final destination
      destLat = _safeParseDouble(currentTrip.distLat);
      destLng = _safeParseDouble(currentTrip.distLng);
    } else {
      // Otherwise calculate distance to pickup point
      destLat = _safeParseDouble(currentTrip.originLat);
      destLng = _safeParseDouble(currentTrip.originLng);
    }

    double distanceInKm = 0.0;
    if (destLat != 0 && destLng != 0) {
      distanceInKm = _calculateDistance(
        position.latitude,
        position.longitude,
        destLat,
        destLng,
      );
    }

    // Estimate time (Assuming average speed of 40 km/h in city)
    double timeInHours = distanceInKm / 40;
    int timeInMinutes = (timeInHours * 60).round();

    if (mounted) {
      setState(() {
        driverLocation = position;

        if (distanceInKm < 1) {
          distanceText = '${(distanceInKm * 1000).toStringAsFixed(0)} م';
        } else {
          distanceText = '${distanceInKm.toStringAsFixed(1)} كم';
        }

        if (timeInMinutes < 1) {
          durationText = 'أقل من دقيقة';
        } else {
          durationText = '$timeInMinutes دقيقة';
        }

        markers.removeWhere((m) => m.markerId.value == 'driver');
        markers.add(
          Marker(
            markerId: const MarkerId('driver'),
            position: position,
            icon: MarkerUtils.carMarker,
            infoWindow: InfoWindow(
              title: 'الكابتن',
              snippet: '$distanceText - $durationText',
            ),
          ),
        );
      });

      mapController?.animateCamera(CameraUpdate.newLatLng(position));
    }
  }

  Future<void> _setMapStyle() async {
    if (mapController == null) return;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final stylePath = isDarkMode
        ? 'assets/map_styles/dark_map_style.json'
        : 'assets/map_styles/light_map_style.json';

    try {
      final style = await DefaultAssetBundle.of(context).loadString(stylePath);
      await mapController!.setMapStyle(style);
    } catch (e) {
      debugPrint('Error loading map style: $e');
    }
  }

  void _navigateToTripCompleted() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => TripCompletedScreen(
          trip: currentTrip,
          driverName: widget.driverName ?? 'الكابتن',
        ),
      ),
    );
  }

  void _openChat() {
    if (widget.trip.tripId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatScreen(
            tripId: widget.trip.tripId!,
            otherUserName: widget.driverName ?? 'الكابتن',
          ),
        ),
      );
    }
  }

  void _makePhoneCall(String phone) async {
    final Uri url = Uri.parse('tel:$phone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  String _getStatusText(PassengerTripStatus status) {
    switch (status) {
      case PassengerTripStatus.accepted:
        return 'الكابتن في الطريق إليك';
      case PassengerTripStatus.driverArrived:
        return 'الكابتن وصل!';
      case PassengerTripStatus.started:
        return 'الرحلة بدأت';
      case PassengerTripStatus.completed:
        return 'الرحلة انتهت';
      case PassengerTripStatus.cancelled:
        return 'تم إلغاء الرحلة';
      default:
        return 'جاري التتبع...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Trip status and cancellation listener
          MultiBlocListener(
            listeners: [
              BlocListener<
                PassengerTripMonitorCubit,
                PassengerTripMonitorState
              >(
                listenWhen: (previous, current) =>
                    previous.status != current.status,
                listener: (context, state) {
                  if (state.trip != null) {
                    setState(() {
                      currentTrip = state.trip!;
                    });
                  }

                  if (state.status == PassengerTripStatus.completed) {
                    _navigateToTripCompleted();
                  } else if (state.status == PassengerTripStatus.cancelled) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم إلغاء الرحلة')),
                    );
                    context.go('/passenger-home');
                  } else if (state.status ==
                      PassengerTripStatus.driverArrived) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('الكابتن وصل!')),
                    );
                  } else if (state.status == PassengerTripStatus.started) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('الرحلة بدأت!')),
                    );
                    // Refresh route to show Pickup -> Destination
                    _initMarkers();
                  }
                },
              ),
              BlocListener<CancelTripCubit, CancelTripState>(
                listener: (context, state) {
                  if (state is CancelTripSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم إلغاء الرحلة')),
                    );
                    context.go('/passenger-home');
                  } else if (state is CancelTripFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errorMessage)),
                    );
                  }
                },
              ),
            ],
            child: BlocListener<GetRouteCubit, GetRouteState>(
              listener: (context, state) {
                if (state is GetRouteSuccess) {
                  if (state.route.routes != null &&
                      state.route.routes!.isNotEmpty) {
                    final geometry = state.route.routes![0].geometry;
                    if (geometry != null) {
                      final points = decodePolyline(geometry);
                      context.read<DrawPolylineCubit>().drawRoute(points);
                    }
                  }
                  // Stop loading once route is fetched
                  setState(() {
                    _isMapLoading = false;
                  });
                } else if (state is GetRouteFailure) {
                  // Stop loading if route fetch fails
                  setState(() {
                    _isMapLoading = false;
                  });
                }
              },
              child: BlocBuilder<DrawPolylineCubit, DrawPolylineState>(
                builder: (context, polyState) {
                  return BlocListener<TrackDriverCubit, TrackDriverState>(
                    listener: (context, state) {
                      if (state is TrackDriverUpdate) {
                        // Check if this is the first update BEFORE updating the state
                        final isFirstUpdate = driverLocation == null;

                        _updateDriverMarker(state.driverLocation);

                        // If this is the first update, initialize markers/route
                        if (isFirstUpdate) {
                          _initMarkers(driverPos: state.driverLocation);
                        }

                        if (_isMapLoading) {
                          setState(() {
                            _isMapLoading = false;
                          });
                        }
                      }
                    },
                    child: Stack(
                      children: [
                        GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                              _safeParseDouble(widget.trip.originLat),
                              _safeParseDouble(widget.trip.originLng),
                            ),
                            zoom: 14,
                          ),
                          onMapCreated: (controller) {
                            mapController = controller;
                            _setMapStyle();

                            // Fallback: stop loading after 5 seconds no matter what
                            Future.delayed(const Duration(seconds: 5), () {
                              if (mounted && _isMapLoading) {
                                setState(() {
                                  _isMapLoading = false;
                                });
                              }
                            });
                          },
                          markers: {...markers, ...polyState.markers},
                          polylines: polyState.polylines,
                          myLocationEnabled: true,
                          zoomControlsEnabled: false,
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
                },
              ),
            ),
          ),

          // Back Button
          Positioned(
            top: 40.h,
            right: 20.w,
            child: CircleAvatar(
              backgroundColor: Theme.of(context).cardColor,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_forward,
                  color: Theme.of(context).iconTheme.color,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // Chat and Call Buttons
          Positioned(
            top: 40.h,
            left: 20.w,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).cardColor,
                  child: IconButton(
                    icon: Icon(Icons.chat, color: AppColors.primary),
                    onPressed: _openChat,
                  ),
                ),
                SizedBox(width: 8.w),
                // Call button in the top right area
                BlocBuilder<GetDriverDataCubit, GetDriverDataState>(
                  builder: (context, driverState) {
                    final phone =
                        widget.driverPhone ??
                        (driverState is GetDriverDataSuccess
                            ? driverState.driverModel.phone
                            : null);
                    if (phone == null) return const SizedBox.shrink();

                    return CircleAvatar(
                      backgroundColor: Theme.of(context).cardColor,
                      child: IconButton(
                        icon: const Icon(Icons.phone, color: Colors.green),
                        onPressed: () => _makePhoneCall(phone),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Driver Status Card
          Positioned(
            bottom: 20.h,
            left: 20.w,
            right: 20.w,
            child: BlocBuilder<PassengerTripMonitorCubit, PassengerTripMonitorState>(
              builder: (context, tripState) {
                return Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              color: _getStatusColor(
                                tripState.status,
                              ).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _getStatusIcon(tripState.status),
                              color: _getStatusColor(tripState.status),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _getStatusText(tripState.status),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                if (driverLocation != null)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'يبعد عنك: ${distanceText ?? "..."}',
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.color,
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        'الوقت المقدر: ${durationText ?? "..."}',
                                        style: TextStyle(
                                          color: Theme.of(context).hintColor,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ],
                                  )
                                else
                                  Text(
                                    'جاري تحديد الموقع...',
                                    style: TextStyle(
                                      color: Theme.of(context).hintColor,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      BlocBuilder<GetDriverDataCubit, GetDriverDataState>(
                        builder: (context, driverState) {
                          final name =
                              widget.driverName ??
                              (driverState is GetDriverDataSuccess
                                  ? driverState.driverModel.name
                                  : null);
                          final phone =
                              widget.driverPhone ??
                              (driverState is GetDriverDataSuccess
                                  ? driverState.driverModel.phone
                                  : null);

                          if (name == null) return const SizedBox.shrink();

                          return Column(
                            children: [
                              SizedBox(height: 12.h),
                              Divider(
                                height: 1,
                                color: Theme.of(context).dividerColor,
                              ),
                              SizedBox(height: 12.h),
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20.r,
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.surfaceContainerHighest,
                                    child: Icon(
                                      Icons.person,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Text(
                                      name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                  // Quick action buttons
                                  IconButton(
                                    onPressed: _openChat,
                                    icon: Icon(
                                      Icons.message,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  if (phone != null)
                                    IconButton(
                                      onPressed: () => _makePhoneCall(phone),
                                      icon: const Icon(
                                        Icons.phone,
                                        color: Colors.green,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                      // Cancel Trip button for passenger (always visible until started)
                      if (tripState.status != PassengerTripStatus.started &&
                          tripState.status !=
                              PassengerTripStatus.completed) ...[
                        SizedBox(height: 12.h),
                        Divider(
                          height: 1,
                          color: Theme.of(context).dividerColor,
                        ),
                        SizedBox(height: 8.h),
                        BlocBuilder<CancelTripCubit, CancelTripState>(
                          builder: (context, cancelState) {
                            if (cancelState is CancelTripLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (dialogContext) => AlertDialog(
                                    title: const Text('إلغاء الرحلة'),
                                    content: const Text(
                                      'هل أنت متأكد من إلغاء الرحلة؟',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(dialogContext),
                                        child: const Text('لا'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(dialogContext);
                                          if (currentTrip.tripId != null) {
                                            context
                                                .read<CancelTripCubit>()
                                                .cancelTrip(
                                                  tripId: currentTrip.tripId!,
                                                );
                                          }
                                        },
                                        child: const Text(
                                          'نعم، إلغاء',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Text(
                                'إلغاء الرحلة',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(PassengerTripStatus status) {
    switch (status) {
      case PassengerTripStatus.accepted:
        return AppColors.primary;
      case PassengerTripStatus.driverArrived:
        return Colors.orange;
      case PassengerTripStatus.started:
        return Colors.blue;
      case PassengerTripStatus.completed:
        return Colors.green;
      case PassengerTripStatus.cancelled:
        return Colors.red;
      default:
        return AppColors.primary;
    }
  }

  IconData _getStatusIcon(PassengerTripStatus status) {
    switch (status) {
      case PassengerTripStatus.accepted:
        return Icons.directions_car;
      case PassengerTripStatus.driverArrived:
        return Icons.location_on;
      case PassengerTripStatus.started:
        return Icons.navigation;
      case PassengerTripStatus.completed:
        return Icons.check_circle;
      case PassengerTripStatus.cancelled:
        return Icons.cancel;
      default:
        return Icons.directions_car;
    }
  }
}
