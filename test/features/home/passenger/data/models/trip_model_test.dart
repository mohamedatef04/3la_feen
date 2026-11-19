import 'package:ala_feen/features/home/passenger/data/models/trip_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TripModel.fromJson', () {
    test('maps Supabase columns to fields', () {
      final trip = TripModel.fromJson({
        'id': 42,
        'passenger_id': 'p-1',
        'driver_id': 'd-1',
        'origin_lat': '30.04',
        'origin_lng': '31.23',
        'origin_address': 'Tahrir',
        'dist_lat': '30.11',
        'dist_lng': '31.41',
        'dist_address': 'Airport',
        'trip_duration': '25 min',
        'trip_distance': '18 km',
        'cost': 150,
        'phone_number': '01000000000',
        'status': 'accepted',
      });

      expect(trip.tripId, '42');
      expect(trip.driverId, 'd-1');
      expect(trip.origin, 'Tahrir');
      expect(trip.destination, 'Airport');
      expect(trip.price, 150);
      expect(trip.status, 'accepted');
    });

    test('falls back to empty values when optional columns are missing', () {
      final trip = TripModel.fromJson({'id': 'trip-1'});

      expect(trip.tripId, 'trip-1');
      expect(trip.driverId, isNull);
      expect(trip.originAddress, '');
      expect(trip.tripPrice, 0);
      expect(trip.status, '');
    });
  });

  test('toJson omits the id so inserts let the database generate it', () {
    final json = TripModel(tripId: 'trip-1', tripPrice: 90).toJson();

    expect(json.containsKey('id'), isFalse);
    expect(json['cost'], 90);
  });
}
