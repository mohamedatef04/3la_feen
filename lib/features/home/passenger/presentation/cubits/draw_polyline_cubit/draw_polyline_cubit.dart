import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'draw_polyline_state.dart';

class DrawPolylineCubit extends Cubit<DrawPolylineState> {
  DrawPolylineCubit()
    : super(const DrawPolylineState(polylines: {}, markers: {}));

  void drawRoute(List<LatLng> points) {
    if (points.isEmpty) return;

    final polyline = Polyline(
      polylineId: const PolylineId('route'),
      color: Colors.blue,
      width: 5,
      points: points,
    );

    final markers = {
      Marker(
        markerId: const MarkerId('start'),
        position: points.first,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(
          title: 'نقطة البداية',
        ),
      ),
      Marker(
        markerId: const MarkerId('end'),
        position: points.last,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: const InfoWindow(
          title: 'نقطة النهاية',
        ),
      ),
    };

    final bounds = _calculateBounds(points);

    emit(
      DrawPolylineState(
        polylines: {polyline},
        markers: markers,
        bounds: bounds,
      ),
    );
  }

  LatLngBounds _calculateBounds(List<LatLng> points) {
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  void clearRoute() {
    emit(const DrawPolylineState(polylines: {}, markers: {}));
  }
}
