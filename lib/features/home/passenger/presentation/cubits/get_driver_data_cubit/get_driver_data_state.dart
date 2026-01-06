part of 'get_driver_data_cubit.dart';

sealed class GetDriverDataState extends Equatable {
  const GetDriverDataState();

  @override
  List<Object?> get props => [];
}

final class GetDriverDataInitial extends GetDriverDataState {}

final class GetDriverDataLoading extends GetDriverDataState {}

final class GetDriverDataSuccess extends GetDriverDataState {
  final UserModel driverModel;

  const GetDriverDataSuccess({required this.driverModel});

  @override
  List<Object?> get props => [driverModel];
}

final class GetDriverDataFailure extends GetDriverDataState {
  final String errorMessage;

  const GetDriverDataFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
