import 'dart:async';
import 'dart:convert';

import 'package:ala_feen/core/api/api_service.dart';
import 'package:ala_feen/core/network/api_constantas.dart';
import 'package:ala_feen/core/services/current_location_track_service.dart';
import 'package:ala_feen/features/auth/data/models/user_model.dart';
import 'package:ala_feen/features/home/passenger/data/models/offer_model.dart';
import 'package:ala_feen/features/home/passenger/data/models/osrm_route_model.dart';
import 'package:ala_feen/features/home/passenger/data/models/place_model.dart';
import 'package:ala_feen/features/home/passenger/data/models/trip_model.dart';
import 'package:dio/dio.dart';
import 'package:location/location.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

abstract class PassengerDataSource {
  Future<void> getCurrentLocation(void Function(LocationData)? onData);
  Future<List<PlaceModel>> searchPlaces(String query);
  Future<OsrmRouteModel> getRoute({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  });
  Future<TripModel> sendTripRequest({
    required TripModel tripModel,
  });
  Future<UserModel> getUserById(String userId);
  Stream<OfferModel> getOffersStream({required String tripId});
}

class PassengerDataSourceImpl implements PassengerDataSource {
  final CurrentLocationTrackService currentLocationTrackService;
  final ApiService apiService;
  final SupabaseClient supabaseClient;

  PassengerDataSourceImpl(
    this.currentLocationTrackService,
    this.apiService,
    this.supabaseClient,
  );

  @override
  Future<void> getCurrentLocation(void Function(LocationData)? onData) async {
    return currentLocationTrackService.getCurrentLocation(onData);
  }

  @override
  Future<List<PlaceModel>> searchPlaces(String query) async {
    final dio = Dio();
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
      ),
    );
    final res = await dio.get(
      ApiConstants.placesApiBaseUrl + ApiConstants.placesApiSearchEndpoint,
      queryParameters: {
        'q': query,
        'format': 'json',
        'addressdetails': 1,
        'limit': 5,
        'countrycodes': 'eg',
      },
      options: Options(
        headers: {
          'User-Agent': ApiConstants.placesApiUserAgentHeader,
          'Accept-Language': 'ar',
        },
      ),
    );
    final jsonData = res.data;
    List<dynamic> places = jsonData as List<dynamic>;
    return places.map((e) => PlaceModel.fromJson(e)).toList();
  }

  @override
  Future<OsrmRouteModel> getRoute({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) async {
    // Using local dio as it was before
    final dio = Dio();
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
      ),
    );
    final res = await dio.get(
      '${ApiConstants.osrmApiBaseUrl}${ApiConstants.osrmApiRouteEndpoint}$startLng,$startLat;$endLng,$endLat',
    );
    final jsonData = res.data;
    return OsrmRouteModel.fromJson(jsonData);
  }

  @override
  Future<TripModel> sendTripRequest({required TripModel tripModel}) async {
    final res = await apiService.postRequest(
      endpoint: ApiConstants.tripsEndpoint,
      data: tripModel.toJson(),
      queryParams: {'select': '*'},
    );
    final List<dynamic> data = _ensureList(res.data);
    if (data.isEmpty) {
      throw Exception('Failed to create trip');
    }
    return TripModel.fromJson(data.first);
  }

  @override
  Future<UserModel> getUserById(String userId) async {
    final res = await apiService.getRequest(
      endpoint: '${ApiConstants.usersEndpoint}?id=eq.$userId',
    );
    final List<dynamic> usersData = _ensureList(res.data);
    if (usersData.isEmpty) {
      throw Exception('User not found');
    }
    return UserModel.fromJson(usersData.first);
  }

  List<dynamic> _ensureList(dynamic data) {
    if (data == null) return [];
    if (data is List) return data;
    if (data is Map) return [data];
    if (data is String) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is List) return decoded;
        if (decoded is Map) return [decoded];
      } catch (_) {
        return [];
      }
    }
    return [];
  }

  @override
  Stream<OfferModel> getOffersStream({required String tripId}) {
    final controller = StreamController<OfferModel>();

    final channel = supabaseClient
        .channel('offers-$tripId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'offers',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'trip_id',
            value: tripId,
          ),
          callback: (payload) {
            try {
              final offer = OfferModel.fromJson(payload.newRecord);
              controller.add(offer);
            } catch (e) {
              controller.addError(e);
            }
          },
        )
        .subscribe();

    controller.onCancel = () {
      supabaseClient.removeChannel(channel);
      controller.close();
    };

    return controller.stream;
  }
}
