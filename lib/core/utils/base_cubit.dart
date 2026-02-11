import 'package:flutter_bloc/flutter_bloc.dart';
import '../network/network_info.dart';

abstract class BaseCubit<S> extends Cubit<S> {
  final NetworkInfo networkInfo;

  BaseCubit(super.initialState, this.networkInfo);

  // No longer need a manual safeEmit method here as the extension handles it.

  /// Manual network check utility
  Future<void> checkNetwork() async {
    final isConnected = await networkInfo.isConnected();
    if (!isConnected) {
      throw NoInternetException();
    }
  }
}
