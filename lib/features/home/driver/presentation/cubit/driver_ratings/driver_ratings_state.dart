part of 'driver_ratings_cubit.dart';

abstract class DriverRatingsState extends Equatable {
  const DriverRatingsState();

  @override
  List<Object> get props => [];
}

class DriverRatingsInitial extends DriverRatingsState {}

class DriverRatingsLoading extends DriverRatingsState {}

class DriverRatingsSuccess extends DriverRatingsState {
  final List<dynamic> ratings;

  const DriverRatingsSuccess(this.ratings);

  @override
  List<Object> get props => [ratings];
}

class DriverRatingsFailure extends DriverRatingsState {
  final String errorMessage;

  const DriverRatingsFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
