import 'package:easy_localization/easy_localization.dart';

String translateErrorMessage(String message) {
  if (message.contains('User already registered') ||
      message.contains('23505') ||
      message.contains('already exists')) {
    return 'errors.user_exists'.tr();
  } else if (message.contains('Invalid login credentials')) {
    return 'errors.invalid_credentials'.tr();
  } else if (message.contains('Email not confirmed')) {
    return 'errors.email_not_confirmed'.tr();
  } else if (message.contains('network') ||
      message.contains('SocketException')) {
    return 'errors.network'.tr();
  }

  // Fallback: Return raw error for debugging
  return message;
}
