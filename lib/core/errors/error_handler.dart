import 'dart:io';
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

class ErrorHandler {
  static String getMessage(dynamic error) {
    if (error is PostgrestException) {
      return _handlePostgrestException(error);
    } else if (error is AuthException) {
      return _handleAuthException(error);
    } else if (error is StorageException) {
      return _handleStorageException(error);
    } else if (error is DioException) {
      return _handleDioException(error);
    } else if (error is PlatformException) {
      return _handlePlatformException(error);
    } else if (error is FirebaseException) {
      return _handleFirebaseException(error);
    } else if (error is SocketException) {
      return 'No internet connection. Please check your network.';
    } else if (error is HttpException) {
      return 'Server unreachable. Please try again later.';
    } else if (error is FormatException) {
      return 'Received invalid data format from server.';
    } else if (error is Exception) {
      final msg = error.toString();
      if (msg.contains('LANGUAGE_MISMATCH')) {
        return 'I didn’t catch that clearly. Please try speaking again in the selected language.';
      }
      if (msg.startsWith('Exception: ')) {
        return msg.replaceFirst('Exception: ', '');
      }
      return msg;
    }
    return 'An unexpected error occurred. Please try again.';
  }

  static String _handlePostgrestException(PostgrestException e) {
    switch (e.code) {
      case '23505': // unique_violation
        return 'This item already exists.';
      case '23503': // foreign_key_violation
        return 'This action cannot be completed because of a related record.';
      case '42P01': // undefined_table
        return 'Configuration error: Table not found.';
      case '42703': // undefined_column
        return 'Configuration error: Column not found.';
      default:
        return 'Database error: ${e.message}';
    }
  }

  static String _handleAuthException(AuthException e) {
    final message = e.message.toLowerCase();
    if (message.contains('invalid login credentials')) {
      return 'Invalid email or password. Please check your credentials and try again.';
    } else if (message.contains('email not confirmed')) {
      return 'Please confirm your email address before signing in. Check your inbox for a confirmation link.';
    } else if (message.contains('user already exists')) {
      return 'An account with this email already exists.';
    } else if (message.contains('password is too short')) {
      return 'Password should be at least 6 characters.';
    } else if (message.contains('rate limit')) {
      return 'Too many attempts. Please try again later.';
    } else if (message.contains('invalid_grant')) {
      return 'Session expired. Please log in again.';
    }
    return e.message;
  }

  static String _handleStorageException(StorageException e) {
    return 'File storage error: ${e.message}';
  }

  static String _handlePlatformException(PlatformException e) {
    if (e.code == 'sign_in_canceled') {
      return 'Sign in cancelled by user.';
    } else if (e.code == 'network_error') {
      return 'Network error. Please check your connection.';
    } else if (e.message?.contains('10') ?? false) {
      return 'Google Sign-In configuration error (Code 10). Please contact support.';
    }
    return e.message ?? 'Platform error occurred.';
  }

  static String _handleFirebaseException(FirebaseException e) {
    if (e.code == 'permission-denied') {
      return 'You do not have permission to perform this action.';
    } else if (e.code == 'unavailable') {
      return 'Service unavailable. Please try again later.';
    }
    return e.message ?? 'Firebase error occurred.';
  }

  static String _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please try again.';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 429) {
          return 'Service is busy. Please wait a moment and try again.';
        } else if (statusCode == 500) {
          return 'Server error. We are working on a fix.';
        } else if (statusCode == 403) {
          return 'Access denied.';
        } else if (statusCode == 404) {
          return 'Resource not found.';
        }
        return 'Internal server error occurred.';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.connectionError:
        return 'Unable to connect to service. Please check your internet.';
      default:
        return 'Network error occurred. Please try again.';
    }
  }
}
