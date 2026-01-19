import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:ala_feen/core/utils/decode_polykine.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/active_trip/active_trip_monitor_cubit.dart';
import 'package:ala_feen/features/home/driver/presentation/cubit/active_trip/active_trip_state.dart';
import 'package:ala_feen/features/home/driver/presentation/widgets/active_trip_banner.dart';
import 'package:ala_feen/features/home/passenger/data/models/trip_model.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/draw_polyline_cubit/draw_polyline_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/get_route_cubit/get_route_cubit.dart';
import 'package:ala_feen/features/home/passenger/presentation/cubits/track_my_location_cubit/track_my_location_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ActiveTripMapScreen extends StatefulWidget {
  static const String routeName = '/active-trip-map';
  final TripModel trip;

  const ActiveTripMapScreen({super.key, required this.trip});

  @override
  State<ActiveTripMapScreen> createState() => _ActiveTripMapScreenState();
}

class _ActiveTripMapScreenState extends State<ActiveTripMapScreen> {
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  bool isFirstLocationUpdate = true;
  bool _showStartTripDialog = false;
  double? _remainingDistance;
  late TripModel currentTrip;

  // Simulation variables
  Timer? _simulationTimer;
  List<LatLng> _currentRoutePoints = [];
  int _simulationIndex = 0;
  bool _isSimulating = false;
  bool _autoResumeSimulation = false;
  BitmapDescriptor? _carIcon;
  DateTime? _lastCameraUpdate;

  @override
  void initState() {
    super.initState();
    currentTrip = widget.trip;
    _initMarkers();
    _loadCustomMarker();
  }

  Future<void> _loadCustomMarker() async {
    _carIcon = await _getEmojiMarker('🚘');
  }

  Future<BitmapDescriptor> _getEmojiMarker(String emoji) async {
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    textPainter.text = TextSpan(
      text: emoji,
      style: TextStyle(fontSize: 50.sp),
    );
    textPainter.layout();

    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    textPainter.paint(canvas, Offset.zero);

    final ui.Picture picture = recorder.endRecording();
    final ui.Image img = await picture.toImage(
      textPainter.width.toInt(),
      textPainter.height.toInt(),
    );
    final ByteData? byteData = await img.toByteData(
      format: ui.ImageByteFormat.png,
    );

    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }

