import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parikesit/core/network/laravel_response.dart';
import 'package:parikesit/core/network/paginated_response.dart';
import 'package:parikesit/features/admin/data/admin_user_repository.dart';

void main() {
  test(
    'getUsers requests default admin paging and returns pagination metadata',
    () async {
      final adapter = _FakeHttpClientAdapter((options) {
        expect(options.path, '/users');
        expect(options.queryParameters, <String, dynamic>{
          'page': 1,
          'sort': 'created_at',
          'direction': 'desc',
          'per_page': 15,
        });

        return ResponseBody.fromString(
          jsonEncode({
            'data': [
              {
                'id': 1,
                'name': 'Admin',
                'email': 'admin@example.com',
                'role': 'admin',
              },
              {
                'id': 2,
                'name': 'OPD Satu',
                'email': 'opd@example.com',
                'role': 'opd',
              },
              {
                'id': 3,
                'name': 'Walidata',
                'email': 'walidata@example.com',
                'role': 'walidata',
              },
            ],
            'meta': {
              'current_page': 1,
              'last_page': 2,
              'per_page': 15,
              'total': 18,
              'path': 'http://localhost/api/users',
            },
            'links': {
              'first': 'http://localhost/api/users?page=1',
              'last': 'http://localhost/api/users?page=2',
              'next': 'http://localhost/api/users?page=2',
              'prev': null,
            },
          }),
          200,
          headers: {
            Headers.contentTypeHeader: ['application/json'],
          },
        );
      });

      final dio = Dio()..httpClientAdapter = adapter;
      final repository = AdminUserRepositoryImpl(dio);

      final users = await repository.getUsers();

      expect(users.items.map((user) => user.role), [
        'admin',
        'opd',
        'walidata',
      ]);
      expect(users.meta.total, 18);
      expect(users.hasNextPage, isTrue);
    },
  );

  test('getUsers keeps explicit perPage override when provided', () async {
    final adapter = _FakeHttpClientAdapter((options) {
      expect(options.queryParameters, <String, dynamic>{
        'page': 2,
        'search': 'kominfo',
        'sort': 'name',
        'direction': 'asc',
        'per_page': 25,
      });

      return ResponseBody.fromString(
        jsonEncode({
          'data': <Map<String, dynamic>>[],
          'meta': {
            'current_page': 2,
            'last_page': 2,
            'per_page': 25,
            'total': 25,
            'path': 'http://localhost/api/users',
          },
          'links': {
            'first': 'http://localhost/api/users?page=1',
            'last': 'http://localhost/api/users?page=2',
            'next': null,
            'prev': 'http://localhost/api/users?page=1',
          },
        }),
        200,
        headers: {
          Headers.contentTypeHeader: ['application/json'],
        },
      );
    });

    final dio = Dio()..httpClientAdapter = adapter;
    final repository = AdminUserRepositoryImpl(dio);

    final users = await repository.getUsers(
      page: 2,
      search: 'kominfo',
      sort: UserSortField.name,
      direction: SortDirection.asc,
      perPage: 25,
    );

    expect(users, isA<PaginatedResponse<dynamic>>());
    expect(users.items, isEmpty);
    expect(users.hasPreviousPage, isTrue);
  });

  test(
    'resetPassword returns the temporary password from API response',
    () async {
      final adapter = _FakeHttpClientAdapter((options) {
        expect(options.path, '/users/7/reset-password');

        return ResponseBody.fromString(
          jsonEncode({
            'message': 'Password sementara berhasil dibuat.',
            'data': {'temporary_password': 'TempPass#123456'},
          }),
          200,
          headers: {
            Headers.contentTypeHeader: ['application/json'],
          },
        );
      });

      final dio = Dio()..httpClientAdapter = adapter;
      final repository = AdminUserRepositoryImpl(dio);

      final result = await repository.resetPassword(7);

      expect(result.temporaryPassword, 'TempPass#123456');
    },
  );

  test('resetPassword throws when temporary_password is missing', () async {
    final adapter = _FakeHttpClientAdapter((_) {
      return ResponseBody.fromString(
        jsonEncode({
          'message': 'Password sementara berhasil dibuat.',
          'data': <String, dynamic>{},
        }),
        200,
        headers: {
          Headers.contentTypeHeader: ['application/json'],
        },
      );
    });

    final dio = Dio()..httpClientAdapter = adapter;
    final repository = AdminUserRepositoryImpl(dio);

    await expectLater(
      repository.resetPassword(7),
      throwsA(isA<LaravelResponseFormatException>()),
    );
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
