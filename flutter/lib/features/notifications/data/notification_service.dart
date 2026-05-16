import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/logger.dart';
import '../../../firebase_options.dart';
import 'notification_navigation.dart';

final FlutterLocalNotificationsPlugin _sharedLocalNotifications =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel _highImportanceChannel =
    AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  if (message.notification == null) {
    await _showLocalNotification(message, ensureInitialized: true);
  }
}

Future<void> _showLocalNotification(
  RemoteMessage message, {
  bool ensureInitialized = false,
}) async {
  final notification = message.notification;
  final title = notification?.title ?? message.data['title'] as String?;
  final body = notification?.body ?? message.data['body'] as String?;
  if (title == null && body == null) {
    return;
  }

  if (ensureInitialized) {
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    await _sharedLocalNotifications.initialize(
      settings: initializationSettings,
    );
  }
  await _sharedLocalNotifications
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(_highImportanceChannel);

  await _sharedLocalNotifications.show(
    id: message.messageId.hashCode,
    title: title,
    body: body,
    notificationDetails: const NotificationDetails(
      android: AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        channelDescription: 'This channel is used for important notifications.',
        icon: '@mipmap/ic_launcher',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
    payload: jsonEncode(message.data),
  );
}

class NotificationService {
  factory NotificationService() => _instance;

  NotificationService._internal();

  static final NotificationService _instance = NotificationService._internal();

  static bool _isInitialized = false;

  FirebaseMessaging get _fcm => FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      _sharedLocalNotifications;
  StreamSubscription<String>? _tokenRefreshSubscription;
  StreamSubscription<RemoteMessage>? _foregroundMessageSubscription;
  StreamSubscription<RemoteMessage>? _messageOpenedAppSubscription;
  Future<void> Function(String token)? _tokenSyncHandler;
  Future<void> Function()? _inboxRefreshHandler;
  GoRouter? _router;
  String? _pendingRoute;
  String? _lastKnownToken;

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    if (Firebase.apps.isEmpty) {
      return;
    }

    try {
      // 1. Meminta izin (Android 13+)
      await _fcm.requestPermission();

      // 2. Konfigurasi Local Notifications untuk Android
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const InitializationSettings initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);
      await _localNotifications.initialize(
        settings: initializationSettings,
        onDidReceiveNotificationResponse: (response) {
          final payload = response.payload;
          if (payload == null || payload.isEmpty) {
            return;
          }

          try {
            final decoded = jsonDecode(payload);
            if (decoded is Map<String, dynamic>) {
              _handleNotificationInteraction(decoded);
            } else if (decoded is Map) {
              _handleNotificationInteraction(decoded.cast<String, dynamic>());
            }
          } catch (_) {
            // Ignore malformed notification payloads.
          }
        },
      );
      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();

      // 3. Create Android Notification Channel
      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(_highImportanceChannel);

      // 4. Konfigurasi Firebase Messaging Foreground Presentation Options
      // Ini membantu di beberapa versi Android agar sistem tahu kita ingin banner
      await _fcm.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // 5. Mendapatkan token FCM
      final token = await _fcm.getToken();
      await _handleTokenUpdate(token);
      await _tokenRefreshSubscription?.cancel();
      _tokenRefreshSubscription = _fcm.onTokenRefresh.listen((token) {
        unawaited(_handleTokenUpdate(token));
      });

      // 6. Menangani pesan saat aplikasi di foreground
      await _foregroundMessageSubscription?.cancel();
      _foregroundMessageSubscription = FirebaseMessaging.onMessage.listen(
        _handleForegroundMessage,
      );

      // 7. Menangani tap notifikasi saat aplikasi di background tapi masih terbuka
      await _messageOpenedAppSubscription?.cancel();
      _messageOpenedAppSubscription = FirebaseMessaging.onMessageOpenedApp
          .listen(_handleNotificationOpen);

      // 8. Cek jika aplikasi terbuka dari terminasi via notifikasi
      final RemoteMessage? initialMessage = await _fcm.getInitialMessage();
      if (initialMessage != null) {
        _handleNotificationOpen(initialMessage);
      }

      _isInitialized = true;
    } catch (e, stackTrace) {
      AppLogger.error('Notification service init failed', e, stackTrace);
    }
  }

  Future<void> setTokenSyncHandler(
    Future<void> Function(String token)? handler,
  ) async {
    _tokenSyncHandler = handler;

    if (handler == null) {
      return;
    }

    final token = await _fcm.getToken();
    await _handleTokenUpdate(token);
  }

  void setInboxRefreshHandler(Future<void> Function()? handler) {
    _inboxRefreshHandler = handler;
  }

  void attachRouter(GoRouter router) {
    _router = router;
    flushPendingNavigation();
  }

  void flushPendingNavigation() {
    if (_pendingRoute == null || _router == null) {
      return;
    }

    final route = _pendingRoute!;
    _pendingRoute = null;
    _router!.go(route);
  }

  Future<void> _handleTokenUpdate(String? token) async {
    if (token == null || token.isEmpty) {
      return;
    }

    _lastKnownToken = token;
    final handler = _tokenSyncHandler;
    if (handler == null) {
      return;
    }

    try {
      await handler(token);
    } catch (error, stackTrace) {
      AppLogger.error('FCM token sync failed', error, stackTrace);
    }
  }

  Future<String?> currentToken() async {
    return _lastKnownToken ?? await _fcm.getToken();
  }

  Future<void> unregisterDeviceToken({
    Future<void> Function(String token)? deactivate,
  }) async {
    final token = await currentToken();
    if (token != null && token.isNotEmpty && deactivate != null) {
      try {
        await deactivate(token);
      } catch (error, stackTrace) {
        AppLogger.error('FCM token deactivate failed', error, stackTrace);
      }
    }

    try {
      await _fcm.deleteToken();
    } catch (error, stackTrace) {
      AppLogger.error('FCM deleteToken failed', error, stackTrace);
    }

    _lastKnownToken = null;
    _tokenSyncHandler = null;
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    await _showLocalNotification(message);
    await _refreshInbox();
  }

  void _handleNotificationOpen(RemoteMessage message) {
    unawaited(_refreshInbox());
    _handleNotificationInteraction(message.data);
  }

  Future<void> _refreshInbox() async {
    final handler = _inboxRefreshHandler;
    if (handler == null) {
      return;
    }

    try {
      await handler();
    } catch (error, stackTrace) {
      AppLogger.error('Notification inbox refresh failed', error, stackTrace);
    }
  }

  void _handleNotificationInteraction(Map<String, dynamic> data) {
    final type = data['type']?.toString();
    if (type == null || type.isEmpty) {
      return;
    }

    final route = _resolveTargetRoute(data);
    if (route == null || route.isEmpty) {
      return;
    }

    if (_router == null) {
      _pendingRoute = route;
      return;
    }

    _router!.go(route);
  }

  String? _resolveTargetRoute(Map<String, dynamic> data) {
    return resolveNotificationTargetRoute(data);
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});