  void _initMarkers() {
    markers.clear();
    markers.add(
      Marker(
        markerId: const MarkerId('pickup'),
        position: LatLng(
          double.parse(currentTrip.originLat ?? '0'),
          double.parse(currentTrip.originLng ?? '0'),
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(title: 'نقطة الانطلاق'),
      ),
    );
    markers.add(
      Marker(
        markerId: const MarkerId('destination'),
        position: LatLng(
          double.parse(currentTrip.distLat ?? '0'),
          double.parse(currentTrip.distLng ?? '0'),
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: const InfoWindow(title: 'نقطة الوصول'),
      ),
    );
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
          icon: _isSimulating && _carIcon != null
              ? _carIcon!
              : BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueAzure,
                ),
          infoWindow: const InfoWindow(title: 'موقعي'),
        ),
      );
    });

    // Always track driver position with camera if it's the first time
    if (isFirstLocationUpdate) {
      mapController?.animateCamera(CameraUpdate.newLatLngZoom(driverPos, 17));
      isFirstLocationUpdate = false;
      _fetchInitialRoute(driverPos);
    } else {
      // Throttled camera update (every 1 second or significant distance)
      final now = DateTime.now();
      if (_lastCameraUpdate == null ||
          now.difference(_lastCameraUpdate!).inMilliseconds > 1000) {
        mapController?.animateCamera(CameraUpdate.newLatLng(driverPos));
        _lastCameraUpdate = now;
      }
    }

    // Proximity detection for starting trip (Stage 1) or finishing trip (Stage 2)
    if (!_showStartTripDialog) {
      if (currentTrip.status == 'accepted') {
        final pickupLat = double.parse(currentTrip.originLat ?? '0');
        final pickupLng = double.parse(currentTrip.originLng ?? '0');
        final distance = _calculateDistance(
          driverPos.latitude,
          driverPos.longitude,
          pickupLat,
          pickupLng,
        );

        if (distance < 100) {
          if (_isSimulating) {
            _autoResumeSimulation = true;
          }
          _stopSimulation();
          setState(() {
            _showStartTripDialog = true;
          });
          _showStartTripConfirmation();
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
    final targetLat = double.parse(
      isStarted ? (currentTrip.distLat ?? '0') : (currentTrip.originLat ?? '0'),
    );
    final targetLng = double.parse(
      isStarted ? (currentTrip.distLng ?? '0') : (currentTrip.originLng ?? '0'),
    );

    context.read<GetRouteCubit>().getRoute(
      startLat: driverPos.latitude,
      startLng: driverPos.longitude,
      endLat: targetLat,
      endLng: targetLng,
      startLocation: 'موقعي',
      endLocation: isStarted ? 'الوجهة' : 'الراكب',
    );
  }

  void _showStartTripConfirmation() {
    final monitorCubit = context.read<ActiveTripMonitorCubit>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('وصلت للراكب؟'),
        content: const Text('هل تود بدء الرحلة الآن؟'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _showStartTripDialog = false;
              });
              Navigator.pop(dialogContext);
            },
            child: const Text('ليس بعد'),
          ),
          ElevatedButton(
            onPressed: () {
              monitorCubit.updateTripStatus(
                currentTrip.tripId!,
                'started',
              );
              Navigator.pop(dialogContext);
            },
            child: const Text('بدء الرحلة'),
          ),
        ],
      ),
    );
  }

  void _showArrivalConfirmation() {
    final monitorCubit = context.read<ActiveTripMonitorCubit>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('وصلت لوجهتك؟'),
        content: const Text('هل تود إنهاء الرحلة الآن؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('ليس بعد'),
          ),
          ElevatedButton(
            onPressed: () {
              monitorCubit.updateTripStatus(
                currentTrip.tripId!,
                'completed',
              );
              Navigator.pop(dialogContext);
              context.pop(); // Go back home
            },
            child: const Text('إنهاء الرحلة'),
          ),
        ],
      ),
    );
  }

  void _startSimulation() {
    if (_currentRoutePoints.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى انتظار تحميل المسار أولاً')),
      );
      return;
    }

    setState(() {
      _isSimulating = true;
      _simulationIndex = 0;
    });

    // Realistic Speed: Step 1 with 200ms interval
    final stepSize = 1;

    _simulationTimer?.cancel();
    _simulationTimer = Timer.periodic(const Duration(milliseconds: 200), (
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
    });
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    super.dispose();
  }

  Future<void> _setMapStyle() async {
    if (mapController == null) return;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final stylePath = isDarkMode
        ? 'assets/map_styles/dark_map_style.json'
        : 'assets/map_styles/light_map_style.json';

    try {
      final style = await rootBundle.loadString(stylePath);
      await mapController!.setMapStyle(style);
    } catch (e) {
      debugPrint('Error loading map style: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ActiveTripMonitorCubit, ActiveTripState>(
      listener: (context, state) {
        if (state.status == ActiveTripStatus.active &&
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

              // Auto-resume simulation if it was active before Stage 2
              if (_autoResumeSimulation && currentTrip.status == 'started') {
                _autoResumeSimulation = false;
                Future.delayed(const Duration(seconds: 1), () {
                  if (mounted) _startSimulation();
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
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        double.parse(currentTrip.originLat ?? '0'),
                        double.parse(currentTrip.originLng ?? '0'),
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
                        }
                      });
                    },
                    markers: {...markers, ...polyState.markers},
                    polylines: polyState.polylines,
                    myLocationEnabled: !_isSimulating,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: ActiveTripBanner(
                      trip: currentTrip,
                      remainingDistance: _remainingDistance,
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 20,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => context.pop(),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 40,
                    right: 20,
                    child: ElevatedButton.icon(
                      onPressed: _isSimulating
                          ? _stopSimulation
                          : _startSimulation,
                      icon: Icon(_isSimulating ? Icons.stop : Icons.play_arrow),
                      label: Text(
                        _isSimulating ? 'إيقاف المحاكاة' : 'بدء المحاكاة',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isSimulating
                            ? Colors.red
                            : Colors.green,
                        foregroundColor: Colors.white,
                      ),
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
