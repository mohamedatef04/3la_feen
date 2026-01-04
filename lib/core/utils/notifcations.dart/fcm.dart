import 'package:ala_feen/core/utils/notifcations.dart/local.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// MUST be a top-level function (outside any class)
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final notification = message.notification;
  if (notification != null) {
    LocalNotifications().showNotification(
      title: notification.title,
      body: notification.body,
    );
  }
}

class FcmService {
  FcmService._();
  static final FcmService _instance = FcmService._();
  static FcmService get instance => _instance;

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  LocalNotifications? _localNotifications;

  Future<void> initFCM({required LocalNotifications localNotifications}) async {
    _localNotifications = localNotifications;

    // Permissions
    await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Register background handler (MUST be before onMessage)
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Foreground message
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // User taps notification (app was background)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleOnMessageOpenApp);

    // User taps notification (app was terminated)
    final initialMessage = await firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleOnMessageOpenApp(initialMessage);
    }

    // Subscribe to updates topic for broadcasting
    await firebaseMessaging.subscribeToTopic('updates');

    // Save FCM token to Supabase (only if logged in)
    await registerUserFcmToken();
  }

  Future<void> registerUserFcmToken() async {
    try {
      final token = await firebaseMessaging.getToken();
      if (token != null) {
        await saveToken(token);
      }

      firebaseMessaging.onTokenRefresh.listen((newToken) async {
        await saveToken(newToken);
      });
    } catch (e) {}
  }

  void _handleOnMessageOpenApp(RemoteMessage message) {
    final notification = message.notification;
    if (notification != null) {
      _localNotifications?.showNotification(
        title: notification.title,
        body: notification.body,
      );
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification != null) {
      _localNotifications?.showNotification(
        title: notification.title,
        body: notification.body,
      );
    }
  }

  Future<void> saveToken(String token) async {
    final supabase = Supabase.instance.client;
    print(token);
    try {
      await supabase.auth.updateUser(
        UserAttributes(data: {'fcm_token': token}),
      );
    } on AuthApiException catch (e) {
      if (e.message.contains('token is expired')) {
        await supabase.auth.refreshSession();
        await supabase.auth.updateUser(
          UserAttributes(data: {'fcm_token': token}),
        );
      } else {}
    }
  }
}
