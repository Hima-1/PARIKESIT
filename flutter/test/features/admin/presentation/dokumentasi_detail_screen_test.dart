import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:parikesit/core/auth/user_role.dart';
import 'package:parikesit/core/network/paginated_response.dart';
import 'package:parikesit/core/storage/token_storage.dart';
import 'package:parikesit/core/utils/file_saver.dart';
import 'package:parikesit/features/admin/data/admin_user_repository.dart';
import 'package:parikesit/features/admin/domain/admin_activity_query.dart';
import 'package:parikesit/features/admin/presentation/controller/dokumentasi_detail_controller.dart';
import 'package:parikesit/features/admin/presentation/dokumentasi_detail_screen.dart';
import 'package:parikesit/features/auth/data/auth_api_client.dart';
import 'package:parikesit/features/auth/data/auth_repository.dart';
import 'package:parikesit/features/auth/domain/login_response.dart';
import 'package:parikesit/features/auth/domain/user.dart';
import 'package:parikesit/features/auth/presentation/controller/auth_provider.dart';
import 'package:parikesit/features/pembinaan/data/dokumentasi_repository.dart';
import 'package:parikesit/features/pembinaan/data/pembinaan_repository.dart';
import 'package:parikesit/features/pembinaan/domain/dokumentasi_kegiatan.dart';
import 'package:parikesit/features/pembinaan/domain/file_dokumentasi.dart';
import 'package:parikesit/features/pembinaan/domain/file_pembinaan.dart';
import 'package:parikesit/features/pembinaan/domain/pembinaan.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID');
  });

  testWidgets('detail breadcrumb shows kegiatan for dokumentasi type', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authNotifierProvider.overrideWith(_FakeAuthNotifier.new),
          userRoleProvider.overrideWithValue(UserRole.admin),
          dokumentasiRepositoryProvider.overrideWithValue(
            _FakeDokumentasiRepository(),
          ),
          pembinaanRepositoryProvider.overrideWithValue(
            _FakePembinaanRepository(),
          ),
        ],
        child: const MaterialApp(
          home: DokumentasiDetailScreen(
            id: '1',
            type: DokumentasiDetailType.kegiatan,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(RefreshIndicator), findsOneWidget);
    expect(find.text('Kegiatan'), findsOneWidget);
    expect(find.text('Dokumentasi Kegiatan'), findsOneWidget);
  });

  testWidgets('detail breadcrumb shows pembinaan for pembinaan type', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authNotifierProvider.overrideWith(_FakeAuthNotifier.new),
          userRoleProvider.overrideWithValue(UserRole.admin),
          dokumentasiRepositoryProvider.overrideWithValue(
            _FakeDokumentasiRepository(),
          ),
          pembinaanRepositoryProvider.overrideWithValue(
            _FakePembinaanRepository(),
          ),
        ],
        child: const MaterialApp(
          home: DokumentasiDetailScreen(
            id: '2',
            type: DokumentasiDetailType.pembinaan,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(RefreshIndicator), findsOneWidget);
    expect(find.text('Pembinaan'), findsOneWidget);
    expect(find.text('Dokumentasi Pembinaan'), findsOneWidget);
  });

  testWidgets('tapping image media opens in-app preview dialog', (
    tester,
  ) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authNotifierProvider.overrideWith(_FakeAuthNotifier.new),
            userRoleProvider.overrideWithValue(UserRole.admin),
            dokumentasiRepositoryProvider.overrideWithValue(
              _FakeDokumentasiRepository(),
            ),
            pembinaanRepositoryProvider.overrideWithValue(
              _FakePembinaanRepository(),
            ),
          ],
          child: const MaterialApp(
            home: DokumentasiDetailScreen(
              id: '1',
              type: DokumentasiDetailType.kegiatan,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('photo.jpg'), findsOneWidget);
      expect(find.byIcon(LucideIcons.downloadCloud), findsNothing);

      await tester.ensureVisible(find.text('photo.jpg'));
      await tester.tap(
        find.ancestor(
          of: find.text('photo.jpg'),
          matching: find.byType(ListTile),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(Dialog), findsOneWidget);
      expect(find.byType(InteractiveViewer), findsOneWidget);
      expect(find.byIcon(LucideIcons.x), findsOneWidget);
      expect(find.text('photo.jpg'), findsWidgets);
    });
  });
}

class _FakeAuthNotifier extends AuthNotifier {
  _FakeAuthNotifier() : super(_FakeAuthRepository());
}

class _FakeAuthRepository extends AuthRepository {
  _FakeAuthRepository() : super(_FakeAuthApiClient(), _FakeTokenStorage());

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

class _FakeDokumentasiRepository implements DokumentasiRepository {
  @override
  Future<DokumentasiKegiatan> createActivity(Map<String, dynamic> data) async =>
      _item;

  @override
  Future<void> deleteActivity(String id) async {}

  @override
  Future<DownloadTarget> downloadActivity(
    String id, {
    required DownloadTarget target,
    void Function(int received, int total)? onReceiveProgress,
  }) async => target;

