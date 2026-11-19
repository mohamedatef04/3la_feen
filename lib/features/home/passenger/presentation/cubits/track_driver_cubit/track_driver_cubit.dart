import 'dart:async';

import 'package:ala_feen/core/utils/safe_emit.dart';
import 'package:ala_feen/features/home/passenger/data/repos/passenger_trip_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'track_driver_state.dart';

/// Follows the assigned driver's live location. Realtime updates are the
/// main source; a short poll covers dropped realtime connections.
class TrackDriverCubit extends Cubit<TrackDriverState> {
  TrackDriverCubit(this._repo, {this.pollInterval = const Duration(seconds: 2)})
    : super(TrackDriverInitial());

  final PassengerTripRepo _repo;
  final Duration pollInterval;

  StreamSubscription<LatLng>? _subscription;
  Timer? _pollTimer;
  String? currentDriverId;

  void trackDriver(String driverId) {
    safeEmit(TrackDriverLoading());
    currentDriverId = driverId;
    _stopTracking();

    _fetchDriverLocation(driverId);
    _subscription = _repo
        .watchDriverLocation(driverId)
        .listen(_emitLocation, onError: (_) {});
    _pollTimer = Timer.periodic(
      pollInterval,
      (_) => _fetchDriverLocation(driverId),
    );
  }

  Future<void> _fetchDriverLocation(String driverId) async {
    final result = await _repo.fetchDriverLocation(driverId);
    // A failed fetch is retried by the next poll, so it is not surfaced.
    result.fold((_) {}, (location) {
      if (location != null) _emitLocation(location);
    });
  }

  void _emitLocation(LatLng location) {
    safeEmit(
      TrackDriverUpdate(driverLocation: location, timestamp: DateTime.now()),
    );
  }

  void _stopTracking() {
    _subscription?.cancel();
    _pollTimer?.cancel();
  }

  @override
  Future<void> close() {
    _stopTracking();
    return super.close();
  }
}
