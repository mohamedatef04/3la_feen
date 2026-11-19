import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ala_feen/core/utils/safe_emit.dart';

part 'track_driver_state.dart';

class TrackDriverCubit extends Cubit<TrackDriverState> {
  final SupabaseClient _supabase = Supabase.instance.client;
  RealtimeChannel? _channel;
  Timer? _pollTimer;
  String? currentDriverId;

  TrackDriverCubit() : super(TrackDriverInitial());

  void trackDriver(String driverId) {
    safeEmit(TrackDriverLoading());
    currentDriverId = driverId;

    // Initial fetch
    _fetchDriverLocation(driverId);

    // Subscribe to realtime changes
    _subscribeToRealtimeChanges(driverId);

    // Also poll every 2 seconds as backup
    _startPolling(driverId);
  }

  Future<void> _fetchDriverLocation(String driverId) async {
    try {
      final data = await _supabase
          .from('driver_locations')
          .select()
          .eq('driver_id', driverId)
          .maybeSingle();

      if (data != null) {
        final lat = (data['lat'] as num?)?.toDouble();
        final lng = (data['lng'] as num?)?.toDouble();

        if (lat != null && lng != null) {
          safeEmit(
            TrackDriverUpdate(
              driverLocation: LatLng(lat, lng),
              timestamp: DateTime.now(),
            ),
          );
        }
      }
    } catch (e) {
      // Ignore fetch errors, will retry on next poll
    }
  }

  void _subscribeToRealtimeChanges(String driverId) {
    // Remove any existing subscription
    _channel?.unsubscribe();

    // Create a new channel for this driver's location
    _channel = _supabase.channel('driver_location_$driverId');

    _channel!
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'driver_locations',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'driver_id',
            value: driverId,
          ),
          callback: (payload) {
            final record = payload.newRecord;
            if (record.isNotEmpty) {
              final lat = (record['lat'] as num?)?.toDouble();
              final lng = (record['lng'] as num?)?.toDouble();

              if (lat != null && lng != null) {
                safeEmit(
                  TrackDriverUpdate(
                    driverLocation: LatLng(lat, lng),
                    timestamp: DateTime.now(),
                  ),
                );
              }
            }
          },
        )
        .subscribe();
  }

  void _startPolling(String driverId) {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _fetchDriverLocation(driverId);
    });
  }

  @override
  Future<void> close() {
    _channel?.unsubscribe();
    _pollTimer?.cancel();
    return super.close();
  }
}
