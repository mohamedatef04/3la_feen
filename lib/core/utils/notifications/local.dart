import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotifications {
  LocalNotifications._();
  static final LocalNotifications _instance = LocalNotifications._();
  factory LocalNotifications() => _instance;

  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  bool _initialized = false;
  int _id = 0;

  // Android channel
  final AndroidNotificationChannel _androidChannel = AndroidNotificationChannel(
    dotenv.env['ANDROID_CHANNEL_ID'] ?? 'high_importance_channel',
    dotenv.env['ANDROID_CHANNEL_NAME'] ?? 'High Importance Notifications',
    importance: Importance.max,
    description:
        dotenv.env['NOTIFICATION_CHANNEL_DESCRIPTION'] ??
        'This channel is used for important notifications.',
  );

  Future<void> init() async {
    if (_initialized) return;

    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const settings = InitializationSettings(android: androidSettings);

    await _flutterLocalNotificationsPlugin.initialize(settings);

    // create Android channel
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_androidChannel);

    _initialized = true;
  }

  Future<void> showNotification({
    String? title,
    String? body,
    String? payload,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      _androidChannel.id,
      _androidChannel.name,
      channelDescription: _androidChannel.description,
      importance: Importance.max,
      priority: Priority.high,
    );

    final details = NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      _id++,
      title,
      body,
      details,
      payload: payload,
    );
  }
}
