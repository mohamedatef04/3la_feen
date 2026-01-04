import 'package:equatable/equatable.dart';

class TripModel extends Equatable {
  final String? tripId;
  final String? passengerId;
  final String? originLat;
  final String? originLng;
  final String? originAddress;
  final String? distLat;
  final String? distLng;
  final String? distAddress;
  final String? tripDuration;
  final String? tripDistance;
  final String? tripPrice;
  final String? phoneNumber;
  final String? status;
  final String? driverId;

  const TripModel({
    this.tripId,
    this.passengerId,
    this.originLat,
    this.originLng,
    this.originAddress,
    this.distLat,
    this.distLng,
    this.distAddress,
    this.tripDuration,
    this.tripDistance,
    this.tripPrice,
    this.phoneNumber,
    this.status,
    this.driverId,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) => TripModel(
    tripId: json['id'],
    passengerId: json['passenger_id'],
    originLat: json['origin_lat'],
    originLng: json['origin_lng'],
    originAddress: json['origin_address'],
    distLat: json['dist_lat'],
    distLng: json['dist_lng'],
    distAddress: json['dist_address'],
    tripDuration: json['trip_duration'],
    tripDistance: json['trip_distance'],
    tripPrice: json['cost'],
    phoneNumber: json['phone_number'],
    status: json['status'],
    driverId: json['driver_id'],
  );

  Map<String, dynamic> toJson() => {
    'passenger_id': passengerId,
    'origin_lat': originLat,
    'origin_lng': originLng,
    'origin_address': originAddress,
    'dist_lat': distLat,
    'dist_lng': distLng,
    'dist_address': distAddress,
    'trip_duration': tripDuration,
    'trip_distance': tripDistance,
    'cost': tripPrice,
    'phone_number': phoneNumber,
    'status': status,
    'driver_id': driverId,
  };

  @override
  List<Object?> get props => [
    tripId,
    passengerId,
    originLat,
    originLng,
    originAddress,
    distLat,
    distLng,
    distAddress,
    tripDuration,
    tripDistance,
    tripPrice,
    phoneNumber,
    status,
    driverId,
  ];
}
