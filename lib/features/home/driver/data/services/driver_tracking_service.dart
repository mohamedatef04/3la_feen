import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Publishes the signed-in driver's live location so the passenger can
/// follow the car. Writes are throttled to protect battery and the database.
class DriverTrackingService {
  DriverTrackingService(
    this._supabase, {
    this.minInterval = const Duration(seconds: 1),
    DateTime Function()? clock,
  }) : _now = clock ?? DateTime.now;

  final SupabaseClient _supabase;
  final Duration minInterval;
  final DateTime Function() _now;
  DateTime? _lastSent;

  /// Sends [lat]/[lng] for the signed-in driver, unless the previous update
  /// was less than [minInterval] ago. Failures are logged and ignored: the
  /// next position update retries anyway.
  Future<void> updateMyLocation({
    required double lat,
    required double lng,
  }) async {
    final driverId = _supabase.auth.currentUser?.id;
    if (driverId == null) return;

    final now = _now();
    final last = _lastSent;
    if (last != null && now.difference(last) < minInterval) return;
    _lastSent = now;

    try {
      await _supabase.from('driver_locations').upsert({
        'driver_id': driverId,
        'lat': lat,
        'lng': lng,
        'last_updated': now.toUtc().toIso8601String(),
      });
    } catch (e) {
      debugPrint('Driver location update failed: $e');
    }
  }
}
