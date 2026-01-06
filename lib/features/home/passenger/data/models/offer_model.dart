class OfferModel {
  final String? id;
  final String? driverId;
  final String? tripId;
  final num? offerPrice;
  final String? status;

  OfferModel({
    this.id,
    this.driverId,
    this.tripId,
    this.offerPrice,
    this.status,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) => OfferModel(
    id: json['id']?.toString(),
    driverId: json['driver_id']?.toString(),
    tripId: json['trip_id']?.toString(),
    offerPrice: json['offer']?.toDouble(),
    status: json['status']?.toString(),
  );

  Map<String, dynamic> toJson() => {
    'driver_id': driverId,
    'trip_id': tripId,
    'offer': offerPrice,
    'status': status,
  };
}
