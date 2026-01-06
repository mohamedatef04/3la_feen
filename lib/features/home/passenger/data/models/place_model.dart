class PlaceModel {
  int? placeId;
  String? licence;
  String? osmType;
  int? osmId;
  String? lat;
  String? lon;
  String? placeClass;
  String? type;
  int? placeRank;
  double? importance;
  String? addresstype;
  String? name;
  String? displayName;
  Address? address;
  List<String>? boundingbox;

  PlaceModel({
    this.placeId,
    this.licence,
    this.osmType,
    this.osmId,
    this.lat,
    this.lon,
    this.placeClass,
    this.type,
    this.placeRank,
    this.importance,
    this.addresstype,
    this.name,
    this.displayName,
    this.address,
    this.boundingbox,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      placeId: json['place_id'],
      licence: json['licence'],
      osmType: json['osm_type'],
      osmId: json['osm_id'],
      lat: json['lat'],
      lon: json['lon'],
      placeClass: json['class'],
      type: json['type'],
      placeRank: json['place_rank'],
      importance: (json['importance'] as num?)?.toDouble(),
      addresstype: json['addresstype'],
      name: json['name'],
      displayName: json['display_name'],
      address: json['address'] != null
          ? Address.fromJson(json['address'])
          : null,
      boundingbox: json['boundingbox'] != null
          ? (json['boundingbox'] as List).map((e) => e.toString()).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'place_id': placeId,
      'licence': licence,
      'osm_type': osmType,
      'osm_id': osmId,
      'lat': lat,
      'lon': lon,
      'class': placeClass,
      'type': type,
      'place_rank': placeRank,
      'importance': importance,
      'addresstype': addresstype,
      'name': name,
      'display_name': displayName,
      'address': address?.toJson(),
      'boundingbox': boundingbox,
    };
  }
}

class Address {
  String? manMade;
  String? road;
  String? suburb;
  String? state;
  String? iso31662Lvl4;
  String? postcode;
  String? country;
  String? countryCode;

  Address({
    this.manMade,
    this.road,
    this.suburb,
    this.state,
    this.iso31662Lvl4,
    this.postcode,
    this.country,
    this.countryCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      manMade: json['man_made'],
      road: json['road'],
      suburb: json['suburb'],
      state: json['state'],
      iso31662Lvl4: json['ISO3166-2-lvl4'],
      postcode: json['postcode'],
      country: json['country'],
      countryCode: json['country_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'man_made': manMade,
      'road': road,
      'suburb': suburb,
      'state': state,
      'ISO3166-2-lvl4': iso31662Lvl4,
      'postcode': postcode,
      'country': country,
      'country_code': countryCode,
    };
  }
}
