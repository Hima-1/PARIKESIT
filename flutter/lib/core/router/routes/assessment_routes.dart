import 'package:go_router/go_router.dart';
import 'package:parikesit/core/router/route_constants.dart';
import 'package:parikesit/features/assessment/domain/assessment_domain.dart';
import 'package:parikesit/features/assessment/domain/assessment_models.dart';
import 'package:parikesit/features/assessment/presentation/activity_details_screen.dart';
import 'package:parikesit/features/assessment/presentation/activity_review_screen.dart';
import 'package:parikesit/features/assessment/presentation/add_domain_screen.dart';
import 'package:parikesit/features/assessment/presentation/add_form_screen.dart';
import 'package:parikesit/features/assessment/presentation/domain_correction_list_screen.dart';
import 'package:parikesit/features/assessment/presentation/indicator_comparison_screen.dart';
import 'package:parikesit/features/assessment/presentation/indicator_detail_screen.dart';
import 'package:parikesit/features/assessment/presentation/indicator_read_only_review_screen.dart';
import 'package:parikesit/features/assessment/presentation/kegiatan_penilaian_screen.dart';
import 'package:parikesit/features/assessment/presentation/models/indicator_review_models.dart';
import 'package:parikesit/features/assessment/presentation/opd_comparison_summary_screen.dart';
import 'package:parikesit/features/assessment/presentation/opd_selection_screen.dart';
import 'package:parikesit/features/assessment/presentation/penilaian_mandiri_screen.dart';
import 'package:parikesit/features/assessment/presentation/penilaian_selesai_screen.dart';

List<RouteBase> getAssessmentRoutes() {
  return [
    GoRoute(
      path: RouteConstants.assessmentKegiatan,
      builder: (context, state) {
        final String? rawId = state.uri.queryParameters['formulirId'];
        final int formulirId = int.tryParse(rawId ?? '') ?? 0;
        return KegiatanPenilaianScreen(formulirId: formulirId);
      },
      routes: [
        GoRoute(
          path: 'indicator/:indicatorId',
          builder: (context, state) {
            final String? rawId = state.uri.queryParameters['formulirId'];
            final int formulirId = int.tryParse(rawId ?? '') ?? 0;
            final String indicatorName =
                state.uri.queryParameters['nama'] ?? 'Indikator';
            final int indicatorId =
                int.tryParse(state.pathParameters['indicatorId'] ?? '0') ?? 0;
            return IndicatorDetailScreen(
              formulirId: formulirId,
              indicatorId: indicatorId,
              indicatorName: indicatorName,
            );
          },
        ),
        GoRoute(
          path: 'tambah',
          builder: (context, state) => const AddFormScreen(),
        ),
        GoRoute(
          path: ':id/edit',
          builder: (context, state) {
            final AssessmentFormModel? activity =
                state.extra as AssessmentFormModel?;
            return AddFormScreen(formulir: activity);
          },
        ),
        GoRoute(
          path: ':id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return ActivityDetailsScreen(activityId: id);
          },
          routes: [
            GoRoute(
              path: 'tambah-domain',
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return AddDomainScreen(activityId: id);
              },
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: RouteConstants.assessmentMandiri,
      builder: (context, state) => const PenilaianMandiriScreen(),
    ),
    GoRoute(
      path: RouteConstants.assessmentSelesai,
      builder: (context, state) => const PenilaianSelesaiScreen(),
      routes: [
        GoRoute(
          path: ':activityId/summary',
          builder: (context, state) {
            final String activityId = state.pathParameters['activityId']!;
            return OpdComparisonSummaryScreen(
              activityId: activityId,
              activity: state.extra as AssessmentFormModel?,
            );
          },
        ),
        GoRoute(
          path: ':activityId',
          builder: (context, state) {
            final String activityId = state.pathParameters['activityId']!;
            final int? opdId = int.tryParse(
              state.pathParameters['opdId'] ?? '',
            );
            return ActivityReviewScreen(
              activityId: activityId,
              opdId: opdId,
              activity: state.extra as AssessmentFormModel?,
            );
          },
          routes: [
            GoRoute(
              path: 'domain/:domainId',
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
                  isSelfReview: true,
                  domain: switch (extra?['domain']) {
                    final AssessmentDomain value => value,
                    final Map<String, dynamic> value =>
                      AssessmentDomain.fromJson(value),
                    _ => null,
                  },
                  indicatorComparisons: indicatorComparisons,
                );
              },
              routes: [
                GoRoute(
                  path: 'indicator/:indicatorId',
                  builder: (context, state) {
                    final String activityId =
                        state.pathParameters['activityId']!;
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
            GoRoute(
              path: 'opds',
              builder: (context, state) {
                final String activityId = state.pathParameters['activityId']!;
                return OpdSelectionScreen(
                  activityId: activityId,
                  activity: state.extra as AssessmentFormModel?,
                );
              },
            ),
            GoRoute(
              path: 'opd/:opdId',
              builder: (context, state) {
                final String activityId = state.pathParameters['activityId']!;
                final int? opdId = int.tryParse(
                  state.pathParameters['opdId'] ?? '',
                );

                return ActivityReviewScreen(
                  activityId: activityId,
                  opdId: opdId,
                  activity: state.extra as AssessmentFormModel?,
                );
              },
              routes: [
                GoRoute(
                  path: 'domain/:domainId',
                  builder: (context, state) {
                    final String activityId =
                        state.pathParameters['activityId']!;
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
                      opdId: state.pathParameters['opdId'],
                      domain: switch (extra?['domain']) {
                        final AssessmentDomain value => value,
                        final Map<String, dynamic> value =>
                          AssessmentDomain.fromJson(value),
                        _ => null,
                      },
                      indicatorComparisons: indicatorComparisons,
                    );
                  },
                  routes: [
                    GoRoute(
                      path: 'indicator/:indicatorId',
                      builder: (context, state) {
                        final String activityId =
                            state.pathParameters['activityId']!;
                        final String domainId =
                            state.pathParameters['domainId']!;
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

                        return IndicatorReviewerScreen(
                          activityId: activityId,
                          domainId: domainId,
                          indicatorId: indicatorId,
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
          ],
        ),
      ],
    ),
  ];
}
