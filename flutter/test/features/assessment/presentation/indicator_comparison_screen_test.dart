import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:parikesit/core/auth/user_role.dart';
import 'package:parikesit/core/router/route_constants.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/features/assessment/domain/assessment_domain.dart';
import 'package:parikesit/features/assessment/domain/assessment_indikator.dart';
import 'package:parikesit/features/assessment/domain/assessment_models.dart';
import 'package:parikesit/features/assessment/domain/penilaian.dart';
import 'package:parikesit/features/assessment/presentation/controller/assessment_controller.dart';
import 'package:parikesit/features/assessment/presentation/domain_correction_list_screen.dart';
import 'package:parikesit/features/assessment/presentation/helpers/indicator_review_resolver.dart';
import 'package:parikesit/features/assessment/presentation/helpers/review_route_context.dart';
import 'package:parikesit/features/assessment/presentation/indicator_comparison_screen.dart';
import 'package:parikesit/features/assessment/presentation/indicator_read_only_review_screen.dart';
import 'package:parikesit/features/assessment/presentation/models/indicator_review_models.dart';

void main() {
  test(
    'resolveIndicatorComparisonData prefers fresh form-state criteria over stale route data',
    () {
      final IndicatorComparisonData staleRouteData = _staleComparisonData(
        includeCriteria: false,
      );
      final AssessmentFormState freshState = AssessmentFormState(
        formulirId: 12,
        formulir: _formWithFreshCriteria(),
        draftsByIndikatorId: const <int, Penilaian>{
          382: Penilaian(
            id: 6,
            formulirId: 12,
            indikatorId: 382,
            nilai: 4,
            nilaiDiupdate: 3,
            catatanKoreksi: 'Catatan live walidata',
          ),
        },
      );

      final IndicatorComparisonData? resolved = resolveIndicatorComparisonData(
        indicatorId: '382',
        routeData: staleRouteData,
        snapshots: <IndicatorComparisonData>[staleRouteData],
        formState: freshState,
      );

      expect(resolved, isNotNull);
      expect(resolved!.indikator.level1Kriteria, 'Kriteria terbaru level 1');
      expect(resolved.indikator.level5Kriteria, 'Kriteria terbaru level 5');
      expect(
        resolved.indikator.effectiveLevelKriteria(1),
        'Kriteria terbaru level 1',
      );
      expect(resolved.walidataScore, 3);
      expect(resolved.evaluationNotes.single.note, 'Catatan live walidata');
    },
  );

  testWidgets(
    'IndicatorReviewerScreen prefers live provider values over stale route snapshot',
    (WidgetTester tester) async {
      final ProviderContainer container = ProviderContainer(
        overrides: [
          userRoleProvider.overrideWithValue(UserRole.walidata),
          assessmentFormControllerProvider(12).overrideWith(
            () => _TestAssessmentFormController(
              const AssessmentFormState(
                formulirId: 12,
                draftsByIndikatorId: <int, Penilaian>{
                  382: Penilaian(
                    id: 6,
                    formulirId: 12,
                    indikatorId: 382,
                    nilai: 4,
                    catatan: 'Catatan OPD',
                  ),
                },
              ),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: IndicatorReviewerScreen(
              activityId: '12',
              domainId: '10',
              indicatorId: '382',
              opdId: '77',
              data: _staleComparisonData(),
              indicatorComparisons: <IndicatorComparisonData>[
                _staleComparisonData(),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Catatan live walidata'), findsNothing);
      expect(find.text('Perlu validasi akhir'), findsNothing);
      expect(find.text('Perbandingan skor stabil'), findsNothing);
      expect(find.text('DEVIASI BESAR'), findsNothing);

      final _TestAssessmentFormController controller =
          container.read(assessmentFormControllerProvider(12).notifier)
              as _TestAssessmentFormController;
      controller.replaceDraft(
        const Penilaian(
          id: 6,
          formulirId: 12,
          indikatorId: 382,
          nilai: 4,
          catatan: 'Catatan OPD',
          nilaiDiupdate: 3,
          catatanKoreksi: 'Catatan live walidata',
          buktiDukung: <String>['bukti-dukung/live-bukti.pdf'],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('3.00'), findsOneWidget);
      expect(find.text('Tingkat Kriteria'), findsOneWidget);
      expect(find.text('KODE INDIKATOR 30101'), findsOneWidget);
      expect(find.text('Domain A > Aspek A'), findsOneWidget);
      expect(find.byType(ExpansionTile), findsNWidgets(5));
      expect(find.text('Catatan live walidata'), findsOneWidget);
      expect(find.text('live-bukti.pdf'), findsOneWidget);
      expect(find.text('Belum ada bukti dukung yang diunggah.'), findsNothing);
      expect(
        find.text('Belum ada catatan evaluasi dari Walidata.'),
        findsNothing,
      );
    },
  );

  testWidgets(
    'DomainCorrectionListScreen refreshes list scores when provider state changes',
    (WidgetTester tester) async {
      final ProviderContainer container = ProviderContainer(
        overrides: [
          assessmentFormControllerProvider(12).overrideWith(
            () => _TestAssessmentFormController(
              const AssessmentFormState(
                formulirId: 12,
                draftsByIndikatorId: <int, Penilaian>{
                  382: Penilaian(
                    id: 6,
                    formulirId: 12,
                    indikatorId: 382,
                    nilai: 4,
                  ),
                },
              ),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: DomainCorrectionListScreen(
              activityId: '12',
              domainId: '10',
              isSelfReview: false,
              domain: _domain(),
              indicatorComparisons: <IndicatorComparisonData>[
                _staleComparisonData(),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('0.00'), findsNWidgets(2));

      final _TestAssessmentFormController controller =
          container.read(assessmentFormControllerProvider(12).notifier)
              as _TestAssessmentFormController;
      controller.replaceDraft(
        const Penilaian(
          id: 6,
          formulirId: 12,
          indikatorId: 382,
          nilai: 4,
          nilaiDiupdate: 3,
          catatanKoreksi: 'Sinkron',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('3.00'), findsOneWidget);
    },
  );

  testWidgets(
    'DomainCorrectionListScreen uses public light background in public read-only mode',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: DomainCorrectionListScreen(
              activityId: '12',
              domainId: '10',
              isSelfReview: false,
              isPublicReadOnly: true,
              opdId: '77',
              domain: _domain(),
              indicatorComparisons: <IndicatorComparisonData>[
                _staleComparisonData(),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        tester.widget<Scaffold>(find.byType(Scaffold)).backgroundColor,
        AppTheme.merang,
      );
    },
  );

  testWidgets(
    'IndicatorReadOnlyReviewScreen keeps OPD self review in read-only mode',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [userRoleProvider.overrideWithValue(UserRole.opd)],
          child: MaterialApp(
            home: IndicatorReadOnlyReviewScreen(
              activityId: '12',
              domainId: '10',
              indicatorId: '382',
              data: _staleComparisonData(),
              indicatorComparisons: <IndicatorComparisonData>[
                _staleComparisonData(),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('SIMPAN KOREKSI'), findsNothing);
      expect(find.text('SIMPAN EVALUASI'), findsNothing);
      expect(find.text('BERI KOREKSI'), findsNothing);
      expect(find.text('EVALUASI FINAL'), findsNothing);
      expect(find.text('Catatan Evaluasi per Peran'), findsOneWidget);
    },
  );

  testWidgets(
    'IndicatorReadOnlyReviewScreen uses public light background in public read-only mode',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: IndicatorReadOnlyReviewScreen(
              activityId: '12',
              domainId: '10',
              indicatorId: '382',
              isPublicReadOnly: true,
              opdId: '77',
              data: _staleComparisonData(),
              indicatorComparisons: <IndicatorComparisonData>[
                _staleComparisonData(),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        tester.widget<Scaffold>(find.byType(Scaffold)).backgroundColor,
        AppTheme.merang,
      );
    },
  );

  testWidgets(
    'IndicatorReviewerScreen opens audit form on demand and saves walidata correction',
    (WidgetTester tester) async {
      final ProviderContainer container = ProviderContainer(
        overrides: [
          userRoleProvider.overrideWithValue(UserRole.walidata),
          assessmentFormControllerProvider(12).overrideWith(
            () => _TestAssessmentFormController(
              const AssessmentFormState(
                formulirId: 12,
                draftsByIndikatorId: <int, Penilaian>{
                  382: Penilaian(
                    id: 6,
                    formulirId: 12,
                    indikatorId: 382,
                    nilai: 4,
                    catatan: 'Catatan OPD',
                  ),
                },
              ),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: IndicatorReviewerScreen(
              activityId: '12',
              domainId: '10',
              indicatorId: '382',
              opdId: '77',
              data: _staleComparisonData(),
              indicatorComparisons: <IndicatorComparisonData>[
                _staleComparisonData(),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Catatan Koreksi Walidata'), findsNothing);
      expect(find.text('BERI KOREKSI'), findsOneWidget);

      await tester.tap(find.text('BERI KOREKSI'));
      await tester.pumpAndSettle();

      expect(find.text('INDIKATOR 30101'), findsOneWidget);
      expect(find.text('Indikator Sinkron'), findsWidgets);
      expect(find.text('Domain A > Aspek A'), findsWidgets);
      expect(find.text('Catatan Koreksi Walidata'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'Perlu sinkronisasi');
      await tester.tap(find.text('SIMPAN KOREKSI'));
      await tester.pumpAndSettle();

      final _TestAssessmentFormController controller =
          container.read(assessmentFormControllerProvider(12).notifier)
              as _TestAssessmentFormController;
      expect(controller.walidataSaveCalls, 1);
      expect(controller.lastWalidataScore, 1);
      expect(controller.lastWalidataNote, 'Perlu sinkronisasi');
      expect(find.text('Catatan Koreksi Walidata'), findsNothing);
      expect(find.byType(SnackBar), findsOneWidget);
    },
  );

  testWidgets(
    'IndicatorReviewerScreen loads selected OPD data before admin evaluation',
    (WidgetTester tester) async {
      final _TestAssessmentFormController controller =
          _TestAssessmentFormController(
              const AssessmentFormState(formulirId: 12),
            )
            ..penilaianAfterLoad = const Penilaian(
              id: 6,
              formulirId: 12,
              indikatorId: 382,
              nilai: 4,
              catatan: 'Catatan OPD',
              nilaiDiupdate: 4,
              catatanKoreksi: 'Catatan live walidata',
            );
      final ProviderContainer container = ProviderContainer(
        overrides: [
          userRoleProvider.overrideWithValue(UserRole.admin),
          assessmentFormControllerProvider(12).overrideWith(() => controller),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: IndicatorReviewerScreen(
              activityId: '12',
              domainId: '10',
              indicatorId: '382',
              opdId: '77',
              data: _staleComparisonData(walidataScore: 4),
              indicatorComparisons: <IndicatorComparisonData>[
                _staleComparisonData(walidataScore: 4),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(controller.loadIndicatorsForOpdCalls, 1);
      expect(controller.lastLoadedOpdId, 77);
      expect(find.text('EVALUASI FINAL'), findsOneWidget);

      await tester.tap(find.text('EVALUASI FINAL'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Final BPS');
      await tester.tap(find.text('SIMPAN EVALUASI'));
      await tester.pumpAndSettle();

      expect(controller.adminSaveCalls, 1);
      expect(controller.lastAdminScore, 1);
      expect(controller.lastAdminNote, 'Final BPS');
      expect(find.text('Catatan Evaluasi Final'), findsNothing);
      expect(find.byType(SnackBar), findsOneWidget);
    },
  );

  testWidgets('IndicatorReviewerScreen save failure shows friendly feedback', (
    WidgetTester tester,
  ) async {
    final ProviderContainer container = ProviderContainer(
      overrides: [
        userRoleProvider.overrideWithValue(UserRole.walidata),
        assessmentFormControllerProvider(12).overrideWith(
          () => _ThrowingAssessmentFormController(
            const AssessmentFormState(
              formulirId: 12,
              draftsByIndikatorId: <int, Penilaian>{
                382: Penilaian(
                  id: 6,
                  formulirId: 12,
                  indikatorId: 382,
                  nilai: 4,
                  catatan: 'Catatan OPD',
                ),
              },
            ),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: IndicatorReviewerScreen(
            activityId: '12',
            domainId: '10',
            indicatorId: '382',
            opdId: '77',
            data: _staleComparisonData(),
            indicatorComparisons: <IndicatorComparisonData>[
              _staleComparisonData(),
            ],
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.text('BERI KOREKSI'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Perlu sinkronisasi');
    await tester.tap(find.text('SIMPAN KOREKSI'));
    await tester.pumpAndSettle();

    expect(
      find.text('Gagal menyimpan penilaian. Silakan coba lagi.'),
      findsOneWidget,
    );
    expect(find.textContaining('Exception'), findsNothing);
    expect(find.textContaining('database failed'), findsNothing);
  });

  testWidgets(
    'cross-OPD indicator navigation keeps opdId when moving to next indicator',
    (WidgetTester tester) async {
      final List<IndicatorComparisonData> comparisons =
          <IndicatorComparisonData>[
            _staleComparisonData(),
            _secondComparisonData(),
          ];

      final GoRouter router = GoRouter(
        initialLocation: RouteConstants.buildAssessmentIndicatorPath(
          activityId: '12',
          domainId: '10',
          indicatorId: '382',
          opdId: '77',
          isSelfReview: false,
        ),
        routes: <RouteBase>[
          GoRoute(
            path: RouteConstants.assessmentIndicatorComparison,
            builder: (BuildContext context, GoRouterState state) {
              final String indicatorId = state.pathParameters['indicatorId']!;
              final Map<String, dynamic>? extra =
                  state.extra as Map<String, dynamic>?;
              final List<IndicatorComparisonData> routeComparisons =
                  ((extra?['comparisons'] as List<dynamic>?) ??
                          comparisons.cast<dynamic>())
                      .map((dynamic item) {
                        if (item is IndicatorComparisonData) {
                          return item;
                        }
                        return IndicatorComparisonData.fromJson(
                          item as Map<String, dynamic>,
                        );
                      })
                      .toList(growable: false);

              final IndicatorComparisonData currentData = routeComparisons
                  .firstWhere(
                    (IndicatorComparisonData item) =>
                        item.indikator.id.toString() == indicatorId,
                    orElse: _staleComparisonData,
                  );

              return IndicatorReviewerScreen(
                activityId: state.pathParameters['activityId']!,
                domainId: state.pathParameters['domainId']!,
                indicatorId: indicatorId,
                opdId: state.pathParameters['opdId'],
                data: switch (extra?['data']) {
                  final IndicatorComparisonData value => value,
                  final Map<String, dynamic> value =>
                    IndicatorComparisonData.fromJson(value),
                  _ => currentData,
                },
                indicatorComparisons: routeComparisons,
                currentIndex: extra?['currentIndex'] as int? ?? 0,
              );
            },
          ),
        ],
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [userRoleProvider.overrideWithValue(UserRole.walidata)],
          child: MaterialApp.router(routerConfig: router),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        router.routeInformationProvider.value.uri.toString(),
        '/penilaian-selesai/12/opd/77/domain/10/indicator/382',
      );

      await tester.tap(find.text('SELANJUTNYA'));
      await tester.pumpAndSettle();

      expect(
        router.routeInformationProvider.value.uri.toString(),
        '/penilaian-selesai/12/opd/77/domain/10/indicator/383',
      );
      expect(find.text('KODE INDIKATOR 30102'), findsOneWidget);
      expect(find.text('Indikator Lanjutan'), findsOneWidget);
    },
  );

  testWidgets(
    'DomainCorrectionListScreen resolves router opdId without showing missing-context banner',
    (WidgetTester tester) async {
      final GoRouter router = GoRouter(
        initialLocation: '/penilaian-selesai/12/opd/77/domain/10',
        routes: <RouteBase>[
          GoRoute(
            path: RouteConstants.assessmentDomainCorrection,
            builder: (BuildContext context, GoRouterState state) =>
                DomainCorrectionListScreen(
                  activityId: state.pathParameters['activityId']!,
                  domainId: state.pathParameters['domainId']!,
                  isSelfReview: false,
                  domain: _domain(),
                  indicatorComparisons: <IndicatorComparisonData>[
                    _staleComparisonData(),
                  ],
                ),
            routes: <RouteBase>[
              GoRoute(
                path: 'indicator/:indicatorId',
                builder: (BuildContext context, GoRouterState state) =>
                    Text('indicator-${state.pathParameters['opdId']}'),
              ),
            ],
          ),
        ],
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [userRoleProvider.overrideWithValue(UserRole.walidata)],
          child: MaterialApp.router(routerConfig: router),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text(missingReviewOpdContextMessage), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'DomainCorrectionListScreen shows safe feedback when opdId is missing',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: DomainCorrectionListScreen(
              activityId: '12',
              domainId: '10',
              isSelfReview: false,
              domain: _domain(),
              indicatorComparisons: <IndicatorComparisonData>[
                _staleComparisonData(),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text(missingReviewOpdContextMessage), findsOneWidget);

      await tester.tap(find.byType(Card).last);
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'IndicatorReviewerScreen shows safe feedback when opdId is missing',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: IndicatorReviewerScreen(
              activityId: '12',
              domainId: '10',
              indicatorId: '382',
              data: _staleComparisonData(),
              indicatorComparisons: <IndicatorComparisonData>[
                _staleComparisonData(),
                _secondComparisonData(),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text(missingReviewOpdContextMessage), findsOneWidget);

      await tester.tap(find.text('SELANJUTNYA'));
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}

IndicatorComparisonData _staleComparisonData({
  bool includeCriteria = true,
  double walidataScore = 0,
}) {
  return IndicatorComparisonData(
    indikator: AssessmentIndikator(
      id: 382,
      aspekId: 77,
      kodeIndikator: '30101',
      namaIndikator: 'Indikator Sinkron',
      namaDomain: 'Domain A',
      namaAspek: 'Aspek A',
      bobotIndikator: 100,
      level1Kriteria: includeCriteria ? 'Kriteria level 1' : null,
      level2Kriteria: includeCriteria ? 'Kriteria level 2' : null,
      level3Kriteria: includeCriteria ? 'Kriteria level 3' : null,
      level4Kriteria: includeCriteria ? 'Kriteria level 4' : null,
      level5Kriteria: includeCriteria ? 'Kriteria level 5' : null,
    ),
    opdScore: 4,
    walidataScore: walidataScore,
    adminScore: 0,
    namaAspek: 'Aspek A',
  );
}

AssessmentFormModel _formWithFreshCriteria() {
  return AssessmentFormModel(
    id: '12',
    title: 'Formulir Live',
    date: DateTime(2026, 3, 13),
    domains: <DomainModel>[
      DomainModel(
        id: '10',
        name: 'Domain A',
        date: DateTime(2026, 3, 15),
        indicatorCount: 1,
        aspects: const <AspectModel>[
          AspectModel(
            id: '77',
            name: 'Aspek A',
            indicators: <IndicatorModel>[
              IndicatorModel(
                id: '382',
                name: 'Indikator Sinkron',
                kodeIndikator: '30101',
                bobotIndikator: 100,
                level1Kriteria: 'Kriteria terbaru level 1',
                level2Kriteria: 'Kriteria terbaru level 2',
                level3Kriteria: 'Kriteria terbaru level 3',
                level4Kriteria: 'Kriteria terbaru level 4',
                level5Kriteria: 'Kriteria terbaru level 5',
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

AssessmentDomain _domain() {
  return const AssessmentDomain(
    id: 10,
    namaDomain: 'Domain A',
    bobotDomain: 20,
  );
}

IndicatorComparisonData _secondComparisonData() {
  return const IndicatorComparisonData(
    indikator: AssessmentIndikator(
      id: 383,
      aspekId: 77,
      kodeIndikator: '30102',
      namaIndikator: 'Indikator Lanjutan',
      namaDomain: 'Domain A',
      namaAspek: 'Aspek A',
      bobotIndikator: 100,
      level1Kriteria: 'Kriteria level 1B',
      level2Kriteria: 'Kriteria level 2B',
      level3Kriteria: 'Kriteria level 3B',
      level4Kriteria: 'Kriteria level 4B',
      level5Kriteria: 'Kriteria level 5B',
    ),
    opdScore: 2,
    walidataScore: 0,
    adminScore: 0,
    namaAspek: 'Aspek A',
  );
}

class _TestAssessmentFormController extends AssessmentFormController {
  _TestAssessmentFormController(this._initialState) : super(12);

  final AssessmentFormState _initialState;
  int walidataSaveCalls = 0;
  int adminSaveCalls = 0;
  double? lastWalidataScore;
  String? lastWalidataNote;
  double? lastAdminScore;
  String? lastAdminNote;
  int loadIndicatorsForOpdCalls = 0;
  int? lastLoadedOpdId;
  Penilaian? penilaianAfterLoad;

  @override
  Future<AssessmentFormState> build() async => _initialState;

  void replaceDraft(Penilaian penilaian) {
    final AssessmentFormState current = state.value ?? _initialState;
    state = AsyncData<AssessmentFormState>(
      current.copyWith(
        draftsByIndikatorId: <int, Penilaian>{
          ...current.draftsByIndikatorId,
          penilaian.indikatorId: penilaian,
        },
      ),
    );
  }

  @override
  Future<void> loadIndicatorsForOpd(int opdId) async {
    loadIndicatorsForOpdCalls += 1;
    lastLoadedOpdId = opdId;
    final Penilaian? loaded = penilaianAfterLoad;
    if (loaded != null) {
      replaceDraft(loaded);
    }
  }

  @override
  Future<void> saveWalidataCorrection({
    required int indicatorId,
    required double score,
    String? note,
  }) async {
    walidataSaveCalls += 1;
    lastWalidataScore = score;
    lastWalidataNote = note;

    final AssessmentFormState current = state.value ?? _initialState;
    final Penilaian existing = current.draftsByIndikatorId[indicatorId]!;
    replaceDraft(existing.copyWith(nilaiDiupdate: score, catatanKoreksi: note));
  }

  @override
  Future<void> saveAdminEvaluation({
    required int indicatorId,
    required double score,
    String? note,
  }) async {
    adminSaveCalls += 1;
    lastAdminScore = score;
    lastAdminNote = note;

    final AssessmentFormState current = state.value ?? _initialState;
    final Penilaian existing = current.draftsByIndikatorId[indicatorId]!;
    replaceDraft(existing.copyWith(nilaiKoreksi: score, evaluasi: note));
  }
}

class _ThrowingAssessmentFormController extends _TestAssessmentFormController {
  _ThrowingAssessmentFormController(super.initialState);

  @override
  Future<void> saveWalidataCorrection({
    required int indicatorId,
    required double score,
    String? note,
  }) async {
    throw Exception('database failed');
  }
}
