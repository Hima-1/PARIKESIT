import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:parikesit/core/network/paginated_response.dart';
import 'package:parikesit/core/router/route_constants.dart';
import 'package:parikesit/core/storage/token_storage.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/features/assessment/data/assessment_repository.dart';
import 'package:parikesit/features/assessment/domain/assessment_disposisi.dart';
import 'package:parikesit/features/assessment/domain/assessment_models.dart';
import 'package:parikesit/features/assessment/domain/bukti_dukung.dart';
import 'package:parikesit/features/assessment/domain/comparison_summary_model.dart';
import 'package:parikesit/features/assessment/domain/completed_assessment_query.dart';
import 'package:parikesit/features/assessment/domain/opd_model.dart';
import 'package:parikesit/features/assessment/domain/penilaian.dart';
import 'package:parikesit/features/auth/data/auth_api_client.dart';
import 'package:parikesit/features/auth/data/auth_repository.dart';
import 'package:parikesit/features/auth/domain/login_response.dart';
import 'package:parikesit/features/auth/domain/user.dart';
import 'package:parikesit/features/auth/presentation/controller/auth_provider.dart';
import 'package:parikesit/features/public/presentation/landing_public_screen.dart';
import 'package:parikesit/features/public/presentation/public_shell.dart';

void main() {
  testWidgets('landing public defaults to about tab', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final repository = _PublicLandingRepository();

    await tester.pumpWidget(_buildApp(repository));
    await tester.pumpAndSettle();

    expect(find.byKey(LandingPublicScreen.aboutHeroKey), findsOneWidget);
    expect(find.textContaining('Portal Informasi Evaluasi'), findsOneWidget);
    expect(find.text('Dasar hukum'), findsOneWidget);
    expect(find.text('Frekuensi pelaksanaan'), findsOneWidget);
    expect(find.text('Hasil evaluasi dan pemanfaatan'), findsOneWidget);
    expect(find.byKey(const Key('completed-assessment-search')), findsNothing);
    expect(find.text('login-screen'), findsNothing);
  });

  testWidgets('landing public bottom nav switches tabs and opens login route', (
    WidgetTester tester,
  ) async {
    final repository = _PublicLandingRepository();
    final router = _buildRouter(repository);
    addTearDown(router.dispose);

    await tester.pumpWidget(_buildApp(repository, router: router));
    await tester.pumpAndSettle();

    await _tapBottomNavLabel(tester, 'HASIL');
    expect(router.routeInformationProvider.value.uri.toString(), '/?tab=hasil');
    expect(
      find.byKey(const Key('completed-assessment-search')),
      findsOneWidget,
    );

    await _tapBottomNavLabel(tester, 'ABOUT');
    expect(router.routeInformationProvider.value.uri.toString(), '/?tab=about');
    expect(find.byKey(LandingPublicScreen.aboutHeroKey), findsOneWidget);

    await _tapBottomNavLabel(tester, 'LOGIN');
    expect(find.text('login-screen'), findsOneWidget);
  });

  testWidgets('landing public result card opens public opd route', (
    WidgetTester tester,
  ) async {
    final repository = _PublicLandingRepository();
    final GoRouter router = _buildRouter(repository);
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          assessmentRepositoryProvider.overrideWithValue(repository),
          authNotifierProvider.overrideWith(_UnauthenticatedNotifier.new),
        ],
        child: MaterialApp.router(
          theme: AppTheme.lightTheme,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await _tapBottomNavLabel(tester, 'HASIL');
    await tester.pumpAndSettle();

    await tester.tap(
      find.ancestor(
        of: find.text('Evaluasi Statistik Sektoral'),
        matching: find.byType(InkWell),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('public-opds'), findsOneWidget);
    expect(find.byKey(LandingPublicScreen.bottomNavKey), findsOneWidget);
    expect(find.text('ABOUT'), findsOneWidget);
    expect(find.text('HASIL'), findsOneWidget);
    expect(find.text('LOGIN'), findsOneWidget);
  });

  testWidgets('landing public preserves result state across tab switches', (
    WidgetTester tester,
  ) async {
    final repository = _PublicLandingRepository();

    await tester.pumpWidget(_buildApp(repository));
    await tester.pumpAndSettle();

    await _tapBottomNavLabel(tester, 'HASIL');
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('completed-assessment-search')),
      'Kesehatan',
    );
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    await _tapBottomNavLabel(tester, 'ABOUT');
    await tester.pumpAndSettle();
    await _tapBottomNavLabel(tester, 'HASIL');
    await tester.pumpAndSettle();

    expect(repository.lastPublicQuery.search, 'Kesehatan');
    expect(
      tester
          .widget<TextField>(
            find.byKey(const Key('completed-assessment-search')),
          )
          .controller
          ?.text,
      'Kesehatan',
    );
  });

  testWidgets('landing public renders three nav tabs on small width', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 780));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final repository = _PublicLandingRepository();

    await tester.pumpWidget(_buildApp(repository));
    await tester.pumpAndSettle();

    expect(find.text('ABOUT'), findsOneWidget);
    expect(find.text('HASIL'), findsOneWidget);
    expect(find.text('LOGIN'), findsOneWidget);
    expect(find.text('ATURAN'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('landing public hasil stays within the upper viewport', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final repository = _PublicLandingRepository();

    await tester.pumpWidget(_buildApp(repository));
    await tester.pumpAndSettle();

    await _tapBottomNavLabel(tester, 'HASIL');
    final double hasilTop = tester
        .getTopLeft(find.byKey(const Key('completed-assessment-search')))
        .dy;

    expect(hasilTop, lessThanOrEqualTo(220));
  });

  testWidgets('landing public hasil keeps the public light background', (
    WidgetTester tester,
  ) async {
    final repository = _PublicLandingRepository();

    await tester.pumpWidget(_buildApp(repository));
    await tester.pumpAndSettle();

    await _tapBottomNavLabel(tester, 'HASIL');

    final background = tester.widget<ColoredBox>(
      find.byKey(LandingPublicScreen.backgroundKey),
    );

    expect(background.color, AppTheme.merang);
    expect(
      find.descendant(
        of: find.byKey(LandingPublicScreen.backgroundKey),
        matching: find.byKey(LandingPublicScreen.resultsTabKey),
      ),
      findsOneWidget,
    );
  });
}

