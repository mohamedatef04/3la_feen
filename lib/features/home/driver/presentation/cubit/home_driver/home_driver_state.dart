import 'package:ala_feen/features/auth/data/models/user_model.dart';
import 'package:equatable/equatable.dart';

enum HomeDriverStatus { initial, loading, success, failure }

class HomeDriverState extends Equatable {
  final HomeDriverStatus status;
  final UserModel? userModel;
  final String? errorMessage;

  const HomeDriverState({
    required this.status,
    this.userModel,
    this.errorMessage,
  });

  HomeDriverState copyWith({
    HomeDriverStatus? status,
    UserModel? userModel,
    String? errorMessage,
  }) {
    return HomeDriverState(
      status: status ?? this.status,
      userModel: userModel ?? this.userModel,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, userModel, errorMessage];
}
