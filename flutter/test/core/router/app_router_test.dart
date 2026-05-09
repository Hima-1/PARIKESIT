import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parikesit/core/auth/user_role.dart';
import 'package:parikesit/core/network/paginated_response.dart';
import 'package:parikesit/core/router/app_router.dart';
import 'package:parikesit/core/router/auth_bootstrap_screen.dart';
import 'package:parikesit/core/router/route_constants.dart';
import 'package:parikesit/core/storage/token_storage.dart';
import 'package:parikesit/core/widgets/main_layout.dart';
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
import 'package:parikesit/features/auth/presentation/login_screen.dart';
import 'package:parikesit/features/public/presentation/landing_public_screen.dart';

void main() {
  testWidgets('unauthenticated app starts on public landing route', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1440, 2200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final ProviderContainer container = ProviderContainer(
      overrides: [
        authNotifierProvider.overrideWith(_FakeGuestAuthNotifier.new),
        assessmentRepositoryProvider.overrideWithValue(
          _RouterAssessmentRepository(),
        ),
      ],
    );
    addTearDown(container.dispose);

    final router = container.read(routerProvider);
    addTearDown(router.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump(const Duration(milliseconds: 400));

    expect(
      router.routeInformationProvider.value.uri.path,
      RouteConstants.landing,
    );
    expect(find.byType(MainLayout), findsNothing);
    expect(find.byKey(LandingPublicScreen.aboutHeroKey), findsOneWidget);
    expect(find.byKey(const Key('completed-assessment-search')), findsNothing);
    expect(find.byType(LoginScreen), findsNothing);
    expect(find.byKey(AuthBootstrapScreen.loadingKey), findsNothing);
  });

  testWidgets(
    'authenticated cold start shows bootstrap first and skips public landing fetch',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1440, 2200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final repository = _RouterAssessmentRepository();
      final ProviderContainer container = ProviderContainer(
        overrides: [
          authNotifierProvider.overrideWith(
            () => AuthNotifier(
              _DelayedAuthRepository(
                user: const User(
                  id: 2,
                  name: 'OPD',
                  email: 'opd@example.com',
                  role: 'opd',
                ),
              ),
            ),
          ),
          assessmentRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      final router = container.read(routerProvider);
      addTearDown(router.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pump();

      expect(
        router.routeInformationProvider.value.uri.path,
        RouteConstants.authBootstrap,
      );
      expect(find.byKey(AuthBootstrapScreen.loadingKey), findsOneWidget);
      expect(find.byType(MainLayout), findsNothing);
      expect(
        find.byKey(const Key('completed-assessment-search')),
        findsNothing,
      );

      await tester.pump(const Duration(milliseconds: 250));
      await tester.pump(const Duration(milliseconds: 300));

      expect(
        router.routeInformationProvider.value.uri.path,
        RouteConstants.home,
      );
      expect(find.byType(MainLayout), findsOneWidget);
      expect(repository.publicCompletedActivitiesCallCount, 0);
    },
  );

  testWidgets('loading bootstrap does not block guest public deep link', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1440, 2200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final ProviderContainer container = ProviderContainer(
      overrides: [
        authNotifierProvider.overrideWith(
          () => AuthNotifier(_DelayedAuthRepository(user: null)),
        ),
        assessmentRepositoryProvider.overrideWithValue(
          _RouterAssessmentRepository(),
        ),
      ],
    );
    addTearDown(container.dispose);

    final router = container.read(routerProvider);
    addTearDown(router.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump();

    router.go('/publik/penilaian-selesai/7/opds');
    await tester.pump();

    expect(
      router.routeInformationProvider.value.uri.path,
      RouteConstants.authBootstrap,
    );
    expect(find.byKey(AuthBootstrapScreen.loadingKey), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 250));
    await tester.pumpAndSettle();

    expect(
      router.routeInformationProvider.value.uri.path,
      '/publik/penilaian-selesai/7/opds',
    );
  });

  testWidgets('loading bootstrap preserves authenticated internal deep link', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1440, 2200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final ProviderContainer container = ProviderContainer(
      overrides: [
        authNotifierProvider.overrideWith(
          () => AuthNotifier(
            _DelayedAuthRepository(
              user: const User(
                id: 2,
                name: 'OPD',
                email: 'opd@example.com',
                role: 'opd',
              ),
            ),
          ),
        ),
        assessmentRepositoryProvider.overrideWithValue(
          _RouterAssessmentRepository(),
        ),
      ],
    );
    addTearDown(container.dispose);

    final router = container.read(routerProvider);
    addTearDown(router.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump();

    router.go('/penilaian-selesai/7');
    await tester.pump();

    expect(
      router.routeInformationProvider.value.uri.path,
      RouteConstants.authBootstrap,
    );

    await tester.pump(const Duration(milliseconds: 250));
    await tester.pumpAndSettle();

    expect(
      router.routeInformationProvider.value.uri.path,
      '/penilaian-selesai/7',
    );
    expect(find.byKey(const Key('completed-assessment-search')), findsNothing);
  });

  testWidgets('guest can still open direct login route', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1440, 2200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final ProviderContainer container = ProviderContainer(
      overrides: [
        authNotifierProvider.overrideWith(_FakeGuestAuthNotifier.new),
        assessmentRepositoryProvider.overrideWithValue(
          _RouterAssessmentRepository(),
        ),
      ],
    );
    addTearDown(container.dispose);

    final router = container.read(routerProvider);
    addTearDown(router.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump(const Duration(milliseconds: 400));

    router.go(RouteConstants.login);
    await tester.pumpAndSettle();

    expect(
      router.routeInformationProvider.value.uri.path,
      RouteConstants.login,
    );
    expect(find.byKey(LoginScreen.loginButtonKey), findsOneWidget);
  });

  testWidgets('unauthenticated private route redirects to login', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1440, 2200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final ProviderContainer container = ProviderContainer(
      overrides: [
        authNotifierProvider.overrideWith(_FakeGuestAuthNotifier.new),
        assessmentRepositoryProvider.overrideWithValue(
          _RouterAssessmentRepository(),
        ),
      ],
    );
    addTearDown(container.dispose);

    final router = container.read(routerProvider);
    addTearDown(router.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    router.go(RouteConstants.profile);
    await tester.pumpAndSettle();

    expect(
      router.routeInformationProvider.value.uri.path,
      RouteConstants.login,
    );
    expect(find.byKey(LoginScreen.loginButtonKey), findsOneWidget);
  });

  testWidgets('landing login tab submit redirects authenticated user to home', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1440, 2200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final ProviderContainer container = ProviderContainer(
      overrides: [
        authNotifierProvider.overrideWith(_InstantLoginAuthNotifier.new),
        assessmentRepositoryProvider.overrideWithValue(
          _RouterAssessmentRepository(),
        ),
      ],
    );
    addTearDown(container.dispose);

    final router = container.read(routerProvider);
    addTearDown(router.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('LOGIN'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(LoginScreen.emailFieldKey),
      'opd@example.com',
    );
    await tester.enterText(find.byKey(LoginScreen.passwordFieldKey), 'secret');
    await tester.tap(find.byKey(LoginScreen.loginButtonKey));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(router.routeInformationProvider.value.uri.path, RouteConstants.home);
    expect(find.byType(MainLayout), findsOneWidget);
  });

  testWidgets('landing login action opens login route for guest', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1440, 2200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final ProviderContainer container = ProviderContainer(
      overrides: [
        authNotifierProvider.overrideWith(_FakeGuestAuthNotifier.new),
        assessmentRepositoryProvider.overrideWithValue(
          _RouterAssessmentRepository(),
        ),
      ],
    );
    addTearDown(container.dispose);

    final router = container.read(routerProvider);
    addTearDown(router.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('LOGIN'));
    await tester.pumpAndSettle();

    expect(
      router.routeInformationProvider.value.uri.path,
      RouteConstants.login,
    );
    expect(find.byKey(LoginScreen.loginButtonKey), findsOneWidget);
  });

  testWidgets('guest can return from login route to public landing', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1440, 2200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final ProviderContainer container = ProviderContainer(
      overrides: [
        authNotifierProvider.overrideWith(_FakeGuestAuthNotifier.new),
        assessmentRepositoryProvider.overrideWithValue(
          _RouterAssessmentRepository(),
        ),
      ],
    );
    addTearDown(container.dispose);

    final router = container.read(routerProvider);
    addTearDown(router.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('LOGIN'));
    await tester.pumpAndSettle();

    expect(
      router.routeInformationProvider.value.uri.path,
      RouteConstants.login,
    );

    await tester.tap(find.byKey(LoginScreen.backToPublicButtonKey));
    await tester.pumpAndSettle();

    expect(
      router.routeInformationProvider.value.uri.path,
      RouteConstants.landing,
    );
    expect(find.byType(LandingPublicScreen), findsOneWidget);
    expect(find.byType(MainLayout), findsNothing);
  });

  testWidgets(
    'OPD deep link to completed assessment self-review is not redirected',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1440, 2200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final ProviderContainer container = ProviderContainer(
        overrides: [
          authNotifierProvider.overrideWith(_FakeOpdAuthNotifier.new),
          userRoleProvider.overrideWithValue(UserRole.opd),
          assessmentRepositoryProvider.overrideWithValue(
            _RouterAssessmentRepository(),
          ),
        ],
      );
      addTearDown(container.dispose);

      final router = container.read(routerProvider);
      addTearDown(router.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));

      router.go('/penilaian-selesai/7');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(
        router.routeInformationProvider.value.uri.path,
        '/penilaian-selesai/7',
      );
    },
  );

  testWidgets(
    'OPD deep link to cross-OPD completed assessment review is redirected to home',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1440, 2200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final ProviderContainer container = ProviderContainer(
        overrides: [
          authNotifierProvider.overrideWith(_FakeOpdAuthNotifier.new),
          userRoleProvider.overrideWithValue(UserRole.opd),
          assessmentRepositoryProvider.overrideWithValue(
            _RouterAssessmentRepository(),
          ),
        ],
      );
      addTearDown(container.dispose);

      final router = container.read(routerProvider);
      addTearDown(router.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));

      router.go('/penilaian-selesai/7/opd/9');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(
        router.routeInformationProvider.value.uri.path,
        RouteConstants.home,
      );
    },
  );

  testWidgets(
    'unauthenticated public OPD route is allowed without redirect to login',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1440, 2200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final ProviderContainer container = ProviderContainer(
        overrides: [
          authNotifierProvider.overrideWith(_FakeGuestAuthNotifier.new),
          assessmentRepositoryProvider.overrideWithValue(
            _RouterAssessmentRepository(),
          ),
        ],
      );
      addTearDown(container.dispose);

      final router = container.read(routerProvider);
      addTearDown(router.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));

      router.go('/publik/penilaian-selesai/7/opds');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(
        router.routeInformationProvider.value.uri.path,
        '/publik/penilaian-selesai/7/opds',
      );
      expect(find.byKey(LandingPublicScreen.bottomNavKey), findsOneWidget);
      expect(find.byType(MainLayout), findsNothing);
    },
  );
}

