import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:parikesit/core/network/paginated_response.dart';
import 'package:parikesit/core/utils/file_saver.dart';
import 'package:parikesit/features/admin/data/admin_user_repository.dart';
import 'package:parikesit/features/admin/domain/admin_activity_query.dart';
import 'package:parikesit/features/admin/presentation/controller/admin_dokumentasi_controller.dart';
import 'package:parikesit/features/admin/presentation/widgets/dokumentasi_filter_bar.dart';
import 'package:parikesit/features/pembinaan/data/dokumentasi_repository.dart';
import 'package:parikesit/features/pembinaan/data/pembinaan_repository.dart';
import 'package:parikesit/features/pembinaan/domain/dokumentasi_kegiatan.dart';
import 'package:parikesit/features/pembinaan/domain/pembinaan.dart';

void main() {
  testWidgets('search waits for debounce before refreshing', (tester) async {
    final controller = _RecordingAdminDokumentasiController();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          adminDokumentasiControllerProvider.overrideWith((ref) => controller),
        ],
        child: const MaterialApp(home: Scaffold(body: DokumentasiFilterBar())),
      ),
    );

    controller.resetCounters();

    await tester.enterText(find.byType(TextField), 'rapat');
    await tester.pump(const Duration(milliseconds: 300));

    expect(controller.setSearchCalls, <String>[]);
    expect(controller.refreshCalls, 0);

    await tester.pump(const Duration(milliseconds: 100));

    expect(controller.setSearchCalls, <String>['rapat']);
    expect(controller.refreshCalls, 1);
  });

  testWidgets('clear search resets search and refreshes immediately', (
    tester,
  ) async {
    final controller = _RecordingAdminDokumentasiController();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          adminDokumentasiControllerProvider.overrideWith((ref) => controller),
        ],
        child: const MaterialApp(home: Scaffold(body: DokumentasiFilterBar())),
      ),
    );

    controller.resetCounters();

    await tester.enterText(find.byType(TextField), 'agenda');
    await tester.pump(const Duration(milliseconds: 400));
    controller.resetCounters();

    await tester.tap(find.byIcon(LucideIcons.x));
    await tester.pump();

    expect(controller.setSearchCalls, <String>['']);
    expect(controller.refreshCalls, 1);
  });

  testWidgets('sort controls refresh with selected sort and direction', (
    tester,
  ) async {
    final controller = _RecordingAdminDokumentasiController();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          adminDokumentasiControllerProvider.overrideWith((ref) => controller),
        ],
        child: const MaterialApp(home: Scaffold(body: DokumentasiFilterBar())),
      ),
    );

    controller.resetCounters();

    await tester.tap(find.byKey(const Key('admin-documentation-sort-field')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Judul').last);
    await tester.pumpAndSettle();

    expect(controller.sortCalls, <AdminActivitySortField>[
      AdminActivitySortField.title,
    ]);
    expect(controller.refreshCalls, 1);

    controller.resetCounters();

    await tester.tap(
      find.byKey(const Key('admin-documentation-toggle-sort-direction')),
    );
    await tester.pump();

    expect(controller.toggleSortDirectionCalls, 1);
    expect(controller.refreshCalls, 1);
  });
}

class _RecordingAdminDokumentasiController extends AdminDokumentasiController {
  _RecordingAdminDokumentasiController()
    : super(
        dokumentasiRepository: _FakeDokumentasiRepository(),
        pembinaanRepository: _FakePembinaanRepository(),
      );

  final List<String> setSearchCalls = <String>[];
  final List<AdminActivitySortField> sortCalls = <AdminActivitySortField>[];
  int toggleSortDirectionCalls = 0;
  int refreshCalls = 0;

  void resetCounters() {
    setSearchCalls.clear();
    sortCalls.clear();
    toggleSortDirectionCalls = 0;
    refreshCalls = 0;
  }

  @override
  void setSearch(String search) {
    setSearchCalls.add(search);
    super.setSearch(search);
  }

  @override
  void setSort(AdminActivitySortField sort) {
    sortCalls.add(sort);
    super.setSort(sort);
  }

  @override
  void toggleSortDirection() {
    toggleSortDirectionCalls += 1;
    super.toggleSortDirection();
  }

  @override
  Future<void> refresh() async {
    refreshCalls += 1;
    state = state.copyWith(
      isLoading: false,
      kegiatanPage: const PaginatedResponse<DokumentasiKegiatan>(
        data: <DokumentasiKegiatan>[],
        meta: PaginationMeta(
          currentPage: 1,
          lastPage: 1,
          perPage: 10,
          total: 0,
          path: 'http://localhost/api/dokumentasi',
        ),
        links: PaginationLinks(first: '', last: ''),
      ),
      clearErrorMessage: true,
    );
  }
}

class _FakeDokumentasiRepository implements IDokumentasiRepository {
  @override
  Future<DokumentasiKegiatan> createActivity(Map<String, dynamic> data) async =>
      throw UnimplementedError();

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
  }) async => const <DokumentasiKegiatan>[];

  @override
  Future<PaginatedResponse<DokumentasiKegiatan>> getActivitiesPage({
    String? search,
    AdminActivitySortField? sort,
    SortDirection? direction,
    int page = 1,
    int perPage = 10,
  }) async {
    return const PaginatedResponse<DokumentasiKegiatan>(
      data: <DokumentasiKegiatan>[],
      meta: PaginationMeta(
        currentPage: 1,
        lastPage: 1,
        perPage: 10,
        total: 0,
        path: 'http://localhost/api/dokumentasi',
      ),
      links: PaginationLinks(first: '', last: ''),
    );
  }

  @override
  Future<DokumentasiKegiatan> getActivityById(String id) async =>
      throw UnimplementedError();

  @override
  Future<DokumentasiKegiatan> updateActivity(
    String id,
    Map<String, dynamic> data,
  ) async => throw UnimplementedError();
}

class _FakePembinaanRepository implements IPembinaanRepository {
  @override
  Future<Pembinaan> createActivity(Map<String, dynamic> data) async =>
      throw UnimplementedError();

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
  }) async => const <Pembinaan>[];

  @override
  Future<PaginatedResponse<Pembinaan>> getActivitiesPage({
    String? search,
    AdminActivitySortField? sort,
    SortDirection? direction,
    int page = 1,
    int perPage = 10,
  }) async {
    return const PaginatedResponse<Pembinaan>(
      data: <Pembinaan>[],
      meta: PaginationMeta(
        currentPage: 1,
        lastPage: 1,
        perPage: 10,
        total: 0,
        path: 'http://localhost/api/pembinaan',
      ),
      links: PaginationLinks(first: '', last: ''),
    );
  }

  @override
  Future<Pembinaan> getActivityById(String id) async =>
      throw UnimplementedError();

  @override
  Future<Pembinaan> updateActivity(
    String id,
    Map<String, dynamic> data,
  ) async => throw UnimplementedError();
}
