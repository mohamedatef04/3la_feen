import 'package:ala_feen/features/auth/data/models/user_model.dart';
import 'package:equatable/equatable.dart';

abstract class GetPassengerDetailsState extends Equatable {
  const GetPassengerDetailsState();
  @override
  List<Object> get props => [];
}

class GetPassengerDetailsInitial extends GetPassengerDetailsState {}

class GetPassengerDetailsLoading extends GetPassengerDetailsState {}

class GetPassengerDetailsSuccess extends GetPassengerDetailsState {
  final UserModel passengerModel;
  const GetPassengerDetailsSuccess({required this.passengerModel});
  @override
  List<Object> get props => [passengerModel];
}

class GetPassengerDetailsFailure extends GetPassengerDetailsState {
  final String errorMessage;
  const GetPassengerDetailsFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
