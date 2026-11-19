import 'package:ala_feen/core/utils/notifcations.dart/local.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// MUST be top-level for background messages
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  //   }
  // } catch (e) {
  //   debugPrint("Error in background handler: $e");
  // }
}

class FcmService {
  FcmService._();
  static final FcmService _instance = FcmService._();
  static FcmService get instance => _instance;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  LocalNotifications? _localNotifications;
  bool _initialized = false;

  Future<void> initFCM({required LocalNotifications localNotifications}) async {
    if (_initialized) return;
    _initialized = true;

    _localNotifications = localNotifications;

    // Permissions
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Register background handler (must be top-level)
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // When app is opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen(_handleOnMessageOpenApp);

    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleOnMessageOpenApp(initialMessage);
    }

    // Subscribe to topic if needed
    await _firebaseMessaging.subscribeToTopic('updates');

    // Save token to Supabase
    await _registerFcmToken();
  }

  Future<void> _registerFcmToken() async {
    final token = await _firebaseMessaging.getToken();
    if (token != null) await _saveToken(token);

    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      await _saveToken(newToken);
    });
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

  void _handleOnMessageOpenApp(RemoteMessage message) {
    // Logic for when the app is opened via a notification click
    // Usually you'd navigate to a specific screen here
  }

  Future<void> _saveToken(String token) async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      await supabase
          .from('users')
          .update({'fcm_token': token})
          .eq('id', user.id);
    } catch (e) {
      print('Error saving FCM token: $e');
    }
  }
}
