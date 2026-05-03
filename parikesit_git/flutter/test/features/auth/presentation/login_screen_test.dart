import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parikesit/core/storage/token_storage.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/features/auth/data/auth_api_client.dart';
import 'package:parikesit/features/auth/data/auth_repository.dart';
import 'package:parikesit/features/auth/domain/login_response.dart';
import 'package:parikesit/features/auth/domain/user.dart';
import 'package:parikesit/features/auth/presentation/controller/auth_provider.dart';
import 'package:parikesit/features/auth/presentation/login_screen.dart';

void main() {
  testWidgets('shows mascot branding above login form on small screens', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authNotifierProvider.overrideWith(() => _UnauthenticatedNotifier()),
        ],
        child: const MaterialApp(home: LoginScreen()),
      ),
    );
    await tester.pump();

    expect(find.byKey(LoginScreen.mascotImageKey), findsOneWidget);
    expect(find.text('PARIKESIT'), findsOneWidget);
    expect(find.text('MASUK APLIKASI'), findsOneWidget);
    expect(find.byKey(LoginScreen.contentKey), findsOneWidget);
    expect(find.byKey(LoginScreen.backToPublicButtonKey), findsOneWidget);
    expect(tester.takeException(), isNull);

    final backButton = tester.widget<IconButton>(
      find.byKey(LoginScreen.backToPublicButtonKey),
    );

    expect(backButton.style?.backgroundColor?.resolve({}), AppTheme.sogan);
    expect(backButton.style?.foregroundColor?.resolve({}), AppTheme.gold);

    final image = tester.widget<Image>(find.byKey(LoginScreen.mascotImageKey));

    expect(image.image, isA<AssetImage>());
    expect((image.image as AssetImage).assetName, 'assets/images/maskot.png');
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsNothing);
  });

  testWidgets('centers login content when there is enough vertical space', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authNotifierProvider.overrideWith(() => _UnauthenticatedNotifier()),
        ],
        child: const MaterialApp(home: LoginScreen()),
      ),
    );
    await tester.pumpAndSettle();

    final scaffoldRect = tester.getRect(find.byType(Scaffold));
    final contentRect = tester.getRect(find.byKey(LoginScreen.contentKey));
    final topSpace = contentRect.top - scaffoldRect.top;
    final bottomSpace = scaffoldRect.bottom - contentRect.bottom;

    expect((topSpace - bottomSpace).abs(), lessThan(80));
  });

  testWidgets(
    'keeps login content top-aligned and scrollable on short height',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(360, 360));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authNotifierProvider.overrideWith(() => _UnauthenticatedNotifier()),
          ],
          child: const MaterialApp(home: LoginScreen()),
        ),
      );
      await tester.pumpAndSettle();

      final scaffoldRect = tester.getRect(find.byType(Scaffold));
      final contentRect = tester.getRect(find.byKey(LoginScreen.contentKey));

      expect(contentRect.top - scaffoldRect.top, lessThan(80));
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byKey(LoginScreen.loginButtonKey), findsOneWidget);
    },
  );
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
  Future<String?> getToken() => Future<String?>.value(null);
}
