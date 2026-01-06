class OsrmRouteModel {
  String? code;
  List<Route>? routes;
  List<Waypoint>? waypoints;

  OsrmRouteModel({this.code, this.routes, this.waypoints});

  factory OsrmRouteModel.fromJson(Map<String, dynamic> json) {
    return OsrmRouteModel(
      code: json['code'],
      routes: json['routes'] != null
          ? (json['routes'] as List).map((e) => Route.fromJson(e)).toList()
          : null,
      waypoints: json['waypoints'] != null
          ? (json['waypoints'] as List)
                .map((e) => Waypoint.fromJson(e))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'routes': routes?.map((e) => e.toJson()).toList(),
      'waypoints': waypoints?.map((e) => e.toJson()).toList(),
    };
  }
}

class Route {
  List<Leg>? legs;
  String? weightName;
  String? geometry;
  double? weight;
  double? duration;
  double? distance;

  Route({
    this.legs,
    this.weightName,
    this.geometry,
    this.weight,
    this.duration,
    this.distance,
  });

  factory Route.fromJson(Map<String, dynamic> json) {
    return Route(
      legs: json['legs'] != null
          ? (json['legs'] as List).map((e) => Leg.fromJson(e)).toList()
          : null,
      weightName: json['weight_name'],
      geometry: json['geometry'],
      weight: (json['weight'] as num?)?.toDouble(),
      duration: (json['duration'] as num?)?.toDouble(),
      distance: (json['distance'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'legs': legs?.map((e) => e.toJson()).toList(),
      'weight_name': weightName,
      'geometry': geometry,
      'weight': weight,
      'duration': duration,
      'distance': distance,
    };
  }
}

class Leg {
  List<dynamic>? steps;
  double? weight;
  String? summary;
  double? duration;
  double? distance;

  Leg({this.steps, this.weight, this.summary, this.duration, this.distance});

  factory Leg.fromJson(Map<String, dynamic> json) {
    return Leg(
      steps: json['steps'] != null ? List<dynamic>.from(json['steps']) : null,
      weight: (json['weight'] as num?)?.toDouble(),
      summary: json['summary'],
      duration: (json['duration'] as num?)?.toDouble(),
      distance: (json['distance'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'steps': steps,
      'weight': weight,
      'summary': summary,
      'duration': duration,
      'distance': distance,
    };
  }
}

class Waypoint {
  String? hint;
  List<double>? location;
  String? name;
  double? distance;

  Waypoint({this.hint, this.location, this.name, this.distance});

  factory Waypoint.fromJson(Map<String, dynamic> json) {
    return Waypoint(
      hint: json['hint'],
      location: json['location'] != null
          ? List<double>.from(
              json['location'].map((e) => (e as num).toDouble()),
            )
          : null,
      name: json['name'],
      distance: (json['distance'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hint': hint,
      'location': location,
      'name': name,
      'distance': distance,
    };
  }
}
