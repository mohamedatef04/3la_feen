import 'package:ala_feen/features/home/passenger/data/models/osrm_route_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OsrmRouteModel.fromJson', () {
    test('parses routes and waypoints, converting ints to doubles', () {
      final model = OsrmRouteModel.fromJson({
        'code': 'Ok',
        'routes': [
          {
            'geometry': 'abc',
            'distance': 18000,
            'duration': 1500.5,
            'weight_name': 'routability',
            'legs': [
              {'distance': 18000, 'duration': 1500, 'summary': 'Ring Road'},
            ],
          },
        ],
        'waypoints': [
          {
            'name': 'Tahrir',
            'location': [31, 30.04],
            'distance': 3,
          },
        ],
      });

      expect(model.code, 'Ok');
      expect(model.routes!.single.distance, 18000.0);
      expect(model.routes!.single.duration, 1500.5);
      expect(model.routes!.single.legs!.single.summary, 'Ring Road');
      expect(model.waypoints!.single.location, [31.0, 30.04]);
    });

    test('leaves lists null when OSRM returns no route', () {
      final model = OsrmRouteModel.fromJson({'code': 'NoRoute'});

      expect(model.code, 'NoRoute');
      expect(model.routes, isNull);
      expect(model.waypoints, isNull);
    });
  });

  test('toJson round-trips through fromJson', () {
    final original = OsrmRouteModel.fromJson({
      'code': 'Ok',
      'routes': [
        {'geometry': 'abc', 'distance': 10.0, 'duration': 5.0},
      ],
    });

    final copy = OsrmRouteModel.fromJson(original.toJson());

    expect(copy.routes!.single.geometry, 'abc');
    expect(copy.routes!.single.distance, 10.0);
  });
}
