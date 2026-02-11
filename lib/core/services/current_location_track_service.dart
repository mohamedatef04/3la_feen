import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:location/location.dart';

class CurrentLocationTrackService {
  final Location location = Location();
  StreamSubscription<LocationData>? _locationSubscription;

  //* here i'm checking if the location service is enabled and requesting it if it's not
  Future<void> checkLocationServiceAndRequestIt() async {
    bool isServiceEnabled = await location.serviceEnabled();
    if (!isServiceEnabled) {
      isServiceEnabled = await location.requestService();
      if (!isServiceEnabled) {
        throw LocationServiceException('Location service is not enabled');
      }
    }
  }

  //* here i'm checking if the location permission is granted and requesting it if it's not
  Future<void> checkAndRequestLocationPermission() async {
    var permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.deniedForever) {
      throw LocationPermissionException(
        'Location permission is denied forever',
      );
    }
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        throw LocationPermissionException('Location permission is denied');
      }
    }
  }

  //* here i'm getting the current location
  Future<void> getCurrentLocation(void Function(LocationData)? onData) async {
    await checkLocationServiceAndRequestIt();
    await checkAndRequestLocationPermission();

    //* here i'm saying to the location to update the location after 2 meters
    //* the location stream gives me a stream data after 1s even if the location didn't change
    //* so i'm saying to the location to update the location after 2 meters
    location.changeSettings(distanceFilter: 2);

    //* Cancel any existing subscription before creating a new one
    await _locationSubscription?.cancel();

    //* here i'm listening to the location stream
    _locationSubscription = location.onLocationChanged.listen(onData);

    //* Fetch and send the initial location immediately in the background
    if (onData != null) {
      location
          .getLocation()
          .then((initialLocation) {
            onData(initialLocation);
          })
          .catchError((e) {
            debugPrint('Error fetching initial location: $e');
          });
    }
  }

  //* Stop tracking location
  Future<void> stopTracking() async {
    await _locationSubscription?.cancel();
    _locationSubscription = null;
  }

  //* here i'm getting the last known location
  Future<LocationData?> getLastKnownLocation() async {
    await checkLocationServiceAndRequestIt();
    await checkAndRequestLocationPermission();
    return await location.getLocation();
  }

  //* Dispose method to clean up resources
  void dispose() {
    _locationSubscription?.cancel();
  }
}

class LocationServiceException implements Exception {
  final String message;

  LocationServiceException(this.message);
}

class LocationPermissionException implements Exception {
  final String message;

  LocationPermissionException(this.message);
}
