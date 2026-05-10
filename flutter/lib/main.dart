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
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  StartupProbe.mark('main_initialized');
  StartupProbe.installFrameTimingsProbe();
  await StartupProbe.measureAsync(
    'initializeDateFormatting',
    () => initializeDateFormatting('id_ID', null),
  );
  await StartupProbe.measureAsync('initializeFirebase', () async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  });
  if (StartupProbeConfig.skipNotificationInit) {
    StartupProbe.mark('notification_init_skipped');
  } else {
    await StartupProbe.measureAsync('initializeNotifications', () async {
      await NotificationService().initialize();
    });
  }
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
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late final ProviderSubscription<AuthState> _authSubscription;

  @override
  void initState() {
    super.initState();
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
    super.dispose();
  }

  Future<void> _handleAuthState(AuthState authState) async {
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
    notificationService.flushPendingNavigation();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    ref.read(notificationServiceProvider).attachRouter(router);
    StartupProbe.mark('MyApp.build');

    return MaterialApp.router(
      title: 'Lean Flutter App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: router,
    );
  }
}
