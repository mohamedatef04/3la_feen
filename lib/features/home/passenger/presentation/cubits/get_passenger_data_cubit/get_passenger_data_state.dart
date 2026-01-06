part of 'get_passenger_data_cubit.dart';

sealed class GetPassengerDataState extends Equatable {
  const GetPassengerDataState();

  @override
  List<Object> get props => [];
}

final class GetPassengerDataInitial extends GetPassengerDataState {}

final class GetPassengerDataLoading extends GetPassengerDataState {}

final class GetPassengerDataSuccess extends GetPassengerDataState {
  final UserModel userModel;

  const GetPassengerDataSuccess({required this.userModel});
}

final class GetPassengerDataFailure extends GetPassengerDataState {
  final String errorMessage;

  const GetPassengerDataFailure({required this.errorMessage});
}
