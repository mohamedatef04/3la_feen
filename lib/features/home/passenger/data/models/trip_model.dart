class TripModel {
  final String? tripId;
  final String? passengerId;
  final String? driverId;
  final String? originLat;
  final String? originLng;
  final String? originAddress;
  final String? distLat;
  final String? distLng;
  final String? distAddress;
  final String? tripDuration;
  final String? tripDistance;
  final num? tripPrice;
  final String? passengerPhoneNumber;
  final String? status;

  TripModel({
    this.tripId,
    this.passengerId,
    this.driverId,
    this.originLat,
    this.originLng,
    this.originAddress,
    this.distLat,
    this.distLng,
    this.distAddress,
    this.tripDuration,
    this.tripDistance,
    this.tripPrice,
    this.passengerPhoneNumber,
    this.status,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) => TripModel(
    tripId: json['id']?.toString(),
    passengerId: json['passenger_id']?.toString(),
    originLat: json['origin_lat'] ?? '',
    originLng: json['origin_lng'] ?? '',
    driverId: json['driver_id']?.toString(),
    originAddress: json['origin_address'] ?? '',
    distLat: json['dist_lat'] ?? '',
    distLng: json['dist_lng'] ?? '',
    distAddress: json['dist_address'] ?? '',
    tripDuration: json['trip_duration'] ?? '',
    tripDistance: json['trip_distance'] ?? '',
    tripPrice: json['cost'] ?? 0,
    passengerPhoneNumber: json['phone_number'] ?? '',
    status: json['status'] ?? '',
  );

  // Convenience getters
  String? get origin => originAddress;
  String? get destination => distAddress;
  num? get price => tripPrice;

  Map<String, dynamic> toJson() => {
    'passenger_id': passengerId,
    'driver_id': driverId,
    'origin_lat': originLat,
    'origin_lng': originLng,
    'origin_address': originAddress,
    'dist_lat': distLat,
    'dist_lng': distLng,
    'dist_address': distAddress,
    'trip_duration': tripDuration,
    'trip_distance': tripDistance,
    'cost': tripPrice,
    'phone_number': passengerPhoneNumber,
    'status': status,
  };
}
