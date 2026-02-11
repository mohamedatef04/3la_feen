import 'package:supabase_flutter/supabase_flutter.dart';

class DriverTrackingService {
  final SupabaseClient _supabase;

  DriverTrackingService(this._supabase);

  Future<void> updateLocation({
    required String driverId,
    required double lat,
    required double lng,
  }) async {
    try {
      await _supabase.from('driver_locations').upsert({
        'driver_id': driverId,
        'lat': lat,
        'lng': lng,
        'last_updated': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // Fail silently for location updates to avoid spamming errors
      // debugPrint('Error updating location: $e');
    }
  }
}
