import 'package:easy_localization/easy_localization.dart';

class Validator {
  static String? validateEmptyText(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'validation.email_required'.tr();
    }
    final emailRegExp = RegExp(
      r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$',
    );

    if (!emailRegExp.hasMatch(value)) {
      return 'validation.email_invalid'.tr();
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'validation.password_required'.tr();
    }

    if (value.length < 6) {
      return 'validation.password_min'.tr();
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'validation.password_upper'.tr();
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'validation.password_lower'.tr();
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'validation.password_digit'.tr();
    }
    if (!value.contains(RegExp(r'^(?=.*?[#?!@$%^&*-])'))) {
      return 'validation.password_special'.tr();
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'validation.phone_required'.tr();
    }
    final phoneRegExp = RegExp(r'^(010|011|012|015)[0-9]{8}$');

    if (!phoneRegExp.hasMatch(value)) {
      return 'validation.phone_invalid'.tr();
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'validation.confirm_password_required'.tr();
    }
    if (value != password) {
      return 'validation.passwords_mismatch'.tr();
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'validation.name_required'.tr();
    }
    if (value.length < 3) {
      return 'validation.name_min'.tr();
    }
    return null;
  }

  static String? validatePersonalId(String? value) {
    if (value == null || value.isEmpty) {
      return 'validation.national_id_required'.tr();
    }
    final personalIdRegExp = RegExp(r'^[0-9]{14}$');
    if (!personalIdRegExp.hasMatch(value)) {
      return 'validation.national_id_length'.tr();
    }
    return null;
  }

  static String? validateLicenseNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'validation.license_required'.tr();
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'validation.license_digits'.tr();
    }
    return null;
  }

  static String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'validation.address_required'.tr();
    }
    if (value.length < 5) {
      return 'validation.address_min'.tr();
    }
    return null;
  }
}
