part of 'get_route_cubit.dart';

sealed class GetRouteState extends Equatable {
  const GetRouteState();

  @override
  List<Object> get props => [];
}

final class GetRouteInitial extends GetRouteState {}

final class GetRouteLoading extends GetRouteState {}

final class GetRouteSuccess extends GetRouteState {
  final OsrmRouteModel route;
  final String startLocation;
  final String endLocation;
  final double startLat;
  final double startLng;
  final double endLat;
  final double endLng;

  const GetRouteSuccess({
    required this.route,
    required this.startLocation,
    required this.endLocation,
    required this.startLat,
    required this.startLng,
    required this.endLat,
    required this.endLng,
  });

  @override
  List<Object> get props => [
    route,
    startLocation,
    endLocation,
    startLat,
    startLng,
    endLat,
    endLng,
  ];
}

final class GetRouteFailure extends GetRouteState {
  final String errorMessage;

  const GetRouteFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
