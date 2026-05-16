import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/router/app_router.dart';
import 'core/storage/token_storage.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/error_boundary.dart';
import 'core/utils/provider_observer.dart';
import 'core/utils/startup_probe.dart';
import 'features/auth/presentation/controller/auth_provider.dart';
import 'features/notifications/data/notification_device_repository.dart';
import 'features/notifications/data/notification_service.dart';
import 'features/notifications/presentation/notification_controller.dart';
import 'firebase_options.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    StartupProbe.mark('main_initialized');
    StartupProbe.installFrameTimingsProbe();

    await _initializeDateFormatting();
    await _initializeFirebase();
    await _initializeNotifications();

    StartupProbe.mark('runApp_invoked');
    if (StartupProbeConfig.disableProviderObserver) {
      StartupProbe.mark('provider_observer_disabled');
    }

    runApp(
      ProviderScope(
        observers: StartupProbeConfig.disableProviderObserver
            ? const []
            : [AppProviderObserver()],
        child: const GlobalErrorBoundary(child: MyApp()),
      ),
    );
  }, _handleUncaughtError);
}

Future<void> _initializeDateFormatting() async {
  try {
    await StartupProbe.measureAsync(
      'initializeDateFormatting',
      () => initializeDateFormatting('id_ID', null),
    );
  } catch (error, stackTrace) {
    _handleStartupError('initializeDateFormatting', error, stackTrace);
  }
}

Future<void> _initializeFirebase() async {
  try {
    await StartupProbe.measureAsync('initializeFirebase', () async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    });
  } catch (error, stackTrace) {
    _handleStartupError('initializeFirebase', error, stackTrace);
  }
}

Future<void> _initializeNotifications() async {
  if (StartupProbeConfig.skipNotificationInit) {
    StartupProbe.mark('notification_init_skipped');
    return;
  }

  try {
    await StartupProbe.measureAsync('initializeNotifications', () async {
      await NotificationService().initialize();
    });
  } catch (error, stackTrace) {
    _handleStartupError('initializeNotifications', error, stackTrace);
  }
}

void _handleStartupError(String step, Object error, StackTrace stackTrace) {
  StartupProbe.mark('${step}_failed', <String, Object?>{
    'error_type': error.runtimeType.toString(),
  });
  FlutterError.reportError(
    FlutterErrorDetails(
      exception: error,
      stack: stackTrace,
      library: 'parikesit startup',
      context: ErrorDescription(step),
    ),
  );
}

void _handleUncaughtError(Object error, StackTrace stackTrace) {
  FlutterError.reportError(
    FlutterErrorDetails(
      exception: error,
      stack: stackTrace,
      library: 'parikesit',
      context: ErrorDescription('uncaught asynchronous error'),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  late final ProviderSubscription<AuthState> _authSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _authSubscription = ref.listenManual<AuthState>(authNotifierProvider, (
      previous,
      next,
    ) {
      _handleAuthState(next);
    }, fireImmediately: true);
  }

  @override
  void dispose() {
    _authSubscription.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      return;
    }

    final authState = ref.read(authNotifierProvider);
    if (authState.status == AuthStatus.authenticated &&
        authState.user?.role == 'opd') {
      unawaited(_refreshNotificationInbox());
    }
  }

  Future<void> _handleAuthState(AuthState authState) async {
    try {
      if (StartupProbeConfig.skipNotificationInit) {
        return;
      }

      final notificationService = ref.read(notificationServiceProvider);
      final notificationDeviceRepository = ref.read(
        notificationDeviceRepositoryProvider,
      );
      final tokenStorage = ref.read(tokenStorageProvider);

      if (authState.status == AuthStatus.initial ||
          authState.status == AuthStatus.loading) {
        return;
      }

      if (authState.status != AuthStatus.authenticated ||
          authState.user?.role != 'opd') {
        notificationService.setInboxRefreshHandler(null);
        final hasAuthToken = await tokenStorage.getToken() != null;
        await notificationService.unregisterDeviceToken(
          deactivate: hasAuthToken
              ? notificationDeviceRepository.deactivateFcmToken
              : null,
        );
        return;
      }

      await notificationService.setTokenSyncHandler((token) {
        return ref
            .read(notificationDeviceRepositoryProvider)
            .registerFcmToken(token);
      });
      notificationService.setInboxRefreshHandler(_refreshNotificationInbox);
      notificationService.flushPendingNavigation();
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'parikesit notifications',
          context: ErrorDescription('auth state notification sync'),
        ),
      );
    }
  }

  Future<void> _refreshNotificationInbox() async {
    try {
      await ref.read(notificationControllerProvider.notifier).refreshSilently();
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'parikesit notifications',
          context: ErrorDescription('notification inbox refresh'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    ref.read(notificationServiceProvider).attachRouter(router);
    StartupProbe.mark('MyApp.build');

    return MaterialApp.router(
      title: 'Parikesit',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: router,
    );
  }
}
