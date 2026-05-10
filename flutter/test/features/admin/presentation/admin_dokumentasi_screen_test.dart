import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:parikesit/core/auth/user_role.dart';
import 'package:parikesit/core/network/paginated_response.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/core/utils/file_saver.dart';
import 'package:parikesit/core/widgets/app_pagination_footer.dart';
import 'package:parikesit/features/admin/data/admin_user_repository.dart';
import 'package:parikesit/features/admin/domain/admin_activity_query.dart';
import 'package:parikesit/features/pembinaan/data/dokumentasi_repository.dart';
import 'package:parikesit/features/pembinaan/data/pembinaan_repository.dart';
import 'package:parikesit/features/pembinaan/domain/dokumentasi_kegiatan.dart';
import 'package:parikesit/features/pembinaan/domain/pembinaan.dart';
import 'package:parikesit/features/pembinaan/presentation/dokumentasi_list_screen.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID');
  });

  group('DokumentasiListScreen', () {
    testWidgets('defaults to kegiatan mode and shows kegiatan CTA', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userRoleProvider.overrideWithValue(UserRole.admin),
            dokumentasiRepositoryProvider.overrideWithValue(
              _FakeDokumentasiRepository(),
            ),
            pembinaanRepositoryProvider.overrideWithValue(
              _FakePembinaanRepository(),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const DokumentasiListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byTooltip('Back'), findsNothing);
      expect(find.byType(BackButton), findsNothing);
      expect(find.byIcon(LucideIcons.refreshCw), findsNothing);
      expect(find.text('Kegiatan'), findsOneWidget);
      expect(find.byTooltip('Tambah kegiatan'), findsOneWidget);
      expect(find.text('Kegiatan Satu'), findsOneWidget);
      expect(find.text('Pembinaan Satu'), findsNothing);
      expect(find.byType(RefreshIndicator), findsOneWidget);
      expect(find.text('Kegiatan Satu'), findsOneWidget);
    });

    testWidgets('pagination footer stays below list content', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userRoleProvider.overrideWithValue(UserRole.admin),
            dokumentasiRepositoryProvider.overrideWithValue(
              _FakeDokumentasiRepository(),
            ),
            pembinaanRepositoryProvider.overrideWithValue(
              _FakePembinaanRepository(),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const DokumentasiListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final rapatKoordinasiBottom = tester
          .getBottomLeft(find.text('Rapat Koordinasi'))
          .dy;
      final footerTop = tester.getTopLeft(find.byType(AppPaginationFooter)).dy;

      expect(find.byType(AppPaginationFooter), findsOneWidget);
      expect(footerTop, greaterThan(rapatKoordinasiBottom));
    });

    testWidgets('toggle switches between kegiatan and pembinaan content', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userRoleProvider.overrideWithValue(UserRole.admin),
            dokumentasiRepositoryProvider.overrideWithValue(
              _FakeDokumentasiRepository(),
            ),
            pembinaanRepositoryProvider.overrideWithValue(
              _FakePembinaanRepository(),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const DokumentasiListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.text('PEMBINAAN'));
      await tester.pumpAndSettle();

      expect(find.text('Pembinaan'), findsOneWidget);
      expect(find.byIcon(LucideIcons.refreshCw), findsNothing);
      expect(find.byTooltip('Tambah pembinaan'), findsOneWidget);
      expect(find.text('Pembinaan Satu'), findsOneWidget);
      expect(find.text('Kegiatan Satu'), findsNothing);
    });

    testWidgets('search filters active list automatically after debounce', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userRoleProvider.overrideWithValue(UserRole.admin),
            dokumentasiRepositoryProvider.overrideWithValue(
              _FakeDokumentasiRepository(),
            ),
            pembinaanRepositoryProvider.overrideWithValue(
              _FakePembinaanRepository(),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const DokumentasiListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Kegiatan Satu'), findsOneWidget);
      expect(find.text('Rapat Koordinasi'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'rapat');
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Kegiatan Satu'), findsOneWidget);
      expect(find.text('Rapat Koordinasi'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      expect(find.text('Kegiatan Satu'), findsNothing);
      expect(find.text('Rapat Koordinasi'), findsOneWidget);
    });

    testWidgets('pull to refresh reloads documentation list', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final dokumentasiRepository = _FakeDokumentasiRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userRoleProvider.overrideWithValue(UserRole.admin),
            dokumentasiRepositoryProvider.overrideWithValue(
              dokumentasiRepository,
            ),
            pembinaanRepositoryProvider.overrideWithValue(
              _FakePembinaanRepository(),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const DokumentasiListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      final initialCallCount = dokumentasiRepository.getActivitiesPageCallCount;
      expect(initialCallCount, greaterThanOrEqualTo(1));

      await tester.fling(
        find.byType(ListView).first,
        const Offset(0, 600),
        1000,
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      expect(
        dokumentasiRepository.getActivitiesPageCallCount,
        greaterThan(initialCallCount),
      );
    });

    testWidgets('shows safe offline error state instead of raw exception', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userRoleProvider.overrideWithValue(UserRole.admin),
            dokumentasiRepositoryProvider.overrideWithValue(
              _ThrowingDokumentasiRepository(),
            ),
            pembinaanRepositoryProvider.overrideWithValue(
              _FakePembinaanRepository(),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const DokumentasiListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text(
          'Tidak ada koneksi internet. Periksa jaringan Anda lalu coba lagi.',
        ),
        findsOneWidget,
      );
      expect(find.textContaining('DioException'), findsNothing);
      expect(find.text('Coba Lagi'), findsOneWidget);
    });
  });
}

