import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:parikesit/core/auth/app_user.dart';
import 'package:parikesit/core/network/paginated_response.dart';
import 'package:parikesit/core/widgets/app_pagination_footer.dart';
import 'package:parikesit/features/home/domain/opd_dashboard_progress.dart';
import 'package:parikesit/features/home/presentation/pages/opd/controller/opd_dashboard_controller.dart';
import 'package:parikesit/features/home/presentation/pages/opd/opd_dashboard_screen.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

  testWidgets(
    'OpdDashboardScreen uses the newest progress item for the quick action card',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserProvider.overrideWith((ref) => null),
            opdDashboardControllerProvider.overrideWith(
              () => _FakeOpdDashboardController(<OpdDashboardProgress>[
                OpdDashboardProgress(
                  id: 1,
                  name: 'Evaluasi Lama',
                  date: DateTime(2026, 3, 14),
                  progressPerIndikator: const OpdProgressDetail(
                    total: 10,
                    terisi: 10,
                    persentase: 100,
                  ),
                  hasilPenilaianAkhir: 4.5,
                  progressKoreksiWalidata: const OpdProgressDetail(
                    total: 10,
                    sudahDikoreksi: 10,
                    persentase: 100,
                  ),
                  progressEvaluasiAdmin: const OpdProgressDetail(
                    total: 10,
                    sudahDievaluasi: 10,
                    persentase: 100,
                  ),
                ),
                OpdDashboardProgress(
                  id: 2,
                  name: 'Evaluasi Baru',
                  date: DateTime(2026, 3, 16),
                  progressPerIndikator: const OpdProgressDetail(
                    total: 12,
                    terisi: 4,
                    persentase: 33.33,
                  ),
                  hasilPenilaianAkhir: 3.25,
                  progressKoreksiWalidata: const OpdProgressDetail(
                    total: 12,
                    sudahDikoreksi: 2,
                    persentase: 16.67,
                  ),
                  progressEvaluasiAdmin: const OpdProgressDetail(
                    total: 12,
                    sudahDievaluasi: 1,
                    persentase: 8.33,
                  ),
                ),
              ]),
            ),
          ],
          child: const MaterialApp(home: OpdDashboardScreen()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Evaluasi Baru'), findsOneWidget);
      expect(
        find.text(
          'Ada 8 indikator lagi di Evaluasi Baru yang perlu Anda lengkapi.',
        ),
        findsOneWidget,
      );
      expect(find.text('Evaluasi Lama'), findsOneWidget);
      expect(find.text('LANJUTKAN PENGISIAN'), findsOneWidget);

      final footerCenter = tester
          .getCenter(find.byType(AppPaginationFooter))
          .dx;
      final viewCenter =
          tester.view.physicalSize.width / tester.view.devicePixelRatio / 2;
      expect((footerCenter - viewCenter).abs(), lessThan(1));
    },
  );

  testWidgets('error state does not show retry button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentUserProvider.overrideWith((ref) => null),
          opdDashboardControllerProvider.overrideWith(
            _ThrowingOpdDashboardController.new,
          ),
        ],
        child: const MaterialApp(home: OpdDashboardScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(
      find.text('Gagal memuat dasbor. Silakan coba lagi.'),
      findsOneWidget,
    );
    expect(find.text('Coba Lagi'), findsNothing);
  });
}

class _FakeOpdDashboardController extends OpdDashboardController {
  _FakeOpdDashboardController(this._value);

  final List<OpdDashboardProgress> _value;

  @override
  Future<PaginatedResponse<OpdDashboardProgress>> build() async =>
      PaginatedResponse<OpdDashboardProgress>(
        data: _value,
        meta: PaginationMeta(
          currentPage: 1,
          lastPage: 1,
          perPage: _value.length,
          total: _value.length,
          path: '/dashboard/progress-penilaian',
        ),
        links: const PaginationLinks(first: '', last: ''),
      );
}

class _ThrowingOpdDashboardController extends OpdDashboardController {
  @override
  Future<PaginatedResponse<OpdDashboardProgress>> build() async {
    throw Exception('dashboard gagal dimuat');
  }
}
