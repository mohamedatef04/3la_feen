part of 'draw_polyline_cubit.dart';

class DrawPolylineState extends Equatable {
  final Set<Polyline> polylines;
  final Set<Marker> markers;
  final LatLngBounds? bounds;

  const DrawPolylineState({
    required this.polylines,
    required this.markers,
    this.bounds,
  });

  @override
  List<Object?> get props => [polylines, markers, bounds];
}