class _FakeDokumentasiRepository implements DokumentasiRepository {
  int getActivitiesPageCallCount = 0;

  @override
  Future<DokumentasiKegiatan> createActivity(Map<String, dynamic> data) async =>
      _items.first;

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
  }) async {
    if (search == null || search.isEmpty) {
      return _items;
    }

    return _items
        .where(
          (item) => item.judulDokumentasi.toLowerCase().contains(
            search.toLowerCase(),
          ),
        )
        .toList();
  }

  @override
  Future<PaginatedResponse<DokumentasiKegiatan>> getActivitiesPage({
    String? search,
    AdminActivitySortField? sort,
    SortDirection? direction,
    int page = 1,
    int perPage = 10,
  }) async {
    getActivitiesPageCallCount++;
    final filtered = await getActivities(search: search);
    return PaginatedResponse<DokumentasiKegiatan>(
      data: filtered,
      meta: PaginationMeta(
        currentPage: page,
        lastPage: 1,
        perPage: perPage,
        total: filtered.length,
        path: 'http://localhost/api/dokumentasi',
      ),
      links: const PaginationLinks(first: '', last: ''),
    );
  }

  @override
  Future<DokumentasiKegiatan> getActivityById(String id) async => _items.first;

  @override
  Future<DokumentasiKegiatan> updateActivity(
    String id,
    Map<String, dynamic> data,
  ) async => _items.first;

  final List<DokumentasiKegiatan> _items = <DokumentasiKegiatan>[
    DokumentasiKegiatan(
      id: '1',
      createdById: '11',
      directoryDokumentasi: 'dokumentasi/kegiatan-1',
      judulDokumentasi: 'Kegiatan Satu',
      buktiDukungUndanganDokumentasi: 'undangan.pdf',
      daftarHadirDokumentasi: 'daftar-hadir.pdf',
      materiDokumentasi: 'materi.pdf',
      notulaDokumentasi: 'notula.pdf',
      creatorName: 'Admin',
      createdAt: DateTime(2026, 3, 14),
      updatedAt: DateTime(2026, 3, 14),
    ),
    DokumentasiKegiatan(
      id: '2',
      createdById: '11',
      directoryDokumentasi: 'dokumentasi/kegiatan-2',
      judulDokumentasi: 'Rapat Koordinasi',
      buktiDukungUndanganDokumentasi: 'undangan-2.pdf',
      daftarHadirDokumentasi: 'daftar-hadir-2.pdf',
      materiDokumentasi: 'materi-2.pdf',
      notulaDokumentasi: 'notula-2.pdf',
      creatorName: 'Admin',
      createdAt: DateTime(2026, 3, 15),
      updatedAt: DateTime(2026, 3, 15),
    ),
  ];
}

class _ThrowingDokumentasiRepository extends _FakeDokumentasiRepository {
  @override
  Future<PaginatedResponse<DokumentasiKegiatan>> getActivitiesPage({
    String? search,
    AdminActivitySortField? sort,
    SortDirection? direction,
    int page = 1,
    int perPage = 10,
  }) {
    throw DioException(
      requestOptions: RequestOptions(path: '/dokumentasi'),
      type: DioExceptionType.connectionError,
      error: const SocketException('Failed host lookup'),
    );
  }
}

class _FakePembinaanRepository implements PembinaanRepository {
  @override
  Future<Pembinaan> createActivity(Map<String, dynamic> data) async =>
      _items.first;

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
  }) async {
    if (search == null || search.isEmpty) {
      return _items;
    }

    return _items
        .where(
          (item) =>
              item.judulPembinaan.toLowerCase().contains(search.toLowerCase()),
        )
        .toList();
  }

  @override
  Future<PaginatedResponse<Pembinaan>> getActivitiesPage({
    String? search,
    AdminActivitySortField? sort,
    SortDirection? direction,
    int page = 1,
    int perPage = 10,
  }) async {
    final filtered = await getActivities(search: search);
    return PaginatedResponse<Pembinaan>(
      data: filtered,
      meta: PaginationMeta(
        currentPage: page,
        lastPage: 1,
        perPage: perPage,
        total: filtered.length,
        path: 'http://localhost/api/pembinaan',
      ),
      links: const PaginationLinks(first: '', last: ''),
    );
  }

  @override
  Future<Pembinaan> getActivityById(String id) async => _items.first;

  @override
  Future<Pembinaan> updateActivity(
    String id,
    Map<String, dynamic> data,
  ) async => _items.first;

  final List<Pembinaan> _items = <Pembinaan>[
    Pembinaan(
      id: '2',
      createdById: '11',
      directoryPembinaan: 'pembinaan/pembinaan-1',
      judulPembinaan: 'Pembinaan Satu',
      buktiDukungUndanganPembinaan: 'undangan.pdf',
      daftarHadirPembinaan: 'daftar-hadir.pdf',
      materiPembinaan: 'materi.pdf',
      notulaPembinaan: 'notula.pdf',
      creatorName: 'Admin',
      createdAt: DateTime(2026, 3, 15),
      updatedAt: DateTime(2026, 3, 15),
    ),
    Pembinaan(
      id: '3',
      createdById: '11',
      directoryPembinaan: 'pembinaan/pembinaan-2',
      judulPembinaan: 'Pembinaan Statistik',
      buktiDukungUndanganPembinaan: 'undangan-2.pdf',
      daftarHadirPembinaan: 'daftar-hadir-2.pdf',
      materiPembinaan: 'materi-2.pdf',
      notulaPembinaan: 'notula-2.pdf',
      creatorName: 'Admin',
      createdAt: DateTime(2026, 3, 16),
      updatedAt: DateTime(2026, 3, 16),
    ),
  ];
}
