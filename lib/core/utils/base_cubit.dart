import 'package:flutter_bloc/flutter_bloc.dart';
import '../network/network_info.dart';

abstract class BaseCubit<S> extends Cubit<S> {
  final NetworkInfo networkInfo;

  BaseCubit(super.initialState, this.networkInfo);

  /// A safe wrapper for emit that checks if the Cubit is still open.
  /// This prevents "State error: Cannot emit new states after calling close"
  void safeEmit(S state) {
    if (!isClosed) {
      emit(state);
    }
  }

  /// Manual network check utility
  Future<void> checkNetwork() async {
    final isConnected = await networkInfo.isConnected();
    if (!isConnected) {
      throw NoInternetException();
    }
  }
}
