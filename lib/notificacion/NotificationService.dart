import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const settings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    await notifications.initialize(
      const InitializationSettings(
        android: settings,
      ),
    );
  }

  static Future<void> show({
    required String title,
    required String body,
  }) async {
    await notifications.show(
      0,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'adoption_channel',
          'Solicitudes',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }
}