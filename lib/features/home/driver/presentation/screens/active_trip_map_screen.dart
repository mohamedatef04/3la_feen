import 'package:ala_feen/core/utils/map_style.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:async';
import 'dart:math';
import 'package:ala_feen/core/utils/decode_polykine.dart';
import 'package:ala_feen/core/utils/marker_utils.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/active_trip/active_trip_monitor_cubit.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/active_trip/active_trip_state.dart';
import 'package:ala_feen/features/home/driver/presentation/widgets/active_trip_banner.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/get_passenger_data/get_passenger_details_cubit.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/get_passenger_data/get_passenger_details_state.dart';
import 'package:ala_feen/features/home/driver/presentation/screens/driver_trip_completed_screen.dart';
import 'package:ala_feen/features/home/passenger/data/models/trip_model.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/draw_polyline_cubit/draw_polyline_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/get_route_cubit/get_route_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/track_my_location_cubit/track_my_location_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:ala_feen/core/di/injection_container.dart';
import 'package:ala_feen/features/home/driver/data/services/driver_tracking_service.dart';

class ActiveTripMapScreen extends StatefulWidget {
  static const String routeName = '/active-trip-map';
  final TripModel trip;

  const ActiveTripMapScreen({super.key, required this.trip});

  @override
  State<ActiveTripMapScreen> createState() => _ActiveTripMapScreenState();
}

class _ActiveTripMapScreenState extends State<ActiveTripMapScreen> {
  GoogleMapController? mapController;
  String? _mapStyle;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  bool isFirstLocationUpdate = true;
  bool _showStartTripDialog = false;
  double? _remainingDistance;
  late TripModel currentTrip;
  bool _isMapLoading = true;

  // Simulation variables
  Timer? _simulationTimer;
  List<LatLng> _currentRoutePoints = [];
  int _simulationIndex = 0;
  bool _isSimulating = false;
  bool _autoResumeSimulation = false;
  DateTime? _lastCameraUpdate;

  @override
  void initState() {
    super.initState();
    currentTrip = widget.trip;
    _initMarkers();
  }