class _FakeOpdAuthNotifier extends AuthNotifier {
  _FakeOpdAuthNotifier() : super(_FakeOpdAuthRepository());
}

class _FakeGuestAuthNotifier extends AuthNotifier {
  _FakeGuestAuthNotifier() : super(_FakeGuestAuthRepository());
}

class _InstantLoginAuthNotifier extends AuthNotifier {
  _InstantLoginAuthNotifier()
    : super(_FakeGuestAuthRepository(), AuthState.unauthenticated());

  @override
  Future<void> login(String email, String password) async {
    state = AuthState.authenticated(
      const User(id: 2, name: 'OPD', email: 'opd@example.com', role: 'opd'),
    );
  }
}

class _FakeOpdAuthRepository extends AuthRepository {
  _FakeOpdAuthRepository()
    : super(_FakeOpdAuthApiClient(), _FakeTokenStorage());

  @override
  Future<User?> getUser() async =>
      const User(id: 2, name: 'OPD', email: 'opd@example.com', role: 'opd');
}

class _FakeGuestAuthRepository extends AuthRepository {
  _FakeGuestAuthRepository()
    : super(_FakeGuestAuthApiClient(), _FakeTokenStorage());

  @override
  Future<User?> getUser() async => null;
}

class _FakeOpdAuthApiClient implements AuthApiClient {
  @override
  Future<User> getUser() async =>
      const User(id: 2, name: 'OPD', email: 'opd@example.com', role: 'opd');

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

class _FakeGuestAuthApiClient implements AuthApiClient {
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
  Future<String?> getToken() async => 'token';
}

class _DelayedAuthRepository extends AuthRepository {
  _DelayedAuthRepository({required this.user})
    : super(
        user == null ? _FakeGuestAuthApiClient() : _FakeOpdAuthApiClient(),
        _FakeTokenStorage(),
      );

  final User? user;

  @override
  Future<User?> getUser() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return user;
  }
}

class _RouterAssessmentRepository implements AssessmentRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  int publicCompletedActivitiesCallCount = 0;

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
  }) async {
    publicCompletedActivitiesCallCount++;
    return getCompletedActivities(query: query);
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
    title: 'Formulir Selesai',
    date: DateTime(2026, 3, 1),
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
  ) async => getIndicatorsForOpd(activityId, opdId);

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
      getOpdsForActivity(activityId);

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
  ) async {
    throw UnimplementedError();
  }
}
