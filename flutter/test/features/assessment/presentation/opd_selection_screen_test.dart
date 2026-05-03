import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:parikesit/core/auth/user_role.dart';
import 'package:parikesit/core/network/paginated_response.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/features/assessment/data/assessment_repository.dart';
import 'package:parikesit/features/assessment/domain/assessment_disposisi.dart';
import 'package:parikesit/features/assessment/domain/assessment_models.dart';
import 'package:parikesit/features/assessment/domain/bukti_dukung.dart';
import 'package:parikesit/features/assessment/domain/comparison_summary_model.dart';
import 'package:parikesit/features/assessment/domain/completed_assessment_query.dart';
import 'package:parikesit/features/assessment/domain/opd_model.dart';
import 'package:parikesit/features/assessment/domain/penilaian.dart';
import 'package:parikesit/features/assessment/presentation/opd_selection_screen.dart';

void main() {
  testWidgets(
    'OpdSelectionScreen renders OPD list without deviation priority copy',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(900, 1400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            assessmentRepositoryProvider.overrideWithValue(
              _OpdSelectionRepository(),
            ),
            userRoleProvider.overrideWithValue(UserRole.admin),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const OpdSelectionScreen(activityId: '7'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(RefreshIndicator), findsOneWidget);
      expect(find.text('2 OPD'), findsOneWidget);
      expect(find.text('Halaman 1 dari 1'), findsOneWidget);
      expect(find.text('Lihat daftar OPD untuk evaluasi'), findsOneWidget);
      expect(find.text('Urutan standar'), findsOneWidget);
      expect(find.text('Nama OPD:'), findsWidgets);
      expect(find.text('Jabatan:'), findsWidgets);
      expect(find.text('Kontak:'), findsWidgets);
      expect(find.text('opd'), findsWidgets);
      expect(find.text('08123456789'), findsOneWidget);
      expect(find.text('PERLU PERHATIAN'), findsNothing);
      expect(find.textContaining('deviasi'), findsNothing);
      expect(find.textContaining('Gap'), findsNothing);

      final double zuluDy = tester.getTopLeft(find.text('Zulu')).dy;
      final double alphaDy = tester.getTopLeft(find.text('Alpha')).dy;

      expect(zuluDy, lessThan(alphaDy));
    },
  );

  testWidgets('walidata hero CTA opens comparison summary route', (
    WidgetTester tester,
  ) async {
    final GoRouter router = GoRouter(
      initialLocation: '/',
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return ProviderScope(
              overrides: [
                assessmentRepositoryProvider.overrideWithValue(
                  _OpdSelectionRepository(),
                ),
                userRoleProvider.overrideWithValue(UserRole.walidata),
              ],
              child: OpdSelectionScreen(
                activityId: '7',
                activity: AssessmentFormModel(
                  id: '7',
                  title: 'Evaluasi SPBE 2026',
                  date: DateTime(2026, 3, 14),
                  domains: const <DomainModel>[],
                ),
              ),
            );
          },
        ),
        GoRoute(
          path: '/penilaian-selesai/:activityId/summary',
          builder: (BuildContext context, GoRouterState state) =>
              Text('summary-${state.pathParameters['activityId']}'),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(find.text('Daftar OPD siap koreksi'), findsOneWidget);
    expect(
      find.text('Buka OPD yang sudah mengirim penilaian untuk mulai koreksi.'),
      findsOneWidget,
    );
    expect(find.text('Lihat ringkasan perbandingan'), findsOneWidget);

    await tester.tap(find.text('Lihat ringkasan perbandingan'));
    await tester.pumpAndSettle();

    expect(find.text('summary-7'), findsOneWidget);
  });

  testWidgets(
    'public OPD screen reuses shared hero card and keeps public route',
    (WidgetTester tester) async {
      final GoRouter router = GoRouter(
        initialLocation: '/',
        routes: <RouteBase>[
          GoRoute(
            path: '/',
            builder: (BuildContext context, GoRouterState state) {
              return ProviderScope(
                overrides: [
                  assessmentRepositoryProvider.overrideWithValue(
                    _OpdSelectionRepository(),
                  ),
                ],
                child: const Material(
                  child: OpdSelectionScreen(
                    activityId: '7',
                    isPublicReadOnly: true,
                  ),
                ),
              );
            },
          ),
          GoRoute(
            path: '/publik/penilaian-selesai/:activityId/opd/:opdId',
            builder: (BuildContext context, GoRouterState state) =>
                const Text('detail-route'),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(theme: AppTheme.lightTheme, routerConfig: router),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RefreshIndicator), findsOneWidget);
      expect(find.text('Lihat skor akhir per OPD'), findsOneWidget);
      expect(find.text('Read-only'), findsOneWidget);
      expect(find.text('Lihat rincian publik'), findsWidgets);
      expect(find.text('Nama OPD:'), findsNothing);
      expect(find.text('Jabatan:'), findsWidgets);
      expect(find.text('Kontak:'), findsWidgets);
      expect(find.text('HASIL AKHIR PUBLIK'), findsNothing);
      expect(find.text('SKOR FINAL TERSEDIA'), findsWidgets);
      expect(find.text('MENUNGGU TINJAUAN'), findsNothing);
      expect(find.text('SELESAI'), findsNothing);
      expect(find.text('3.80'), findsWidgets);
      expect(
        tester.widget<Scaffold>(find.byType(Scaffold)).backgroundColor,
        AppTheme.merang,
      );

      await tester.tap(
        find
            .ancestor(
              of: find.text('Lihat rincian publik').first,
              matching: find.byType(InkWell),
            )
            .first,
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();

      expect(find.text('detail-route'), findsOneWidget);
    },
  );

  testWidgets('walidata status follows correction progress counts', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(900, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          assessmentRepositoryProvider.overrideWithValue(
            _OpdSelectionRepository(
              opds: const <OpdModel>[
                OpdModel(
                  id: 1,
                  name: 'Menunggu',
                  role: 'opd',
                  totalIndicators: 5,
                  opdScore: 3,
                  walidataProgress: OpdProgress(count: 0, percentage: 0),
                ),
                OpdModel(
                  id: 2,
                  name: 'Parsial',
                  role: 'opd',
                  totalIndicators: 5,
                  opdScore: 3,
                  walidataScore: 3.4,
                  walidataProgress: OpdProgress(count: 1, percentage: 20),
                ),
                OpdModel(
                  id: 3,
                  name: 'Lengkap',
                  role: 'opd',
                  totalIndicators: 5,
                  opdScore: 3,
                  walidataScore: 3.4,
                  walidataProgress: OpdProgress(count: 5, percentage: 100),
                ),
              ],
            ),
          ),
          userRoleProvider.overrideWithValue(UserRole.walidata),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const OpdSelectionScreen(activityId: '7'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('MENUNGGU TINJAUAN'), findsOneWidget);
    expect(find.text('BELUM LENGKAP (1/5)'), findsOneWidget);
    expect(find.text('SELESAI'), findsOneWidget);
    expect(find.text('SUDAH DITINJAU'), findsNothing);
  });

  testWidgets('admin status uses admin progress instead of admin score', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(900, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          assessmentRepositoryProvider.overrideWithValue(
            _OpdSelectionRepository(
              opds: const <OpdModel>[
                OpdModel(
                  id: 1,
                  name: 'Parsial',
                  role: 'opd',
                  totalIndicators: 5,
                  opdScore: 3,
                  walidataScore: 3.4,
                  adminScore: 3.8,
                  adminProgress: OpdProgress(count: 1, percentage: 20),
                ),
                OpdModel(
                  id: 2,
                  name: 'Lengkap',
                  role: 'opd',
                  totalIndicators: 5,
                  opdScore: 3,
                  walidataScore: 3.4,
                  adminScore: 3.8,
                  adminProgress: OpdProgress(count: 5, percentage: 100),
                ),
              ],
            ),
          ),
          userRoleProvider.overrideWithValue(UserRole.admin),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const OpdSelectionScreen(activityId: '7'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('BELUM LENGKAP (1/5)'), findsOneWidget);
    expect(find.text('SELESAI'), findsOneWidget);
  });

  testWidgets('pagination footer loads next OPD page', (
    WidgetTester tester,
  ) async {
    final repository = _OpdSelectionRepository(
      opds: const <OpdModel>[
        OpdModel(id: 1, name: 'Alpha', role: 'opd', opdScore: 3),
        OpdModel(id: 2, name: 'Beta', role: 'opd', opdScore: 3),
      ],
      paginatedPerPage: 1,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          assessmentRepositoryProvider.overrideWithValue(repository),
          userRoleProvider.overrideWithValue(UserRole.admin),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const OpdSelectionScreen(activityId: '7'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Alpha'), findsOneWidget);
    expect(find.text('Beta'), findsNothing);
    expect(find.text('Halaman 1 dari 2'), findsOneWidget);

    await tester.tap(find.byTooltip('Halaman berikutnya'));
    await tester.pumpAndSettle();

    expect(find.text('Alpha'), findsNothing);
    expect(find.text('Beta'), findsOneWidget);
    expect(find.text('Halaman 2 dari 2'), findsOneWidget);
    expect(repository.requestedPages, <int>[1, 2]);
  });
}

class _OpdSelectionRepository extends AssessmentRepositoryImpl {
  _OpdSelectionRepository({
    List<OpdModel>? opds,
    List<OpdModel>? publicOpds,
    this.paginatedPerPage,
  }) : _opds = opds ?? _defaultOpds,
       _publicOpds = publicOpds ?? _defaultPublicOpds,
       super(Dio());

  final List<OpdModel> _opds;
  final List<OpdModel> _publicOpds;
  final int? paginatedPerPage;
  final List<int> requestedPages = <int>[];

  static const List<OpdModel> _defaultOpds = <OpdModel>[
    OpdModel(
      id: 2,
      name: 'Zulu',
      role: 'opd',
      nomorTelepon: '08123456789',
      opdScore: 3.0,
      walidataScore: 3.4,
      adminScore: 3.8,
      totalIndicators: 5,
      walidataProgress: OpdProgress(count: 5, percentage: 100),
      adminProgress: OpdProgress(count: 5, percentage: 100),
    ),
    OpdModel(
      id: 1,
      name: 'Alpha',
      role: 'opd',
      nomorTelepon: '08111111111',
      opdScore: 4.0,
      walidataScore: 4.2,
      adminScore: 4.4,
      totalIndicators: 5,
      walidataProgress: OpdProgress(count: 5, percentage: 100),
      adminProgress: OpdProgress(count: 5, percentage: 100),
    ),
  ];

  static const List<OpdModel> _defaultPublicOpds = <OpdModel>[
    OpdModel(
      id: 2,
      name: 'Zulu',
      role: 'opd',
      nomorTelepon: '08123456789',
      opdScore: 3.0,
      walidataScore: 3.4,
      adminScore: 3.8,
    ),
    OpdModel(
      id: 1,
      name: 'Alpha',
      role: 'opd',
      nomorTelepon: '08111111111',
      opdScore: 4.0,
      walidataScore: 4.2,
      adminScore: 4.4,
    ),
  ];

  @override
  Future<AssessmentFormModel> addActivity(
    AssessmentFormModel activity, {
    bool useTemplate = true,
  }) async => activity;

  @override
  Future<void> addDomain(
    String activityId,
    String domainName,
    List<String> aspects,
  ) async {}

  @override
  Future<AssessmentFormModel> updateActivity(
    int formulirId,
    String name,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteActivity(int formulirId) async {}

  @override
  Future<List<AssessmentFormModel>> getActivities() async =>
      <AssessmentFormModel>[];

  @override
  Future<PaginatedResponse<AssessmentFormModel>> getActivitiesPage({
    int page = 1,
    int perPage = 15,
  }) async => PaginatedResponse<AssessmentFormModel>(
    data: await getActivities(),
    meta: PaginationMeta(
      currentPage: page,
      lastPage: 1,
      perPage: perPage,
      total: 0,
      from: null,
      to: null,
      path: '/formulir',
    ),
    links: const PaginationLinks(
      first: '/formulir?page=1',
      last: '/formulir?page=1',
    ),
  );

  @override
  Future<PaginatedResponse<AssessmentFormModel>> getCompletedActivities({
    CompletedAssessmentQuery query = const CompletedAssessmentQuery(),
  }) async => const PaginatedResponse<AssessmentFormModel>(
    data: <AssessmentFormModel>[],
    meta: PaginationMeta(
      currentPage: 1,
      lastPage: 1,
      perPage: 15,
      total: 0,
      from: null,
      to: null,
      path: '/penilaian-selesai',
    ),
    links: PaginationLinks(
      first: '/penilaian-selesai?page=1',
      last: '/penilaian-selesai?page=1',
    ),
  );

  @override
  Future<PaginatedResponse<AssessmentFormModel>> getPublicCompletedActivities({
    CompletedAssessmentQuery query = const CompletedAssessmentQuery(),
  }) async => getCompletedActivities(query: query);

  @override
  Future<List<OpdModel>> getPublicOpdsForActivity(String activityId) async =>
      _publicOpds;

  @override
  Future<List<ComparisonSummaryModel>> getComparisonSummary(
    String activityId,
  ) async => <ComparisonSummaryModel>[];

  @override
  Future<List<AssessmentDisposisi>> getDisposisiTrail(int formulirId) async =>
      <AssessmentDisposisi>[];

  @override
  Future<AssessmentFormModel> getFormulir(int id) async =>
      throw UnimplementedError();

  @override
  Future<(AssessmentFormModel, Map<int, Penilaian>)> getIndicatorsForOpd(
    int activityId,
    int opdId,
  ) async => throw UnimplementedError();

  @override
  Future<(AssessmentFormModel, Map<int, Penilaian>)> getPublicIndicatorsForOpd(
    int activityId,
    int opdId,
  ) async => throw UnimplementedError();

  @override
  Future<(AssessmentFormModel, Map<int, Penilaian>)> getMyPenilaians(
    int formulirId,
  ) async => throw UnimplementedError();

  @override
  Future<Map<String, double?>> getOpdStats(int activityId, int opdId) async =>
      <String, double?>{'opd': null, 'walidata': null, 'admin': null};

  @override
  Future<Map<String, RoleScore>> getOpdDomainScores(
    int activityId,
    int opdId,
  ) async => <String, RoleScore>{};

  @override
  Future<List<OpdModel>> getOpdsForActivity(String activityId) async => _opds;

  @override
  Future<PaginatedResponse<OpdModel>> getOpdsForActivityPage(
    String activityId, {
    int page = 1,
    int perPage = 10,
  }) async {
    requestedPages.add(page);
    return _pageFor(
      _opds,
      activityId: activityId,
      page: page,
      perPage: paginatedPerPage ?? perPage,
      pathPrefix: '/penilaian-selesai',
    );
  }

  @override
  Future<PaginatedResponse<OpdModel>> getPublicOpdsForActivityPage(
    String activityId, {
    int page = 1,
    int perPage = 10,
  }) async {
    requestedPages.add(page);
    return _pageFor(
      _publicOpds,
      activityId: activityId,
      page: page,
      perPage: paginatedPerPage ?? perPage,
      pathPrefix: '/public/penilaian-selesai',
    );
  }

  PaginatedResponse<OpdModel> _pageFor(
    List<OpdModel> source, {
    required String activityId,
    required int page,
    required int perPage,
    required String pathPrefix,
  }) {
    final start = (page - 1) * perPage;
    final items = source.skip(start).take(perPage).toList();
    final lastPage = (source.length / perPage).ceil().clamp(1, 9999);
    final path = '$pathPrefix/$activityId/opds';
    return PaginatedResponse<OpdModel>(
      data: items,
      meta: PaginationMeta(
        currentPage: page,
        lastPage: lastPage,
        perPage: perPage,
        total: source.length,
        from: items.isEmpty ? null : start + 1,
        to: items.isEmpty ? null : start + items.length,
        path: path,
      ),
      links: PaginationLinks(
        first: '$path?page=1',
        last: '$path?page=$lastPage',
      ),
    );
  }

  @override
  Future<AssessmentDisposisi> submitDisposisi(
    int formulirId,
    Map<String, dynamic> data,
  ) async => throw UnimplementedError();

  @override
  Future<Penilaian> submitAdminEvaluation(
    int assessmentId,
    Map<String, dynamic> data,
  ) async => throw UnimplementedError();

  @override
  Future<Penilaian> submitPenilaian(
    int formulirId,
    int indikatorId,
    Map<String, dynamic> data,
  ) async => throw UnimplementedError();

  @override
  Future<Penilaian> submitWalidataCorrection(
    int assessmentId,
    Map<String, dynamic> data,
  ) async => throw UnimplementedError();

  @override
  Future<BuktiDukung> uploadBuktiDukung(
    int penilaianId,
    String filePath,
  ) async => throw UnimplementedError();
}
