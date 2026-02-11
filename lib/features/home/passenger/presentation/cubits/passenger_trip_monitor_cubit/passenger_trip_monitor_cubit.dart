import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ala_feen/features/home/passenger/data/models/trip_model.dart';
import 'package:ala_feen/core/utils/notifcations.dart/local.dart';
import 'package:ala_feen/core/utils/safe_emit.dart';

part 'passenger_trip_monitor_state.dart';

class PassengerTripMonitorCubit extends Cubit<PassengerTripMonitorState> {
  final SupabaseClient _supabase = Supabase.instance.client;
  RealtimeChannel? _channel;
  Timer? _pollTimer;
  String? _currentTripId;
  PassengerTripStatus? _lastStatus;

  PassengerTripMonitorCubit()
    : super(
        const PassengerTripMonitorState(status: PassengerTripStatus.initial),
      );

  void monitorTrip(String tripId) {
    safeEmit(state.copyWith(status: PassengerTripStatus.loading));
    _currentTripId = tripId;

    // Initial fetch
    _fetchTripStatus(tripId);

    // Subscribe to realtime changes
    _subscribeToRealtimeChanges(tripId);

    // Also poll every 3 seconds as backup
    _startPolling(tripId);
  }

  Future<void> monitorActiveTrip(String passengerId) async {
    try {
      final data = await _supabase
          .from('trips')
          .select()
          .eq('passenger_id', passengerId)
          .or('status.eq.accepted,status.eq.driver_arrived,status.eq.started')
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (data != null) {
        final trip = TripModel.fromJson(data);
        if (trip.tripId != null) {
          monitorTrip(trip.tripId!);
        }
      } else {
        safeEmit(
          const PassengerTripMonitorState(status: PassengerTripStatus.initial),
        );
      }
    } catch (e) {
      // Ignore errors
    }
  }

  Future<void> _fetchTripStatus(String tripId) async {
    try {
      final data = await _supabase
          .from('trips')
          .select()
          .eq('id', tripId)
          .maybeSingle();

      if (data != null) {
        final trip = TripModel.fromJson(data);
        _updateTripStatus(trip);
      }
    } catch (e) {
      // Ignore fetch errors, will retry on next poll
    }
  }

  void _subscribeToRealtimeChanges(String tripId) {
    _channel?.unsubscribe();

    _channel = _supabase.channel('trip_status_$tripId');

    _channel!
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'trips',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: tripId,
          ),
          callback: (payload) {
            final record = payload.newRecord;
            if (record.isNotEmpty) {
              final trip = TripModel.fromJson(record);
              _updateTripStatus(trip);
            }
          },
        )
        .subscribe();
  }

  void _startPolling(String tripId) {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _fetchTripStatus(tripId);
    });
  }

  void _updateTripStatus(TripModel trip) {
    PassengerTripStatus newStatus;

    switch (trip.status) {
      case 'accepted':
        newStatus = PassengerTripStatus.accepted;
        break;
      case 'driver_arrived':
        newStatus = PassengerTripStatus.driverArrived;
        break;
      case 'started':
        newStatus = PassengerTripStatus.started;
        break;
      case 'completed':
        newStatus = PassengerTripStatus.completed;
        break;
      case 'cancelled':
        newStatus = PassengerTripStatus.cancelled;
        break;
      default:
        newStatus = PassengerTripStatus.accepted;
    }

    // Show notification only when status changes
    if (_lastStatus != null && _lastStatus != newStatus) {
      _showStatusNotification(newStatus);
    }
    _lastStatus = newStatus;

    safeEmit(
      state.copyWith(
        status: newStatus,
        trip: trip,
        timestamp: DateTime.now(),
      ),
    );
  }

  void _showStatusNotification(PassengerTripStatus status) {
    String title = '';
    String body = '';

    switch (status) {
      case PassengerTripStatus.driverArrived:
        title = 'Ø§Ù„ÙƒØ§Ø¨ØªÙ† ÙˆØµÙ„! ðŸš—';
        body = 'Ø§Ù„ÙƒØ§Ø¨ØªÙ† ÙˆØµÙ„ Ø¥Ù„Ù‰ Ù…ÙˆÙ‚Ø¹ÙƒØŒ Ø§ØªØ¬Ù‡ Ù„Ù„Ø³ÙŠØ§Ø±Ø© Ø§Ù„Ø¢Ù†';
        break;
      case PassengerTripStatus.started:
        title = 'Ø§Ù„Ø±Ø­Ù„Ø© Ø¨Ø¯Ø£Øª ðŸ›£ï¸';
        body = 'Ø§Ù„Ø±Ø­Ù„Ø© Ø§Ù„Ø¢Ù† ÙÙŠ Ø§Ù„Ø·Ø±ÙŠÙ‚ Ø¥Ù„Ù‰ ÙˆØ¬Ù‡ØªÙƒ';
        break;
      case PassengerTripStatus.completed:
        title = 'ÙˆØµÙ„Øª! ðŸŽ‰';
        body = 'ØªÙ… Ø¥Ù†Ù‡Ø§Ø¡ Ø§Ù„Ø±Ø­Ù„Ø© Ø¨Ù†Ø¬Ø§Ø­';
        break;
      case PassengerTripStatus.cancelled:
        title = 'ØªÙ… Ø¥Ù„ØºØ§Ø¡ Ø§Ù„Ø±Ø­Ù„Ø© âŒ';
        body = 'ØªÙ… Ø¥Ù„ØºØ§Ø¡ Ø§Ù„Ø±Ø­Ù„Ø©';
        break;
      default:
        return; // Don't show notification
    }

    try {
      LocalNotifications().showNotification(
        title: title,
        body: body,
        payload: 'trip_${_currentTripId}',
      );
    } catch (e) {
      // Ignore notification errors
    }
  }

  @override
  Future<void> close() {
    _channel?.unsubscribe();
    _pollTimer?.cancel();
    return super.close();
  }
}