Widget _buildApp(_PublicLandingRepository repository, {GoRouter? router}) {
  final appRouter = router ?? _buildRouter(repository);

  return ProviderScope(
    overrides: [
      assessmentRepositoryProvider.overrideWithValue(repository),
      authNotifierProvider.overrideWith(_UnauthenticatedNotifier.new),
    ],
    child: MaterialApp.router(
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    ),
  );
}

GoRouter _buildRouter(_PublicLandingRepository repository) {
  return GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) =>
            PublicShell(location: state.uri, child: child),
        routes: <RouteBase>[
          GoRoute(
            path: '/',
            builder: (BuildContext context, GoRouterState state) =>
                LandingPublicScreen(
                  tab: state.uri.queryParameters['tab'] == 'hasil'
                      ? PublicLandingTab.hasil
                      : PublicLandingTab.about,
                ),
          ),
          GoRoute(
            path: '/publik/penilaian-selesai/:activityId/opds',
            builder: (BuildContext context, GoRouterState state) =>
                const Text('public-opds'),
          ),
        ],
      ),
      GoRoute(
        path: RouteConstants.login,
        builder: (BuildContext context, GoRouterState state) =>
            const Text('login-screen'),
      ),
    ],
  );
}

Future<void> _tapBottomNavLabel(WidgetTester tester, String label) async {
  await tester.tap(find.text(label));
  await tester.pumpAndSettle();
}

class _UnauthenticatedNotifier extends AuthNotifier {
  _UnauthenticatedNotifier()
    : super(_UnauthenticatedRepository(), AuthState.unauthenticated());
}

class _UnauthenticatedRepository extends AuthRepository {
  _UnauthenticatedRepository()
    : super(_FakeAuthApiClient(), _FakeTokenStorage());

  @override
  Future<User?> getUser() async => null;
}

class _FakeAuthApiClient implements AuthApiClient {
  @override
  Future<User> getUser() {
    throw UnimplementedError();
  }

  @override
  Future<LoginResponse> login(Map<String, dynamic> credentials) {
    throw UnimplementedError();
  }

  @override
  Future<void> logout() async {}

  @override
  Future<dynamic> updateProfile(Map<String, dynamic> data) {
    throw UnimplementedError();
  }
}

class _FakeTokenStorage extends TokenStorage {
  _FakeTokenStorage() : super(const FlutterSecureStorage());

  @override
  Future<String?> getToken() async => null;
}

