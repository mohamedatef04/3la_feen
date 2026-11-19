import 'dart:async';

import 'package:ala_feen/core/utils/notifications/local.dart';
import 'package:ala_feen/core/utils/safe_emit.dart';
import 'package:ala_feen/features/home/passenger/data/models/trip_model.dart';
import 'package:ala_feen/features/home/passenger/data/repos/passenger_trip_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';

part 'passenger_trip_monitor_state.dart';

/// Signature of the local notification shown when the trip status changes.
typedef TripStatusNotifier =
    void Function({
      required String title,
      required String body,
      required String payload,
    });

/// Follows the passenger's current trip status. Realtime updates are the
/// main source; a short poll covers dropped realtime connections.
class PassengerTripMonitorCubit extends Cubit<PassengerTripMonitorState> {
  PassengerTripMonitorCubit(
    this._repo, {
    TripStatusNotifier? notify,
    this.pollInterval = const Duration(seconds: 3),
  }) : _notify = notify ?? _showLocalNotification,
       super(
         const PassengerTripMonitorState(status: PassengerTripStatus.initial),
       );

  final PassengerTripRepo _repo;
  final TripStatusNotifier _notify;
  final Duration pollInterval;

  StreamSubscription<TripModel>? _subscription;
  Timer? _pollTimer;
  String? _currentTripId;
  PassengerTripStatus? _lastStatus;

  void monitorTrip(String tripId) {
    safeEmit(state.copyWith(status: PassengerTripStatus.loading));
    _currentTripId = tripId;
    _stopMonitoring();

    _fetchTripStatus(tripId);
    _subscription = _repo
        .watchTrip(tripId)
        .listen(_updateTripStatus, onError: (_) {});
    _pollTimer = Timer.periodic(pollInterval, (_) => _fetchTripStatus(tripId));
  }

  /// Resumes monitoring if the passenger already has a trip in progress,
  /// for example after the app was restarted.
  Future<void> monitorActiveTrip(String passengerId) async {
    final result = await _repo.fetchLatestActiveTrip(passengerId);
    result.fold((_) {}, (trip) {
      final tripId = trip?.tripId;
      if (tripId != null) {
        monitorTrip(tripId);
      } else {
        safeEmit(
          const PassengerTripMonitorState(status: PassengerTripStatus.initial),
        );
      }
    });
  }

  Future<void> _fetchTripStatus(String tripId) async {
    final result = await _repo.fetchTrip(tripId);
    // A failed fetch is retried by the next poll, so it is not surfaced.
    result.fold((_) {}, (trip) {
      if (trip != null) _updateTripStatus(trip);
    });
  }

  void _updateTripStatus(TripModel trip) {
    final newStatus = statusFromString(trip.status);

    if (_lastStatus != null && _lastStatus != newStatus) {
      _showStatusNotification(newStatus);
    }
    _lastStatus = newStatus;

    safeEmit(
      state.copyWith(status: newStatus, trip: trip, timestamp: DateTime.now()),
    );
  }

  static PassengerTripStatus statusFromString(String? status) {
    switch (status) {
      case 'driver_arrived':
        return PassengerTripStatus.driverArrived;
      case 'started':
        return PassengerTripStatus.started;
      case 'completed':
        return PassengerTripStatus.completed;
      case 'cancelled':
        return PassengerTripStatus.cancelled;
      case 'accepted':
      default:
        return PassengerTripStatus.accepted;
    }
  }

  void _showStatusNotification(PassengerTripStatus status) {
    final String title;
    final String body;

    switch (status) {
      case PassengerTripStatus.driverArrived:
        title = 'trip_status.driver_arrived_title'.tr();
        body = 'trip_status.driver_arrived_body'.tr();
      case PassengerTripStatus.started:
        title = 'trip_status.started_title'.tr();
        body = 'trip_status.started_body'.tr();
      case PassengerTripStatus.completed:
        title = 'trip_status.completed_title'.tr();
        body = 'trip_status.completed_body'.tr();
      case PassengerTripStatus.cancelled:
        title = 'trip_status.cancelled_title'.tr();
        body = 'trip_status.cancelled_body'.tr();
      default:
        return;
    }

    _notify(title: title, body: body, payload: 'trip_$_currentTripId');
  }

  static void _showLocalNotification({
    required String title,
    required String body,
    required String payload,
  }) {
    // A failed notification must never break trip monitoring.
    unawaited(
      LocalNotifications()
          .showNotification(title: title, body: body, payload: payload)
          .catchError((Object _) {}),
    );
  }

  void _stopMonitoring() {
    _subscription?.cancel();
    _pollTimer?.cancel();
  }

  @override
  Future<void> close() {
    _stopMonitoring();
    return super.close();
  }
}