  void _initMarkers() {
    markers.clear();
    // Passenger pickup location (person marker)
    try {
      final pickupLat = _safeParseDouble(currentTrip.originLat);
      final pickupLng = _safeParseDouble(currentTrip.originLng);

      if (pickupLat != 0 && pickupLng != 0) {
        markers.add(
          Marker(
            markerId: const MarkerId('pickup'),
            position: LatLng(pickupLat, pickupLng),
            icon: MarkerUtils.personMarker,
            infoWindow: InfoWindow(title: 'map.passenger_location'.tr()),
          ),
        );
      }

      // Destination (station marker)
      final destLat = _safeParseDouble(currentTrip.distLat);
      final destLng = _safeParseDouble(currentTrip.distLng);

      if (destLat != 0 && destLng != 0) {
        markers.add(
          Marker(
            markerId: const MarkerId('destination'),
            position: LatLng(destLat, destLng),
            icon: MarkerUtils.stationMarker,
            infoWindow: InfoWindow(title: 'trip.destination'.tr()),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error initializing markers: $e');
    }
  }

  double _safeParseDouble(String? value) {
    if (value == null || value.isEmpty) return 0.0;
    try {
      return double.parse(value);
    } catch (e) {
      debugPrint('Error parsing double: $value');
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
    return 12742 * asin(sqrt(a)) * 1000; // meters
  }

  void _handleLocationUpdate(LatLng driverPos) {
    if (!mounted) return;

    setState(() {
      markers.removeWhere((m) => m.markerId.value == 'driver_location');
      markers.add(
        Marker(
          markerId: const MarkerId('driver_location'),
          position: driverPos,
          icon: MarkerUtils.carMarker,
          infoWindow: InfoWindow(title: 'map.my_location'.tr()),
        ),
      );
    });

    // Share the position with the passenger (throttled inside the service).
    sl<DriverTrackingService>().updateMyLocation(
      lat: driverPos.latitude,
      lng: driverPos.longitude,
    );

    // Always track driver position with camera if it's the first time
    if (isFirstLocationUpdate) {
      mapController?.animateCamera(CameraUpdate.newLatLngZoom(driverPos, 17));
      isFirstLocationUpdate = false;
      _fetchInitialRoute(driverPos);
    } else {
      // Throttled camera update (every 500ms or significant distance)
      final now = DateTime.now();
      if (_lastCameraUpdate == null ||
          now.difference(_lastCameraUpdate!).inMilliseconds > 500) {
        mapController?.animateCamera(CameraUpdate.newLatLng(driverPos));
        _lastCameraUpdate = now;
      }
    }

    // Proximity detection for starting trip (Stage 1) or finishing trip (Stage 2)
    debugPrint(
      '[ActiveTrip] Proximity check: _showStartTripDialog=$_showStartTripDialog, status=${currentTrip.status}',
    );

    if (!_showStartTripDialog) {
      // Check for pre-arrival statuses (driver on the way to pickup)
      final isPreArrival =
          currentTrip.status == 'accepted' ||
          currentTrip.status == 'searching' ||
          currentTrip.status == 'pending';
      if (isPreArrival) {
        final pickupLat = double.parse(currentTrip.originLat ?? '0');
        final pickupLng = double.parse(currentTrip.originLng ?? '0');
        final distance = _calculateDistance(
          driverPos.latitude,
          driverPos.longitude,
          pickupLat,
          pickupLng,
        );

        debugPrint(
          '[ActiveTrip] Driver at (${driverPos.latitude}, ${driverPos.longitude})',
        );
        debugPrint('[ActiveTrip] Pickup at ($pickupLat, $pickupLng)');
        debugPrint(
          '[ActiveTrip] Distance to pickup: ${distance.toStringAsFixed(1)}m',
        );

        if (distance < 100) {
          debugPrint(
            '[ActiveTrip] ✅ Within 100m! Updating status to driver_arrived',
          );
          if (_isSimulating) {
            _autoResumeSimulation = true;
          }
          _stopSimulation();
          setState(() {
            _showStartTripDialog = true;
          });
          // Update trip status to driver_arrived for passenger notification
          context.read<ActiveTripMonitorCubit>().updateTripStatus(
            currentTrip.tripId!,
            'driver_arrived',
          );
        }
      } else if (currentTrip.status == 'started') {
        final destLat = double.parse(currentTrip.distLat ?? '0');
        final destLng = double.parse(currentTrip.distLng ?? '0');
        final distance = _calculateDistance(
          driverPos.latitude,
          driverPos.longitude,
          destLat,
          destLng,
        );

        if (distance < 100) {
          _stopSimulation();
          _showArrivalConfirmation();
        }
      }
    }
  }

  void _fetchInitialRoute(LatLng driverPos) {
    bool isStarted = currentTrip.status == 'started';

    // If started, start from Pickup (Origin). Otherwise, start from Driver's current position.
    final startLat = isStarted
        ? double.parse(currentTrip.originLat ?? '0')
        : driverPos.latitude;
    final startLng = isStarted
        ? double.parse(currentTrip.originLng ?? '0')
        : driverPos.longitude;

    final targetLat = double.parse(
      isStarted ? (currentTrip.distLat ?? '0') : (currentTrip.originLat ?? '0'),
    );
    final targetLng = double.parse(
      isStarted ? (currentTrip.distLng ?? '0') : (currentTrip.originLng ?? '0'),
    );

    context.read<GetRouteCubit>().getRoute(
      startLat: startLat,
      startLng: startLng,
      endLat: targetLat,
      endLng: targetLng,
      startLocation: isStarted ? 'map.passenger'.tr() : 'map.my_location'.tr(),
      endLocation: isStarted ? 'trip.destination'.tr() : 'map.passenger'.tr(),
    );
  }

  void showStartTripConfirmation() {
    final monitorCubit = context.read<ActiveTripMonitorCubit>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Text('driver.arrived_at_passenger'.tr()),
        content: Text('driver.start_trip_now'.tr()),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _showStartTripDialog = false;
              });
              Navigator.pop(dialogContext);
            },
            child: Text('common.not_yet'.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              monitorCubit.updateTripStatus(
                currentTrip.tripId!,
                'started',
              );
              Navigator.pop(dialogContext);
            },
            child: Text('trip.start'.tr()),
          ),
        ],
      ),
    );
  }

  void _showArrivalConfirmation() {
    final monitorCubit = context.read<ActiveTripMonitorCubit>();
    String passengerName = 'map.passenger'.tr(); // Fallback

    // Try to get name from any existing GetPassengerDetailsCubit state in context if available
    // or we'll just use a generic one if we don't want to block
    final passengerState = context.read<GetPassengerDetailsCubit>().state;
    if (passengerState is GetPassengerDetailsSuccess) {
      passengerName =
          passengerState.passengerModel.name ?? 'map.passenger'.tr();
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Text('driver.arrived_at_destination'.tr()),
        content: Text('driver.end_trip_now'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('common.not_yet'.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              monitorCubit.updateTripStatus(
                currentTrip.tripId!,
                'completed',
              );
              Navigator.pop(dialogContext);
              // Navigate to Trip Completed Screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => DriverTripCompletedScreen(
                    trip: currentTrip,
                    passengerName: passengerName,
                  ),
                ),
              );
            },
            child: Text('trip.end'.tr()),
          ),
        ],
      ),
    );
  }

  bool _pendingSimulationStart = false;

  void _startSimulation() {
    // 1. Get current driver location (from markers or cubit)
    // We prefer the actual marker location if available (visual consistency)
    LatLng? currentDriverPos;
    final driverMarker = markers
        .where((m) => m.markerId.value == 'driver_location')
        .firstOrNull;
    if (driverMarker != null) {
      currentDriverPos = driverMarker.position;
    }

    if (currentDriverPos != null) {
      // 2. Fetch new route from HERE to target
      _pendingSimulationStart = true;
      _fetchInitialRoute(currentDriverPos);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('driver.updating_route_simulation'.tr())),
      );
    } else {
      // Fallback if no driver location found (likely first load)
      if (_currentRoutePoints.isNotEmpty) {
        setState(() {
          _isSimulating = true;
          _simulationIndex = 0;
        });
        _runSimulationLoop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('driver.waiting_for_location'.tr())),
        );
      }
    }
  }

  void _runSimulationLoop() {
    // Semantic Speed: Update every 1 second (1000ms) for realistic movement
    // and to match throttled updates better
    const stepSize =
        1; // Move 1 point at a time for smoother, slower simulation

    _simulationTimer?.cancel();
    _simulationTimer = Timer.periodic(const Duration(milliseconds: 1000), (
      timer,
    ) {
      if (_simulationIndex >= _currentRoutePoints.length) {
        timer.cancel();
        setState(() => _isSimulating = false);
        return;
      }

      _handleLocationUpdate(_currentRoutePoints[_simulationIndex]);

      _simulationIndex += stepSize;

      // Ensure we hit the last point
      if (_simulationIndex >= _currentRoutePoints.length &&
          _simulationIndex - stepSize < _currentRoutePoints.length - 1) {
        _simulationIndex = _currentRoutePoints.length - 1;
      }
    });
  }

  void _stopSimulation() {
    _simulationTimer?.cancel();
    setState(() {
      _isSimulating = false;
      _autoResumeSimulation = false;
      _pendingSimulationStart = false; // Cancel pending start
    });
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    super.dispose();
  }

  Future<void> _setMapStyle() async {
    final style = await MapStyle.load(Theme.of(context).brightness);
    if (mounted) setState(() => _mapStyle = style);
  }

  void _recenterMap() {
    if (mapController == null) return;

    LatLng? target;
    if (currentTrip.status == 'started') {
      // If started, focus on destination
      if (currentTrip.distLat != null && currentTrip.distLng != null) {
        target = LatLng(
          double.tryParse(currentTrip.distLat!) ?? 0,
          double.tryParse(currentTrip.distLng!) ?? 0,
        );
      }
    } else {
      // If not started (accepted), focus on pickup
      if (currentTrip.originLat != null && currentTrip.originLng != null) {
        target = LatLng(
          double.tryParse(currentTrip.originLat!) ?? 0,
          double.tryParse(currentTrip.originLng!) ?? 0,
        );
      }
    }

    if (target != null && target.latitude != 0 && target.longitude != 0) {
      // Calculate bounds to include driver and target
      context.read<TrackMyLocationCubit>().getCurrentLocation((location) {
        if (location.latitude != null && location.longitude != null) {
          LatLng driverPos = LatLng(location.latitude!, location.longitude!);
          LatLngBounds bounds = _getBounds([driverPos, target!]);
          mapController?.animateCamera(
            CameraUpdate.newLatLngBounds(bounds, 50),
          );
        } else {
          mapController?.animateCamera(CameraUpdate.newLatLngZoom(target!, 15));
        }
      });
    }
  }

  LatLngBounds _getBounds(List<LatLng> positions) {
    double minLat = 90.0;
    double minLng = 180.0;
    double maxLat = -90.0;
    double maxLng = -180.0;

    for (final pos in positions) {
      minLat = min(minLat, pos.latitude);
      minLng = min(minLng, pos.longitude);
      maxLat = max(maxLat, pos.latitude);
      maxLng = max(maxLng, pos.longitude);
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ActiveTripMonitorCubit, ActiveTripState>(
      listener: (context, state) {
        if (state.status == ActiveTripStatus.cancelled) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('trip.cancelled'.tr())),
          );
          // Navigate back to Driver Home and clear stack to prevent going back to map
          context.go('/driver-home');
        } else if (state.status == ActiveTripStatus.active &&
            state.activeTrip != null) {
          final oldStatus = currentTrip.status;
          setState(() {
            currentTrip = state.activeTrip!;
          });

          // If trip just started, or status changed, re-draw route and clear old polylines
          if (oldStatus != currentTrip.status) {
            _stopSimulation(); // Stop current simulation on status change
            context.read<DrawPolylineCubit>().clearRoute();
            _initMarkers();
            context.read<TrackMyLocationCubit>().getCurrentLocation((data) {
              if (data.latitude != null && data.longitude != null) {
                _fetchInitialRoute(LatLng(data.latitude!, data.longitude!));
              }
            });
          }
        }
      },
      child: BlocListener<GetRouteCubit, GetRouteState>(
        listener: (context, routeState) {
          if (routeState is GetRouteSuccess) {
            final firstRoute = routeState.route.routes?[0];
            final geometry = firstRoute?.geometry;
            if (geometry != null) {
              final decodedPoints = decodePolyline(geometry);
              context.read<DrawPolylineCubit>().drawRoute(decodedPoints);
              setState(() {
                _remainingDistance = firstRoute?.distance; // in meters
                _currentRoutePoints = decodedPoints; // Store for simulation
              });

              // Auto-resume simulation if it was active before Stage 2 OR we requested a start
              if ((_autoResumeSimulation && currentTrip.status == 'started') ||
                  _pendingSimulationStart) {
                _autoResumeSimulation = false;
                _pendingSimulationStart = false;
                Future.delayed(const Duration(seconds: 1), () {
                  if (mounted) {
                    setState(() {
                      _isSimulating = true;
                      _simulationIndex = 0;
                    });
                    _runSimulationLoop();
                  }
                });
              }

              // Proximity detection using actual road distance from cubit (optional redundancy)
              if (currentTrip.status == 'accepted' &&
                  !_showStartTripDialog &&
                  _remainingDistance != null &&
                  _remainingDistance! < 100) {
                // ... handled in _handleLocationUpdate now for better simulation performance
              }
            }
          }
        },
        child: BlocBuilder<DrawPolylineCubit, DrawPolylineState>(
          builder: (context, polyState) {
            return Scaffold(
              body: Stack(
                children: [
                  Stack(
                    children: [
                      GoogleMap(
                        style: _mapStyle,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            _safeParseDouble(currentTrip.originLat),
                            _safeParseDouble(currentTrip.originLng),
                          ),
                          zoom: 14,
                        ),
                        onMapCreated: (controller) {
                          mapController = controller;
                          _setMapStyle();
                          context.read<TrackMyLocationCubit>().getCurrentLocation((
                            locationData,
                          ) {
                            if (locationData.latitude != null &&
                                locationData.longitude != null) {
                              _handleLocationUpdate(
                                LatLng(
                                  locationData.latitude!,
                                  locationData.longitude!,
                                ),
                              );

                              // Once we have location and map is ready, stop loading
                              setState(() {
                                _isMapLoading = false;
                              });
                            } else {
                              // Fallback: if we got a callback but no lat/lng, still stop skeleton
                              setState(() {
                                _isMapLoading = false;
                              });
                            }
                          });
                        },
                        markers: {...markers, ...polyState.markers},
                        polylines: polyState.polylines,
                        myLocationEnabled: !_isSimulating,
                        myLocationButtonEnabled: false,
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
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: ActiveTripBanner(
                      trip: currentTrip,
                      remainingDistance: _remainingDistance,
                      showStartTripButton:
                          _showStartTripDialog ||
                          currentTrip.status == 'driver_arrived',
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 20,
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).cardColor,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        onPressed: () => context.pop(),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 100,
                    right: 20,
                    child: Column(
                      children: [
                        FloatingActionButton(
                          heroTag: 'navigate_btn',
                          onPressed: _recenterMap,
                          backgroundColor: Theme.of(context).cardColor,
                          child: Icon(
                            Icons.center_focus_strong,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        ElevatedButton.icon(
                          onPressed: _isSimulating
                              ? _stopSimulation
                              : _startSimulation,
                          icon: Icon(
                            _isSimulating ? Icons.stop : Icons.play_arrow,
                          ),
                          label: Text(
                            _isSimulating
                                ? 'driver.stop_simulation'.tr()
                                : 'driver.start_simulation'.tr(),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isSimulating
                                ? Colors.red
                                : Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (context.watch<GetRouteCubit>().state is GetRouteLoading)
                    const Center(child: CircularProgressIndicator()),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
