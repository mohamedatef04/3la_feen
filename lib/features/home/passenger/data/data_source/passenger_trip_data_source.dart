import 'dart:async';

import 'package:ala_feen/core/errors/custom_exeption.dart';
import 'package:ala_feen/features/home/passenger/data/models/trip_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase access for a passenger's trip once it has been requested:
/// following its status, tracking the driver, cancelling and rating.
abstract class PassengerTripDataSource {
  Future<TripModel?> fetchTrip(String tripId);
  Future<TripModel?> fetchLatestActiveTrip(String passengerId);
  Stream<TripModel> watchTrip(String tripId);
  Future<LatLng?> fetchDriverLocation(String driverId);
  Stream<LatLng> watchDriverLocation(String driverId);
  Future<void> cancelTrip(String tripId);
  Future<void> submitRating({
    required String tripId,
    required String driverId,
    required String passengerId,
    required int rating,
    String? comment,
  });
}

class PassengerTripDataSourceImpl implements PassengerTripDataSource {
  PassengerTripDataSourceImpl(this._supabase);

  final SupabaseClient _supabase;

  static const _activeStatuses =
      'status.eq.accepted,status.eq.driver_arrived,status.eq.started';

  @override
  Future<TripModel?> fetchTrip(String tripId) async {
    final data = await _supabase
        .from('trips')
        .select()
        .eq('id', tripId)
        .maybeSingle();
    return data == null ? null : TripModel.fromJson(data);
  }

  @override
  Future<TripModel?> fetchLatestActiveTrip(String passengerId) async {
    final data = await _supabase
        .from('trips')
        .select()
        .eq('passenger_id', passengerId)
        .or(_activeStatuses)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();
    return data == null ? null : TripModel.fromJson(data);
  }

  @override
  Stream<TripModel> watchTrip(String tripId) => _watchRow(
    channelName: 'trip_status_$tripId',
    table: 'trips',
    event: PostgresChangeEvent.update,
    column: 'id',
    value: tripId,
    map: TripModel.fromJson,
  );

  @override
  Future<LatLng?> fetchDriverLocation(String driverId) async {
    final data = await _supabase
        .from('driver_locations')
        .select()
        .eq('driver_id', driverId)
        .maybeSingle();
    return data == null ? null : _toLatLng(data);
  }

  @override
  Stream<LatLng> watchDriverLocation(String driverId) => _watchRow(
    channelName: 'driver_location_$driverId',
    table: 'driver_locations',
    event: PostgresChangeEvent.all,
    column: 'driver_id',
    value: driverId,
    map: _toLatLng,
  ).where((location) => location != null).cast<LatLng>();

  @override
  Future<void> cancelTrip(String tripId) async {
    await _supabase
        .from('trips')
        .update({'status': 'cancelled'})
        .eq('id', tripId);
  }

  @override
  Future<void> submitRating({
    required String tripId,
    required String driverId,
    required String passengerId,
    required int rating,
    String? comment,
  }) async {
    if (_supabase.auth.currentUser == null) {
      throw const CustomExeption(errorMessage: 'User not authenticated');
    }
    await _supabase.from('trip_ratings').insert({
      'trip_id': tripId,
      'driver_id': driverId,
      'passenger_id': passengerId,
      'rating': rating,
      'comment': comment,
    });
  }

  static LatLng? _toLatLng(Map<String, dynamic> row) {
    final lat = (row['lat'] as num?)?.toDouble();
    final lng = (row['lng'] as num?)?.toDouble();
    return lat == null || lng == null ? null : LatLng(lat, lng);
  }

  /// Turns a Supabase realtime subscription on one row into a stream.
  /// The channel is removed when the listener cancels.
  Stream<T> _watchRow<T>({
    required String channelName,
    required String table,
    required PostgresChangeEvent event,
    required String column,
    required String value,
    required T Function(Map<String, dynamic>) map,
  }) {
    late final RealtimeChannel channel;
    final controller = StreamController<T>(
      onCancel: () => _supabase.removeChannel(channel),
    );

    channel = _supabase
        .channel(channelName)
        .onPostgresChanges(
          event: event,
          schema: 'public',
          table: table,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: column,
            value: value,
          ),
          callback: (payload) {
            if (payload.newRecord.isEmpty) return;
            try {
              controller.add(map(payload.newRecord));
            } catch (e) {
              controller.addError(e);
            }
          },
        )
        .subscribe();

    return controller.stream;
  }
}
