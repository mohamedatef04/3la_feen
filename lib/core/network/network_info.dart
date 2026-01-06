import 'package:connectivity_plus/connectivity_plus.dart';

/// Network Information Interface
/// Provides network connectivity status
abstract class NetworkInfo {
  /// Checks if device is connected to internet
  Future<bool> isConnected();

  /// Get current connectivity result
  Future<ConnectivityResult> get connectivityResult;

  /// Stream of connectivity changes (single result)
  Stream<ConnectivityResult> get onConnectivityChanged;

  /// Stream of connectivity changes (raw list for multiple connections)
  Stream<List<ConnectivityResult>> get onConnectivityChangedRaw;
}

/// Implementation of NetworkInfo using connectivity_plus
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> isConnected() async {
    final results = await connectivity.checkConnectivity();
    return results.isNotEmpty && results.first != ConnectivityResult.none;
  }

  @override
  Future<ConnectivityResult> get connectivityResult async {
    final results = await connectivity.checkConnectivity();
    return results.isNotEmpty ? results.first : ConnectivityResult.none;
  }

  @override
  Stream<ConnectivityResult> get onConnectivityChanged {
    return connectivity.onConnectivityChanged.map(
      (results) => results.isNotEmpty ? results.first : ConnectivityResult.none,
    );
  }

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChangedRaw {
    return connectivity.onConnectivityChanged;
  }
}

// ============================================================================
// Failure Classes
// ============================================================================

/// Base class for all failures
abstract class Failure {}

/// Server-related failures (4xx, 5xx errors)
class ServerFailure extends Failure {}

/// Cache-related failures (local storage issues)
class CacheFailure extends Failure {}

/// Network connectivity failures
class NetworkFailure extends Failure {}

// ============================================================================
// Exception Classes
// ============================================================================

/// Server-related exceptions
class ServerException implements Exception {}

/// Cache-related exceptions
class CacheException implements Exception {}

/// Network connectivity exceptions
class NetworkException implements Exception {}

/// No internet connection exception
class NoInternetException implements Exception {
  final String message;

  NoInternetException([this.message = 'No Internet Connection']);

  @override
  String toString() => message;
}
