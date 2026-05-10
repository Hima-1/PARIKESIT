import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parikesit/core/network/paginated_response.dart';
import 'package:parikesit/features/assessment/data/assessment_repository.dart';
import 'package:parikesit/features/assessment/domain/assessment_models.dart';
import 'package:parikesit/features/assessment/domain/completed_assessment_query.dart';
import 'package:parikesit/features/assessment/domain/penilaian.dart';

void main() {
  test(
    'updateActivity sends PATCH request with nama_formulir payload',
    () async {
      final HttpServer server = await HttpServer.bind(
        InternetAddress.loopbackIPv4,
        0,
      );
      addTearDown(() async {
        await server.close(force: true);
      });

      late Map<String, dynamic> requestBody;
      late String requestMethod;
      late String requestPath;

      server.listen((HttpRequest request) async {
        requestMethod = request.method;
        requestPath = request.uri.path;
        final String body = await utf8.decoder.bind(request).join();
        requestBody = jsonDecode(body) as Map<String, dynamic>;

        request.response.headers.contentType = ContentType.json;
        request.response.write(
          jsonEncode(<String, dynamic>{
            'data': <String, dynamic>{
              'id': 7,
              'nama_formulir': 'Formulir Baru',
              'created_at': '2026-03-13T00:00:00.000Z',
              'domains': <dynamic>[],
            },
          }),
        );
        await request.response.close();
      });

      final AssessmentRepository repository = AssessmentRepository(
        Dio(
          BaseOptions(
            baseUrl: 'http://127.0.0.1:${server.port}',
            contentType: Headers.jsonContentType,
          ),
        ),
      );

      final result = await repository.updateActivity(7, 'Formulir Baru');

      expect(requestMethod, 'PATCH');
      expect(requestPath, '/formulir/7');
      expect(requestBody['nama_formulir'], 'Formulir Baru');
      expect(result.title, 'Formulir Baru');
    },
  );

  test('deleteActivity sends DELETE request to formulir endpoint', () async {
    final HttpServer server = await HttpServer.bind(
      InternetAddress.loopbackIPv4,
      0,
    );
    addTearDown(() async {
      await server.close(force: true);
    });

    late String requestMethod;
    late String requestPath;

    server.listen((HttpRequest request) async {
      requestMethod = request.method;
      requestPath = request.uri.path;
      request.response.statusCode = HttpStatus.ok;
      await request.response.close();
    });

    final AssessmentRepository repository = AssessmentRepository(
      Dio(BaseOptions(baseUrl: 'http://127.0.0.1:${server.port}')),
    );

    await repository.deleteActivity(9);

    expect(requestMethod, 'DELETE');
    expect(requestPath, '/formulir/9');
  });

  test(
    'getCompletedActivities sends paginated query params and parses response',
    () async {
      final HttpServer server = await HttpServer.bind(
        InternetAddress.loopbackIPv4,
        0,
      );
      addTearDown(() async {
        await server.close(force: true);
      });

      late Uri requestUri;

      server.listen((HttpRequest request) async {
        requestUri = request.uri;
        request.response.headers.contentType = ContentType.json;
        request.response.write(
          jsonEncode(<String, dynamic>{
            'data': <Map<String, dynamic>>[
              <String, dynamic>{
                'id': 7,
                'nama_formulir': 'Formulir Baru',
                'created_at': '2026-03-13T00:00:00.000Z',
                'participating_opd_count': 12,
                'domains': <dynamic>[],
                'review_progress': <String, dynamic>{
                  'total_indicators': 10,
                  'corrected_count': 8,
                  'percentage': 80,
                  'final_correction_score': 4.25,
                  'pending_indicator_preview': <Map<String, dynamic>>[
                    <String, dynamic>{
                      'id': 91,
                      'nama': 'Indikator A',
                      'domain': 'Kebijakan',
                      'aspek': 'Perencanaan',
                      'user_id': 5,
                      'user_name': 'Dinas Kominfo',
                    },
                  ],
                },
              },
            ],
            'current_page': 2,
            'last_page': 5,
            'per_page': 10,
            'total': 42,
            'from': 11,
            'to': 20,
            'path': '/penilaian-selesai',
            'first_page_url': '/penilaian-selesai?page=1',
            'last_page_url': '/penilaian-selesai?page=5',
            'prev_page_url': '/penilaian-selesai?page=1',
            'next_page_url': '/penilaian-selesai?page=3',
          }),
        );
        await request.response.close();
      });

      final AssessmentRepository repository = AssessmentRepository(
        Dio(
          BaseOptions(
            baseUrl: 'http://127.0.0.1:${server.port}',
            contentType: Headers.jsonContentType,
          ),
        ),
      );

      final PaginatedResponse<AssessmentFormModel> result = await repository
          .getCompletedActivities(
            query: const CompletedAssessmentQuery(
              search: 'baru',
              sort: CompletedAssessmentSortField.name,
              direction: CompletedAssessmentSortDirection.asc,
              page: 2,
              perPage: 10,
            ),
          );

      expect(requestUri.path, '/penilaian-selesai');
      expect(requestUri.queryParameters['search'], 'baru');
      expect(requestUri.queryParameters['sort'], 'nama_formulir');
      expect(requestUri.queryParameters['direction'], 'asc');
      expect(requestUri.queryParameters['page'], '2');
      expect(requestUri.queryParameters['per_page'], '10');
      expect(result.items, hasLength(1));
      expect(result.items.first.title, 'Formulir Baru');
      expect(result.items.first.opdCount, 12);
      expect(result.items.first.reviewProgress?.correctedCount, 8);
      expect(
        result.items.first.reviewProgress?.pendingIndicatorPreview.first.name,
        'Indikator A',
      );
      expect(result.meta.currentPage, 2);
      expect(result.meta.lastPage, 5);
      expect(result.hasPreviousPage, isTrue);
      expect(result.hasNextPage, isTrue);
    },
  );

  test(
    'getPublicCompletedActivities sends public endpoint query params and parses response',
    () async {
      final HttpServer server = await HttpServer.bind(
        InternetAddress.loopbackIPv4,
        0,
      );
      addTearDown(() async {
        await server.close(force: true);
      });

      late Uri requestUri;

      server.listen((HttpRequest request) async {
        requestUri = request.uri;
        request.response.headers.contentType = ContentType.json;
        request.response.write(
          jsonEncode(<String, dynamic>{
            'data': <Map<String, dynamic>>[
              <String, dynamic>{
                'id': 71,
                'nama_formulir': 'Formulir Publik',
                'created_at': '2026-03-13T00:00:00.000Z',
              },
            ],
            'meta': <String, dynamic>{
              'current_page': 1,
              'last_page': 1,
              'per_page': 10,
              'total': 1,
              'from': 1,
              'to': 1,
              'path': '/public/penilaian-selesai',
            },
            'links': <String, dynamic>{
              'first': '/public/penilaian-selesai?page=1',
              'last': '/public/penilaian-selesai?page=1',
              'prev': null,
              'next': null,
            },
          }),
        );
        await request.response.close();
      });

      final AssessmentRepository repository = AssessmentRepository(
        Dio(
          BaseOptions(
            baseUrl: 'http://127.0.0.1:${server.port}',
            contentType: Headers.jsonContentType,
          ),
        ),
      );

      final result = await repository.getPublicCompletedActivities(
        query: const CompletedAssessmentQuery(
          search: 'publik',
          sort: CompletedAssessmentSortField.name,
          direction: CompletedAssessmentSortDirection.asc,
        ),
      );

      expect(requestUri.path, '/public/penilaian-selesai');
      expect(requestUri.queryParameters['search'], 'publik');
      expect(result.items, hasLength(1));
      expect(result.items.first.title, 'Formulir Publik');
    },
  );

  test('getOpdsForActivity parses OPD identity fields', () async {
    final HttpServer server = await HttpServer.bind(
      InternetAddress.loopbackIPv4,
      0,
    );
    addTearDown(() async {
      await server.close(force: true);
    });

    late Uri requestUri;

    server.listen((HttpRequest request) async {
      requestUri = request.uri;
      request.response.headers.contentType = ContentType.json;
      request.response.write(
        jsonEncode(<String, dynamic>{
          'data': <Map<String, dynamic>>[
            <String, dynamic>{
              'id': 5,
              'name': 'Dinas Kominfo',
              'role': 'opd',
              'nomor_telepon': '08123456789',
              'stats': <String, dynamic>{
                'opd_score': 3.5,
                'walidata_score': 4.0,
                'admin_score': 4.5,
              },
            },
          ],
          'current_page': 1,
          'last_page': 1,
          'per_page': 10,
          'total': 1,
          'from': 1,
          'to': 1,
          'path': '/penilaian-selesai/12/opds',
          'first_page_url': '/penilaian-selesai/12/opds?page=1',
          'last_page_url': '/penilaian-selesai/12/opds?page=1',
          'prev_page_url': null,
          'next_page_url': null,
        }),
      );
      await request.response.close();
    });

    final AssessmentRepository repository = AssessmentRepository(
      Dio(
        BaseOptions(
          baseUrl: 'http://127.0.0.1:${server.port}',
          contentType: Headers.jsonContentType,
        ),
      ),
    );

    final result = await repository.getOpdsForActivity('12');

    expect(requestUri.path, '/penilaian-selesai/12/opds');
    expect(requestUri.queryParameters['page'], '1');
    expect(requestUri.queryParameters['per_page'], '10');
    expect(result, hasLength(1));
    expect(result.first.name, 'Dinas Kominfo');
    expect(result.first.role, 'opd');
    expect(result.first.nomorTelepon, '08123456789');
    expect(result.first.adminScore, 4.5);
  });

  test('getPublicOpdsForActivity sends public opd endpoint', () async {
    final HttpServer server = await HttpServer.bind(
      InternetAddress.loopbackIPv4,
      0,
    );
    addTearDown(() async {
      await server.close(force: true);
    });

    late Uri requestUri;

    server.listen((HttpRequest request) async {
      requestUri = request.uri;
      request.response.headers.contentType = ContentType.json;
      request.response.write(
        jsonEncode(<String, dynamic>{
          'data': <Map<String, dynamic>>[
            <String, dynamic>{
              'id': 5,
              'name': 'Dinas Kominfo',
              'opd_score': 3.5,
              'walidata_score': 4.0,
              'admin_score': 4.5,
            },
          ],
          'current_page': 1,
          'last_page': 1,
          'per_page': 10,
          'total': 1,
          'from': 1,
          'to': 1,
          'path': '/public/penilaian-selesai/12/opds',
          'first_page_url': '/public/penilaian-selesai/12/opds?page=1',
          'last_page_url': '/public/penilaian-selesai/12/opds?page=1',
          'prev_page_url': null,
          'next_page_url': null,
        }),
      );
      await request.response.close();
    });

    final AssessmentRepository repository = AssessmentRepository(
      Dio(
        BaseOptions(
          baseUrl: 'http://127.0.0.1:${server.port}',
          contentType: Headers.jsonContentType,
        ),
      ),
    );

    final result = await repository.getPublicOpdsForActivity('12');

    expect(requestUri.path, '/public/penilaian-selesai/12/opds');
    expect(requestUri.queryParameters['page'], '1');
    expect(requestUri.queryParameters['per_page'], '10');
    expect(result, hasLength(1));
    expect(result.first.name, 'Dinas Kominfo');
    expect(result.first.adminScore, 4.5);
  });

  test(
    'getMyPenilaians selects the newest filled penilaian instead of the first list item',
    () async {
      final HttpServer server = await HttpServer.bind(
        InternetAddress.loopbackIPv4,
        0,
      );
      addTearDown(() async {
        await server.close(force: true);
      });

      server.listen((HttpRequest request) async {
        request.response.headers.contentType = ContentType.json;
        request.response.write(
          jsonEncode(
            _assessmentResponse(
              penilaianList: <Map<String, dynamic>>[
                <String, dynamic>{
                  'id': 11,
                  'formulir_id': 12,
                  'indikator_id': 382,
                  'user_id': 5,
                  'nilai': null,
                  'created_at': '2026-03-13T00:00:00.000Z',
                  'updated_at': '2026-03-13T00:00:00.000Z',
                },
                <String, dynamic>{
                  'id': 19,
                  'formulir_id': 12,
                  'indikator_id': 382,
                  'user_id': 5,
                  'nilai': 4,
                  'created_at': '2026-03-14T00:00:00.000Z',
                  'updated_at': '2026-03-15T00:00:00.000Z',
                  'nilai_diupdate': 3,
                  'nilai_koreksi': 2,
                },
              ],
            ),
          ),
        );
        await request.response.close();
      });

      final AssessmentRepository repository = AssessmentRepository(
        Dio(
          BaseOptions(
            baseUrl: 'http://127.0.0.1:${server.port}',
            contentType: Headers.jsonContentType,
          ),
        ),
      );

      final (AssessmentFormModel form, Map<int, Penilaian> penilaians) =
          await repository.getMyPenilaians(12);

      expect(form.id, '12');
      expect(
        form.domains.first.aspects.first.indicators.first.bobotIndikator,
        1.5,
      );
      expect(
        form.domains.first.aspects.first.indicators.first.level1Kriteria,
        'Level 1',
      );
      expect(penilaians[382]?.id, 19);
      expect(penilaians[382]?.nilai, 4);
      expect(penilaians[382]?.nilaiDiupdate, 3);
    },
  );

  test(
    'getIndicatorsForOpd ignores empty penilaian rows when no filled record exists',
    () async {
      final HttpServer server = await HttpServer.bind(
        InternetAddress.loopbackIPv4,
        0,
      );
      addTearDown(() async {
        await server.close(force: true);
      });

      server.listen((HttpRequest request) async {
        request.response.headers.contentType = ContentType.json;
        request.response.write(
          jsonEncode(
            _assessmentResponse(
              penilaianList: <Map<String, dynamic>>[
                <String, dynamic>{
                  'id': 22,
                  'formulir_id': 12,
                  'indikator_id': 382,
                  'user_id': 5,
                  'nilai': null,
                  'created_at': '2026-03-13T00:00:00.000Z',
                  'updated_at': '2026-03-13T00:00:00.000Z',
                },
              ],
            ),
          ),
        );
        await request.response.close();
      });

      final AssessmentRepository repository = AssessmentRepository(
        Dio(
          BaseOptions(
            baseUrl: 'http://127.0.0.1:${server.port}',
            contentType: Headers.jsonContentType,
          ),
        ),
      );

      final (AssessmentFormModel form, Map<int, Penilaian> penilaians) =
          await repository.getIndicatorsForOpd(12, 5);

      expect(form.id, '12');
      expect(penilaians, isEmpty);
    },
  );

  test('getIndicatorsForOpd sends user_id query parameter', () async {
    final HttpServer server = await HttpServer.bind(
      InternetAddress.loopbackIPv4,
      0,
    );
    addTearDown(() async {
      await server.close(force: true);
    });

    late Uri requestUri;

    server.listen((HttpRequest request) async {
      requestUri = request.uri;
      request.response.headers.contentType = ContentType.json;
      request.response.write(
        jsonEncode(
          _assessmentResponse(penilaianList: <Map<String, dynamic>>[]),
        ),
      );
      await request.response.close();
    });

    final AssessmentRepository repository = AssessmentRepository(
      Dio(
        BaseOptions(
          baseUrl: 'http://127.0.0.1:${server.port}',
          contentType: Headers.jsonContentType,
        ),
      ),
    );

    await repository.getIndicatorsForOpd(12, 5);

    expect(requestUri.path, '/formulir/12/indicators');
    expect(requestUri.queryParameters['user_id'], '5');
  });

  test('getPublicIndicatorsForOpd parses indicator criteria payload', () async {
    final HttpServer server = await HttpServer.bind(
      InternetAddress.loopbackIPv4,
      0,
    );
    addTearDown(() async {
      await server.close(force: true);
    });

    late String requestPath;
    server.listen((HttpRequest request) async {
      requestPath = request.uri.path;
      request.response.headers.contentType = ContentType.json;
      request.response.write(
        jsonEncode(
          _assessmentResponse(
            penilaianList: <Map<String, dynamic>>[
              <String, dynamic>{
                'id': 19,
                'formulir_id': 12,
                'indikator_id': 382,
                'user_id': 5,
                'nilai': 4,
                'created_at': '2026-03-14T00:00:00.000Z',
                'updated_at': '2026-03-15T00:00:00.000Z',
              },
            ],
          ),
        ),
      );
      await request.response.close();
    });

    final AssessmentRepository repository = AssessmentRepository(
      Dio(
        BaseOptions(
          baseUrl: 'http://127.0.0.1:${server.port}',
          contentType: Headers.jsonContentType,
        ),
      ),
    );

    final (AssessmentFormModel form, Map<int, Penilaian> penilaians) =
        await repository.getPublicIndicatorsForOpd(12, 5);

    expect(requestPath, '/public/penilaian-selesai/12/opd/5');
    expect(
      form.domains.first.aspects.first.indicators.first.level1Kriteria,
      'Level 1',
    );
    expect(
      form.domains.first.aspects.first.indicators.first.level2Kriteria,
      'Level 2',
    );
    expect(penilaians[382]?.nilai, 4);
  });

  test(
    'submitPenilaian sends bukti_dukung array multipart fields when files are attached',
    () async {
      final HttpServer server = await HttpServer.bind(
        InternetAddress.loopbackIPv4,
        0,
      );
      addTearDown(() async {
        await server.close(force: true);
      });

      final Directory tempDir = await Directory.systemTemp.createTemp(
        'assessment-repository-test-',
      );
      final File evidenceFile = File(
        '${tempDir.path}${Platform.pathSeparator}bukti-1.pdf',
      );
      final File secondEvidenceFile = File(
        '${tempDir.path}${Platform.pathSeparator}bukti-2.jpg',
      );
      await evidenceFile.writeAsString('dummy evidence');
      await secondEvidenceFile.writeAsString('dummy evidence 2');
      addTearDown(() async {
        if (await tempDir.exists()) {
          await tempDir.delete(recursive: true);
        }
      });

      late String requestMethod;
      late String requestPath;
      late String? contentType;
      late String requestBody;

      server.listen((HttpRequest request) async {
        requestMethod = request.method;
        requestPath = request.uri.path;
        contentType = request.headers.contentType?.mimeType;
        requestBody = await utf8.decoder.bind(request).join();

        request.response.headers.contentType = ContentType.json;
        request.response.write(
          jsonEncode(<String, dynamic>{
            'data': <String, dynamic>{
              'id': 501,
              'formulir_id': 12,
              'indikator_id': 382,
              'nilai': 4,
              'catatan': 'Dengan bukti dukung',
              'bukti_dukung': <String>[
                'bukti-dukung/test-1.pdf',
                'bukti-dukung/test-2.jpg',
              ],
              'created_at': '2026-03-29T00:00:00.000Z',
              'updated_at': '2026-03-29T00:00:00.000Z',
            },
          }),
        );
        await request.response.close();
      });

      final AssessmentRepository repository = AssessmentRepository(
        Dio(BaseOptions(baseUrl: 'http://127.0.0.1:${server.port}')),
      );

      final Penilaian result = await repository.submitPenilaian(12, 382, {
        'nilai': 4,
        'catatan': 'Dengan bukti dukung',
        'bukti_dukung_file_paths': <String>[
          evidenceFile.path,
          secondEvidenceFile.path,
        ],
      });

      expect(requestMethod, 'POST');
      expect(requestPath, '/formulir/12/indikator/382/penilaian');
      expect(contentType, 'multipart/form-data');
      expect(requestBody, contains('name="nilai"'));
      expect(requestBody, contains('\r\n4\r\n'));
      expect(requestBody, contains('name="catatan"'));
      expect(requestBody, contains('Dengan bukti dukung'));
      expect(
        requestBody,
        contains('name="bukti_dukung[]"; filename="bukti-1.pdf"'),
      );
      expect(
        requestBody,
        contains('name="bukti_dukung[]"; filename="bukti-2.jpg"'),
      );
      expect(result.indikatorId, 382);
      expect(result.nilai, 4);
      expect(result.buktiDukung, <String>[
        'bukti-dukung/test-1.pdf',
        'bukti-dukung/test-2.jpg',
      ]);
    },
  );

  test(
    'submitPenilaian parses bukti_dukung list response into a list',
    () async {
      final HttpServer server = await HttpServer.bind(
        InternetAddress.loopbackIPv4,
        0,
      );
      addTearDown(() async {
        await server.close(force: true);
      });

      server.listen((HttpRequest request) async {
        request.response.headers.contentType = ContentType.json;
        request.response.write(
          jsonEncode(<String, dynamic>{
            'data': <String, dynamic>{
              'id': 601,
              'formulir_id': 12,
              'indikator_id': 382,
              'nilai': 5,
              'catatan': 'List response',
              'bukti_dukung': <String>['bukti-dukung/server.pdf'],
              'created_at': '2026-03-29T00:00:00.000Z',
              'updated_at': '2026-03-29T00:00:00.000Z',
            },
          }),
        );
        await request.response.close();
      });

      final AssessmentRepository repository = AssessmentRepository(
        Dio(
          BaseOptions(
            baseUrl: 'http://127.0.0.1:${server.port}',
            contentType: Headers.jsonContentType,
          ),
        ),
      );

      final Penilaian result = await repository.submitPenilaian(12, 382, {
        'nilai': 5,
        'catatan': 'List response',
      });

      expect(result.buktiDukung, <String>['bukti-dukung/server.pdf']);
    },
  );
}

Map<String, dynamic> _assessmentResponse({
  required List<Map<String, dynamic>> penilaianList,
}) {
  return <String, dynamic>{
    'data': <String, dynamic>{
      'id': 12,
      'nama_formulir': 'Formulir Test',
      'created_at': '2026-03-13T00:00:00.000Z',
      'updated_at': '2026-03-15T00:00:00.000Z',
      'domains': <dynamic>[
        <String, dynamic>{
          'id': 10,
          'nama_domain': 'Domain A',
          'updated_at': '2026-03-15T00:00:00.000Z',
          'aspek': <dynamic>[
            <String, dynamic>{
              'id': 77,
              'nama_aspek': 'Aspek A',
              'indikator': <dynamic>[
                <String, dynamic>{
                  'id': 382,
                  'nama_indikator': 'Indikator A',
                  'bobot_indikator': 1.5,
                  'level_1_kriteria': 'Level 1',
                  'level_2_kriteria': 'Level 2',
                  'penilaian': penilaianList,
                },
              ],
            },
          ],
        },
      ],
    },
  };
}
