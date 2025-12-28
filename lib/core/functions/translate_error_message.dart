import 'package:ala_feen/core/utils/app_strings.dart';

String translateErrorMessage(String message) {
  if (message.contains('User already registered')) {
    return AppStrings.userAlreadyRegistered;
  } else if (message.contains('Invalid login credentials')) {
    return AppStrings.invalidLoginCredentials;
  } else if (message.contains('Email not confirmed')) {
    return AppStrings.emailNotConfirmed;
  } else if (message.contains('Password should be at least 6 characters')) {
    return AppStrings.weakPassword;
  } else if (message.contains('network') ||
      message.contains('SocketException')) {
    return AppStrings.networkError;
  } else {
    // If we don't recognize the error, return the original or a generic one
    // But since the user wants everything in Arabic, generic is safer.
    return AppStrings.unexpectedError;
  }
}
