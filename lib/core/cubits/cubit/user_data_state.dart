part of 'user_data_cubit.dart';

abstract class UserDataState extends Equatable {
  const UserDataState();

  @override
  List<Object> get props => [];
}

class UserDataInitial extends UserDataState {}

class UserDataLoading extends UserDataState {}

class UserDataSuccess extends UserDataState {
  final UserModel userModel;

  const UserDataSuccess({required this.userModel});

  @override
  List<Object> get props => [userModel];
}

class UserDataFailure extends UserDataState {
  final String errorMessage;

  const UserDataFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
