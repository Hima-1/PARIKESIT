import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parikesit/features/admin/data/admin_dashboard_repository.dart';
import 'package:parikesit/features/admin/domain/admin_assessment_progress_query.dart';

void main() {
  test(
    'parses paged admin dashboard progress and forwards query params',
    () async {
      final adapter = _FakeHttpClientAdapter((options) {
        expect(options.path, '/dashboard/progress-penilaian');
        expect(options.queryParameters, <String, dynamic>{
          'page': 2,
          'per_page': 5,
          'search': 'dinas',
          'sort_by': 'nama',
          'sort_direction': 'asc',
        });

        return ResponseBody.fromString(
          jsonEncode({
            'data': [
              {
                'id': 1,
                'nama': 'Dinas Kominfo',
                'tanggal': '2026-03-14T00:00:00.000Z',
                'opd_filled_count': 2,
                'opd_total_count': 4,
                'walidata_corrected_count': 1,
                'walidata_total_count': 4,
              },
            ],
            'meta': {
              'current_page': 2,
              'last_page': 3,
              'per_page': 5,
              'total': 11,
            },
          }),
          200,
          headers: {
            Headers.contentTypeHeader: ['application/json'],
          },
        );
      });

      final dio = Dio()..httpClientAdapter = adapter;
      final repository = AdminDashboardRepositoryImpl(dio);

      final page = await repository.getAssessmentProgressPage(
        const AdminAssessmentProgressQuery(
          page: 2,
          perPage: 5,
          search: 'dinas',
          sortBy: AdminAssessmentProgressSortBy.name,
          sortDirection: SortDirection.asc,
        ),
      );

      expect(page.currentPage, 2);
      expect(page.lastPage, 3);
      expect(page.perPage, 5);
      expect(page.total, 11);
      expect(page.items.single.name, 'Dinas Kominfo');
    },
  );

  test('falls back when paginator meta is missing', () async {
    final adapter = _FakeHttpClientAdapter((_) {
      return ResponseBody.fromString(
        jsonEncode({
          'data': [
            {
              'id': 7,
              'nama': 'Bappeda',
              'tanggal': '2026-03-14T00:00:00.000Z',
              'opd_filled_count': 0,
              'opd_total_count': 0,
              'walidata_corrected_count': 0,
              'walidata_total_count': 0,
            },
          ],
        }),
        200,
        headers: {
          Headers.contentTypeHeader: ['application/json'],
        },
      );
    });

    final dio = Dio()..httpClientAdapter = adapter;
    final repository = AdminDashboardRepositoryImpl(dio);

    final page = await repository.getAssessmentProgressPage(
      const AdminAssessmentProgressQuery(),
    );

    expect(page.currentPage, 1);
    expect(page.lastPage, 1);
    expect(page.perPage, 10);
    expect(page.total, 1);
  });
}

class _FakeHttpClientAdapter implements HttpClientAdapter {
  _FakeHttpClientAdapter(this._handler);

  final ResponseBody Function(RequestOptions options) _handler;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return _handler(options);
  }
}