  @override
  Future<List<int>> downloadPublicFile(String storagePath) async => <int>[];

  @override
  Future<List<DokumentasiKegiatan>> getActivities({
    String? search,
    DateTime? startDate,
    DateTime? endDate,
  }) async => <DokumentasiKegiatan>[_item];

  @override
  Future<PaginatedResponse<DokumentasiKegiatan>> getActivitiesPage({
    String? search,
    AdminActivitySortField? sort,
    SortDirection? direction,
    int page = 1,
    int perPage = 10,
  }) async => PaginatedResponse<DokumentasiKegiatan>(
    data: <DokumentasiKegiatan>[_item],
    meta: PaginationMeta(
      currentPage: page,
      lastPage: 1,
      perPage: perPage,
      total: 1,
      from: 1,
      to: 1,
      path: '/dokumentasi',
    ),
    links: const PaginationLinks(
      first: '/dokumentasi?page=1',
      last: '/dokumentasi?page=1',
    ),
  );

  @override
  Future<DokumentasiKegiatan> getActivityById(String id) async => _item;

  @override
  Future<DokumentasiKegiatan> updateActivity(
    String id,
    Map<String, dynamic> data,
  ) async => _item;

  final DokumentasiKegiatan _item = DokumentasiKegiatan(
    id: '1',
    createdById: '11',
    directoryDokumentasi: 'dokumentasi/kegiatan-1',
    judulDokumentasi: 'Dokumentasi Kegiatan',
    buktiDukungUndanganDokumentasi: 'undangan.pdf',
    daftarHadirDokumentasi: 'daftar-hadir.pdf',
    materiDokumentasi: 'materi.pdf',
    notulaDokumentasi: 'notula.pdf',
    creatorName: 'Admin',
    files: <FileDokumentasi>[
      FileDokumentasi(
        id: 'media-1',
        dokumentasiKegiatanId: '1',
        namaFile: 'https://example.com/media/photo.jpg',
        tipeFile: 'jpg',
        createdAt: DateTime(2026, 3, 14),
        updatedAt: DateTime(2026, 3, 14),
      ),
      FileDokumentasi(
        id: 'media-2',
        dokumentasiKegiatanId: '1',
        namaFile: 'https://example.com/media/video.mp4',
        tipeFile: 'mp4',
        createdAt: DateTime(2026, 3, 14),
        updatedAt: DateTime(2026, 3, 14),
      ),
    ],
    createdAt: DateTime(2026, 3, 14),
    updatedAt: DateTime(2026, 3, 14),
  );
}

class _FakePembinaanRepository implements PembinaanRepository {
  @override
  Future<Pembinaan> createActivity(Map<String, dynamic> data) async => _item;

  @override
  Future<void> deleteActivity(String id) async {}

  @override
  Future<DownloadTarget> downloadActivity(
    String id, {
    required DownloadTarget target,
    void Function(int received, int total)? onReceiveProgress,
  }) async => target;

  @override
  Future<List<int>> downloadPublicFile(String storagePath) async => <int>[];

  @override
  Future<List<Pembinaan>> getActivities({
    String? search,
    DateTime? startDate,
    DateTime? endDate,
  }) async => <Pembinaan>[_item];

  @override
  Future<PaginatedResponse<Pembinaan>> getActivitiesPage({
    String? search,
    AdminActivitySortField? sort,
    SortDirection? direction,
    int page = 1,
    int perPage = 10,
  }) async => PaginatedResponse<Pembinaan>(
    data: <Pembinaan>[_item],
    meta: PaginationMeta(
      currentPage: page,
      lastPage: 1,
      perPage: perPage,
      total: 1,
      from: 1,
      to: 1,
      path: '/pembinaan',
    ),
    links: const PaginationLinks(
      first: '/pembinaan?page=1',
      last: '/pembinaan?page=1',
    ),
  );

  @override
  Future<Pembinaan> getActivityById(String id) async => _item;

  @override
  Future<Pembinaan> updateActivity(
    String id,
    Map<String, dynamic> data,
  ) async => _item;

  final Pembinaan _item = Pembinaan(
    id: '2',
    createdById: '11',
    directoryPembinaan: 'pembinaan/pembinaan-1',
    judulPembinaan: 'Dokumentasi Pembinaan',
    buktiDukungUndanganPembinaan: 'undangan.pdf',
    daftarHadirPembinaan: 'daftar-hadir.pdf',
    materiPembinaan: 'materi.pdf',
    notulaPembinaan: 'notula.pdf',
    creatorName: 'Admin',
    files: <FilePembinaan>[
      FilePembinaan(
        id: 'media-11',
        pembinaanId: '2',
        namaFile: 'https://example.com/media/pembinaan-photo.jpg',
        tipeFile: 'jpg',
        createdAt: DateTime(2026, 3, 15),
        updatedAt: DateTime(2026, 3, 15),
      ),
    ],
    createdAt: DateTime(2026, 3, 15),
    updatedAt: DateTime(2026, 3, 15),
  );
}
