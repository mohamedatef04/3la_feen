import 'package:easy_localization/easy_localization.dart';

/// Shared UI strings. Each getter returns the text in the current app
/// language; the texts live in `assets/lang/{ar,en}.json`.
abstract class AppStrings {
  static String get splashViewWelcomeMessage => 'app.welcome'.tr();
  static String get nextButton => 'common.next'.tr();
  static String get skipButton => 'common.skip'.tr();
  static String get newUser => 'auth.new_user'.tr();
  static String get login => 'auth.login'.tr();
  static String get password => 'auth.password'.tr();
  static String get guestAccount => 'auth.guest'.tr();
  static String get pressHere => 'common.press_here'.tr();
  static String get driver => 'common.driver'.tr();
  static String get passenger => 'common.passenger'.tr();
  static String get fullName => 'auth.full_name'.tr();
  static String get phoneNumber => 'auth.phone'.tr();
  static String get profileImage => 'auth.profile_image'.tr();
  static String get email => 'auth.email'.tr();
  static String get personalIdCard => 'auth.id_card'.tr();
  static String get licenseImage => 'auth.license_image'.tr();
  static String get carImage => 'auth.car_image'.tr();
  static String get send => 'common.send'.tr();
  static String get successfulRegistrationForDriver =>
      'auth.register_success_driver'.tr();
  static String get successfulRegistrationForPassenger =>
      'auth.register_success_passenger'.tr();
  static String get thanksForUsingOurApp => 'app.thanks_for_using'.tr();
  static String get backToLogin => 'auth.back_to_login'.tr();
  static String get exit => 'common.exit'.tr();
  static String get approveConditions => 'auth.terms_notice'.tr();
  static String get availableTrips => 'driver.available_trips'.tr();
  static String get tripsWillAppearWhenYouBecomeAvailable =>
      'driver.trips_appear_when_available'.tr();
  static String get addressOneEx => 'placeholder.address_one'.tr();
  static String get addressTwoEx => 'placeholder.address_two'.tr();
  static String get pound => 'units.pound'.tr();
  static String get approve => 'common.accept'.tr();
  static String get reject => 'common.decline'.tr();
  static String get startTrip => 'trip.start'.tr();
  static String get endTheTrip => 'trip.end'.tr();
  static String get tripIsFinished => 'trip.finished'.tr();
  static String get inTheRoad => 'trip.on_the_way'.tr();
  static String get tripCost => 'trip.cost'.tr();
  static String get tripDuration => 'trip.duration'.tr();
  static String get getPaid => 'trip.paid'.tr();
  static String get chooseYourTrip => 'trip.choose_now'.tr();
  static String get from => 'trip.from'.tr();
  static String get to => 'trip.to'.tr();
  static String get selectTheArea => 'trip.where_and_how_much'.tr();
  static String get searchingForDriver => 'trip.searching_driver'.tr();
  static String get driverFound => 'trip.driver_found'.tr();
  static String get rating => 'rating.title'.tr();
  static String get howWasYourTrip => 'rating.how_was_trip'.tr();
  static String get rateTheDriver => 'rating.rate_driver'.tr();
  static String get yourRatingWillHelpUsImprove => 'rating.helps_us'.tr();
  static String get logout => 'auth.logout'.tr();
  static String get account => 'menu.account'.tr();
  static String get notifications => 'menu.notifications'.tr();
  static String get history => 'menu.history'.tr();
  static String get ratings => 'menu.ratings'.tr();

  // Forget Password
  static String get forgetPassword => 'auth.forgot_password'.tr();
  static String get forgetPasswordDescription =>
      'auth.forgot_password_description'.tr();
  static String get enterEmail => 'auth.enter_email'.tr();

  // Reset Password
  static String get resetPassword => 'auth.reset_password'.tr();
  static String get resetPasswordDescription =>
      'auth.reset_password_description'.tr();
  static String get newPassword => 'auth.new_password'.tr();
  static String get enterNewPassword => 'auth.enter_new_password'.tr();
  static String get confirmPassword => 'auth.confirm_password'.tr();
  static String get confirmNewPassword => 'auth.confirm_new_password'.tr();
  static String get passwordsDoNotMatch => 'validation.passwords_mismatch'.tr();
  static String get changePassword => 'auth.change_password'.tr();

  // Messages
  static String get passwordChangedSuccessfully => 'auth.password_changed'.tr();
  static String get resetLinkSent => 'auth.reset_link_sent'.tr();
  static String get loginSuccessful => 'auth.login_success'.tr();
  static String get userAlreadyRegistered => 'errors.user_exists'.tr();
  static String get invalidLoginCredentials =>
      'errors.invalid_credentials'.tr();
  static String get emailNotConfirmed => 'errors.email_not_confirmed'.tr();
  static String get weakPassword => 'errors.weak_password'.tr();
  static String get networkError => 'errors.network'.tr();
  static String get unexpectedError => 'errors.unexpected'.tr();
  static String get pleaseSelectProfileImage =>
      'auth.select_profile_image'.tr();
  static String get pleaseUploadAllImages => 'auth.upload_all_images'.tr();

  // Passenger Home
  static String get chooseYourTripSafely => 'trip.choose_safely'.tr();
  static String get payment => 'trip.payment'.tr();
  static String get cash => 'trip.cash'.tr();
  static String get searchForDriver => 'trip.search_driver'.tr();
  static String get enterYourPath => 'trip.enter_route'.tr();
  static String get chooseOnMap => 'trip.choose_on_map'.tr();
  static String get paymentMethods => 'menu.payment_methods'.tr();
  static String get offers => 'menu.offers'.tr();
  static String get lightMode => 'menu.light_mode'.tr();
  static String get darkMode => 'menu.dark_mode'.tr();
  static String get home => 'passenger.home'.tr();
  static String get work => 'passenger.work'.tr();
  static String get savedPlaces => 'passenger.saved_places'.tr();
  static String get fromValidator => 'validation.pickup_required'.tr();
  static String get toValidator => 'validation.destination_required'.tr();
  static String get tripDetails => 'trip.details'.tr();
  static String get km => 'units.km'.tr();
  static String get minute => 'units.minute'.tr();
  static String get tripCostOptional => 'trip.cost_optional'.tr();
  static String get enterCost => 'trip.cost_hint'.tr();
  static String get egp => 'units.egp'.tr();
  static String get distance => 'trip.distance'.tr();
  static String get expectedTime => 'trip.expected_time'.tr();

  /// "Enter {field}" input hint, e.g. `enterField(email)`.
  static String enterField(String field) =>
      'auth.enter_field'.tr(namedArgs: {'field': field});

  /// "{value} EGP" formatted price.
  static String price(Object? value) =>
      'units.price'.tr(namedArgs: {'value': '${value ?? 0}'});
}
