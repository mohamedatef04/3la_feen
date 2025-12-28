import 'package:ala_feen/features/auth/data/models/user_model.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final UserModel user;
  LoginSuccess({required this.user});
}

class LoginFailure extends LoginState {
  final String errorMessage;
  LoginFailure({required this.errorMessage});
}
