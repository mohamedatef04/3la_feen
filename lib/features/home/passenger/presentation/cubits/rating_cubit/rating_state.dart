part of 'rating_cubit.dart';

abstract class RatingState extends Equatable {
  const RatingState();

  @override
  List<Object?> get props => [];
}

class RatingInitial extends RatingState {}

class RatingLoading extends RatingState {}

class RatingSuccess extends RatingState {}

class RatingFailure extends RatingState {
  final String errorMessage;

  const RatingFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
