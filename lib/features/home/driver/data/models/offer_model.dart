class OfferModel {
  final String? id;
  final String? driverId;
  final String? tripId;
  final String? offerPrice;
  final String? status;

  OfferModel({
    this.id,
    this.driverId,
    this.tripId,
    this.offerPrice,
    this.status,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) => OfferModel(
    id: json['id'],
    driverId: json['driver_id'],
    tripId: json['trip_id'],
    offerPrice: json['offer'],
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {
    'driver_id': driverId,
    'trip_id': tripId,
    'offer': offerPrice,
    'status': status,
  };
}