class _PublicLandingRepository implements AssessmentRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  CompletedAssessmentQuery lastPublicQuery = const CompletedAssessmentQuery();

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
  Future<void> deleteActivity(int formulirId) async {}

  @override
  Future<List<AssessmentFormModel>> getActivities() async =>
      <AssessmentFormModel>[];

  @override
  Future<PaginatedResponse<AssessmentFormModel>> getCompletedActivities({
    CompletedAssessmentQuery query = const CompletedAssessmentQuery(),
  }) async => throw UnimplementedError();

  @override
  Future<PaginatedResponse<AssessmentFormModel>> getPublicCompletedActivities({
    CompletedAssessmentQuery query = const CompletedAssessmentQuery(),
  }) async {
    lastPublicQuery = query;

    final items = <AssessmentFormModel>[
      AssessmentFormModel(
        id: '7',
        title: 'Evaluasi Statistik Sektoral',
        date: DateTime(2026, 3, 28),
        domains: const <DomainModel>[],
        scores: const RoleScore(opd: 3.2, walidata: 3.6, admin: 3.8),
      ),
      AssessmentFormModel(
        id: '9',
        title: 'Kinerja Statistik Dinas Kesehatan',
        date: DateTime(2026, 3, 30),
        domains: const <DomainModel>[],
        scores: const RoleScore(opd: 3.4, walidata: 3.9, admin: 4.1),
      ),
    ];

    return PaginatedResponse<AssessmentFormModel>(
      data: items
          .where((item) {
            if (query.search.isEmpty) {
              return true;
            }
            return item.title.toLowerCase().contains(
              query.search.toLowerCase(),
            );
          })
          .toList(growable: false),
      meta: PaginationMeta(
        currentPage: query.page,
        lastPage: 1,
        perPage: 15,
        total: items.length,
        from: 1,
        to: items.length,
        path: '/publik/penilaian-selesai',
      ),
      links: const PaginationLinks(
        first: '/publik/penilaian-selesai?page=1',
        last: '/publik/penilaian-selesai?page=1',
      ),
    );
  }

  @override
  Future<List<ComparisonSummaryModel>> getComparisonSummary(
    String activityId,
  ) async => <ComparisonSummaryModel>[];

  @override
  Future<List<AssessmentDisposisi>> getDisposisiTrail(int formulirId) async =>
      <AssessmentDisposisi>[];

  @override
  Future<AssessmentFormModel> getFormulir(int id) async => AssessmentFormModel(
    id: '$id',
    title: 'Formulir Publik',
    date: DateTime(2026, 3, 28),
    domains: const <DomainModel>[],
  );

  @override
  Future<(AssessmentFormModel, Map<int, Penilaian>)> getIndicatorsForOpd(
    int activityId,
    int opdId,
  ) async => (await getFormulir(activityId), <int, Penilaian>{});

  @override
  Future<(AssessmentFormModel, Map<int, Penilaian>)> getPublicIndicatorsForOpd(
    int activityId,
    int opdId,
  ) async => (await getFormulir(activityId), <int, Penilaian>{});

  @override
  Future<(AssessmentFormModel, Map<int, Penilaian>)> getMyPenilaians(
    int formulirId,
  ) async => (await getFormulir(formulirId), <int, Penilaian>{});

  @override
  Future<Map<String, RoleScore>> getOpdDomainScores(
    int activityId,
    int opdId,
  ) async => <String, RoleScore>{};

  @override
  Future<Map<String, double?>> getOpdStats(int activityId, int opdId) async =>
      <String, double?>{'opd': null, 'walidata': null, 'admin': null};

  @override
  Future<List<OpdModel>> getOpdsForActivity(String activityId) async =>
      <OpdModel>[];

  @override
  Future<List<OpdModel>> getPublicOpdsForActivity(String activityId) async =>
      <OpdModel>[];

  @override
  Future<AssessmentDisposisi> submitDisposisi(
    int formulirId,
    Map<String, dynamic> data,
  ) async => throw UnimplementedError();

  @override
  Future<Penilaian> submitAdminEvaluation(Map<String, dynamic> data) async =>
      throw UnimplementedError();

  @override
  Future<Penilaian> submitPenilaian(
    int formulirId,
    int indikatorId,
    Map<String, dynamic> data,
  ) async => throw UnimplementedError();

  @override
  Future<Penilaian> submitWalidataCorrection(Map<String, dynamic> data) async =>
      throw UnimplementedError();

  @override
  Future<BuktiDukung> uploadBuktiDukung(
    int penilaianId,
    String filePath,
  ) async => throw UnimplementedError();

  @override
  Future<AssessmentFormModel> updateActivity(
    int formulirId,
    String name,
  ) async => throw UnimplementedError();
}
