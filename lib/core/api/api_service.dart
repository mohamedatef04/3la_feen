import 'dart:async';

import 'package:ala_feen/core/network/api_constantas.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiService {
  final dio = Dio();

  ApiService() {
    dio.options.baseUrl = ApiConstants.baseUrl;
    dio.options.headers = {
      'apikey': ApiConstants.anonKey,
      'Authorization': 'Bearer ${ApiConstants.anonKey}',
      'Content-Type': 'application/json',
      'Prefer': 'return=representation',
      'accept': 'application/json',
    };

    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  }

  // Requests
  Future<Response> getRequest({
    required String endpoint,
    Map<String, dynamic>? queryParams,
  }) async {
    return await dio.get(endpoint, queryParameters: queryParams);
  }

  Future<Response> postRequest({
    required String endpoint,
    Map<String, dynamic>? queryParams,
    required dynamic data,
  }) async {
    return await dio.post(endpoint, data: data, queryParameters: queryParams);
  }

  Future<Response> updateRequest({
    required String endpoint,
    required dynamic data,
  }) async {
    return await dio.put(endpoint, data: data);
  }

  Future<Response> deleteRequest({
    required String endpoint,
    Map<String, dynamic>? data,
  }) async {
    return await dio.delete(endpoint, data: data);
  }
}
