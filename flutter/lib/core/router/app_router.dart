import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:parikesit/core/auth/role_access.dart';
import 'package:parikesit/core/auth/user_role.dart';
import 'package:parikesit/core/router/route_constants.dart';
import 'package:parikesit/core/router/router_refresh_notifier.dart';
import 'package:parikesit/core/widgets/main_layout.dart';
import 'package:parikesit/features/admin/presentation/controller/admin_dokumentasi_state.dart';
import 'package:parikesit/features/admin/presentation/controller/dokumentasi_detail_controller.dart';
import 'package:parikesit/features/admin/presentation/dokumentasi_detail_screen.dart';
import 'package:parikesit/features/assessment/domain/assessment_domain.dart';
import 'package:parikesit/features/assessment/domain/assessment_models.dart';
import 'package:parikesit/features/assessment/presentation/activity_review_screen.dart';
import 'package:parikesit/features/assessment/presentation/domain_correction_list_screen.dart';
import 'package:parikesit/features/assessment/presentation/indicator_read_only_review_screen.dart';
import 'package:parikesit/features/assessment/presentation/models/indicator_review_models.dart';
import 'package:parikesit/features/assessment/presentation/opd_selection_screen.dart';
import 'package:parikesit/features/auth/presentation/change_password_screen.dart';
import 'package:parikesit/features/auth/presentation/controller/auth_provider.dart';
import 'package:parikesit/features/auth/presentation/edit_profile_screen.dart';
import 'package:parikesit/features/auth/presentation/login_screen.dart';
import 'package:parikesit/features/auth/presentation/profile_screen.dart';
import 'package:parikesit/features/home/presentation/home_screen.dart';
import 'package:parikesit/features/notifications/presentation/notification_list_screen.dart';
import 'package:parikesit/features/pembinaan/presentation/dokumentasi_list_screen.dart';
import 'package:parikesit/features/public/presentation/landing_public_screen.dart';

import 'auth_bootstrap_screen.dart';
import 'routes/admin_routes.dart';
import 'routes/assessment_routes.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();
final RegExp _publicAssessmentPath = RegExp(
  r'^/publik/penilaian-selesai(?:/.*)?$',
);

final routerProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = ref.watch(routerRefreshNotifierProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteConstants.landing,
    debugLogDiagnostics: false,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final authState = ref.read(authNotifierProvider);
      final String currentPath = state.uri.path;
      final isBootstrap = currentPath == RouteConstants.authBootstrap;
      final isLoggingIn = currentPath == RouteConstants.login;
      final isLanding = currentPath == RouteConstants.landing;
      final isPublicRoute = _isPublicRoute(currentPath);

      if (authState.status == AuthStatus.loading ||
          authState.status == AuthStatus.initial) {
        if (isBootstrap) {
          return null;
        }

        return _buildBootstrapLocation(state.uri);
      }

      final isAuthenticated = authState.status == AuthStatus.authenticated;
      if (isBootstrap) {
        return _resolveBootstrapDestination(
          authState: authState,
          bootstrapUri: state.uri,
        );
      }

      if (!isAuthenticated) {
        return isLoggingIn || isPublicRoute ? null : RouteConstants.login;
      }

      // Scheduling has been removed; redirect any legacy deep links.
      if (state.uri.path.startsWith('/scheduling')) {
        return RouteConstants.home;
      }

      if (isLoggingIn || isLanding) {
        return RouteConstants.home;
      }

      final role = ref.read(userRoleProvider);
      final location = state.matchedLocation;

      final bool allowed = RoleAccess.canAccessRoute(role, location);
      if (!allowed) {
        return role == UserRole.unknown
            ? RouteConstants.login
            : RouteConstants.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RouteConstants.authBootstrap,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AuthBootstrapScreen(),
      ),
      GoRoute(
        path: RouteConstants.landing,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LandingPublicScreen(),
      ),
      GoRoute(
        path: RouteConstants.publicAssessmentOpdSelection,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final String activityId = state.pathParameters['activityId']!;
          return OpdSelectionScreen(
            activityId: activityId,
            activity: state.extra as AssessmentFormModel?,
            isPublicReadOnly: true,
          );
        },
      ),
      GoRoute(
        path: RouteConstants.publicAssessmentOpdReview,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final String activityId = state.pathParameters['activityId']!;
          final int? opdId = int.tryParse(state.pathParameters['opdId'] ?? '');

          return ActivityReviewScreen(
            activityId: activityId,
            opdId: opdId,
            activity: state.extra as AssessmentFormModel?,
            isPublicReadOnly: true,
          );
        },
        routes: [
          GoRoute(
            path: 'domain/:domainId',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) {
              final String activityId = state.pathParameters['activityId']!;
              final String domainId = state.pathParameters['domainId']!;
              final Map<String, dynamic>? extra =
                  state.extra as Map<String, dynamic>?;
              final List<IndicatorComparisonData> indicatorComparisons =
                  ((extra?['indicatorComparisons'] as List<dynamic>?) ??
                          const <dynamic>[])
                      .map((dynamic item) {
                        if (item is IndicatorComparisonData) {
                          return item;
                        }

                        return IndicatorComparisonData.fromJson(
                          item as Map<String, dynamic>,
                        );
                      })
                      .toList(growable: false);

              return DomainCorrectionListScreen(
                activityId: activityId,
                domainId: domainId,
                isSelfReview: false,
                isPublicReadOnly: true,
                opdId: state.pathParameters['opdId'],
                domain: switch (extra?['domain']) {
                  final AssessmentDomain value => value,
                  final Map<String, dynamic> value => AssessmentDomain.fromJson(
                    value,
                  ),
                  _ => null,
                },
                indicatorComparisons: indicatorComparisons,
              );
            },
            routes: [
              GoRoute(
                path: 'indicator/:indicatorId',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) {
                  final String activityId = state.pathParameters['activityId']!;
                  final String domainId = state.pathParameters['domainId']!;
                  final String indicatorId =
                      state.pathParameters['indicatorId']!;

                  final Map<String, dynamic>? extra =
                      state.extra as Map<String, dynamic>?;
                  final List<IndicatorComparisonData> comparisons =
                      ((extra?['comparisons'] as List<dynamic>?) ??
                              const <dynamic>[])
                          .map((dynamic item) {
                            if (item is IndicatorComparisonData) {
                              return item;
                            }
                            return IndicatorComparisonData.fromJson(
                              item as Map<String, dynamic>,
                            );
                          })
                          .toList();

                  return IndicatorReadOnlyReviewScreen(
                    activityId: activityId,
                    domainId: domainId,
                    indicatorId: indicatorId,
                    isPublicReadOnly: true,
                    opdId: state.pathParameters['opdId'],
                    data: switch (extra?['data']) {
                      final IndicatorComparisonData value => value,
                      final Map<String, dynamic> value =>
                        IndicatorComparisonData.fromJson(value),
                      _ => null,
                    },
                    indicatorComparisons: comparisons,
                    currentIndex: extra?['currentIndex'] as int? ?? 0,
                  );
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: RouteConstants.login,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainLayout(child: child),
        routes: [
          GoRoute(
            path: RouteConstants.home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: RouteConstants.notifications,
            builder: (context, state) => const NotificationListScreen(),
          ),
          GoRoute(
            path: RouteConstants.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: RouteConstants.changePassword,
            builder: (context, state) => const ChangePasswordScreen(),
          ),
          GoRoute(
            path: RouteConstants.editProfile,
            builder: (context, state) => const EditProfileScreen(),
          ),
          GoRoute(
            path: RouteConstants.dokumentasiKegiatan,
            builder: (context, state) => const DokumentasiListScreen(
              initialMode: DokumentasiMode.kegiatan,
            ),
          ),
          GoRoute(
            path: RouteConstants.pembinaan,
            builder: (context, state) => const DokumentasiListScreen(
              initialMode: DokumentasiMode.pembinaan,
            ),
          ),
          GoRoute(
            path: '/dokumentasi-kegiatan/:id',
            builder: (context, state) => DokumentasiDetailScreen(
              id: state.pathParameters['id']!,
              type: DokumentasiDetailType.kegiatan,
            ),
          ),
          GoRoute(
            path: '/dokumentasi-pembinaan/:id',
            builder: (context, state) => DokumentasiDetailScreen(
              id: state.pathParameters['id']!,
              type: DokumentasiDetailType.pembinaan,
            ),
          ),

          ...getAssessmentRoutes(),

          ...getAdminRoutes(),
        ],
      ),
    ],
  );
});

bool _isPublicRoute(String path) {
  return path == RouteConstants.landing || _publicAssessmentPath.hasMatch(path);
}

String _buildBootstrapLocation(Uri fromUri) {
  return Uri(
    path: RouteConstants.authBootstrap,
    queryParameters: <String, String>{'from': fromUri.toString()},
  ).toString();
}

String _fallbackLocationFor(AuthState authState) {
  return authState.status == AuthStatus.authenticated
      ? RouteConstants.home
      : RouteConstants.landing;
}

String _resolveBootstrapDestination({
  required AuthState authState,
  required Uri bootstrapUri,
}) {
  final String? fromRaw = bootstrapUri.queryParameters['from'];
  final Uri? fromUri = fromRaw == null ? null : Uri.tryParse(fromRaw);
  if (fromUri == null) {
    return _fallbackLocationFor(authState);
  }

  final String targetPath = fromUri.path.isEmpty
      ? RouteConstants.landing
      : fromUri.path;
  if (targetPath == RouteConstants.authBootstrap) {
    return _fallbackLocationFor(authState);
  }

  if (authState.status == AuthStatus.authenticated) {
    if (targetPath == RouteConstants.landing ||
        targetPath == RouteConstants.login ||
        _isPublicRoute(targetPath)) {
      return RouteConstants.home;
    }

    return fromUri.toString();
  }

  if (_isPublicRoute(targetPath) || targetPath == RouteConstants.login) {
    return fromUri.toString();
  }

  return RouteConstants.login;
}
