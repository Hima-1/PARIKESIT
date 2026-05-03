import 'package:flutter_test/flutter_test.dart';
import 'package:parikesit/core/network/laravel_response.dart';
import 'package:parikesit/core/network/paginated_response.dart';

void main() {
  group('PaginatedResponse Deserialization', () {
    test('should parse valid Laravel pagination JSON', () {
      final json = {
        'data': [
          {'id': 1, 'name': 'Item 1'},
          {'id': 2, 'name': 'Item 2'},
        ],
        'meta': {
          'current_page': 1,
          'last_page': 5,
          'per_page': 10,
          'total': 50,
          'path': 'http://example.com/api/items',
        },
        'links': {
          'first': 'http://example.com/api/items?page=1',
          'last': 'http://example.com/api/items?page=5',
          'next': 'http://example.com/api/items?page=2',
        },
      };

      final response = PaginatedResponse<Map<String, dynamic>>.fromJson(
        json,
        (json) => json as Map<String, dynamic>,
      );

      expect(response.data.length, 2);
      expect(response.meta.currentPage, 1);
      expect(response.meta.lastPage, 5);
      expect(response.meta.total, 50);
      expect(response.links.next, contains('page=2'));
    });

    test(
      'parses Laravel paginated payload into items and pagination state',
      () {
        final payload = <String, dynamic>{
          'data': [
            {'id': 1, 'name': 'Item 1'},
            {'id': 2, 'name': 'Item 2'},
          ],
          'meta': {
            'current_page': 2,
            'last_page': 4,
            'per_page': 15,
            'total': 53,
            'from': 16,
            'to': 30,
            'path': 'http://example.com/api/items',
          },
          'links': {
            'first': 'http://example.com/api/items?page=1',
            'last': 'http://example.com/api/items?page=4',
            'prev': 'http://example.com/api/items?page=1',
            'next': 'http://example.com/api/items?page=3',
          },
        };

        final response = parseLaravelPaginatedResponse<Map<String, dynamic>>(
          payload,
          (json) => json,
          label: 'items',
        );

        expect(response.items, hasLength(2));
        expect(response.meta.currentPage, 2);
        expect(response.meta.lastPage, 4);
        expect(response.hasPreviousPage, isTrue);
        expect(response.hasNextPage, isTrue);
      },
    );
  });

  group('Laravel resource parsing', () {
    test('parses resource object from root payload', () {
      final payload = <String, dynamic>{'id': 7, 'name': 'Admin'};

      final result = parseLaravelResourceObject<Map<String, dynamic>>(
        payload,
        (json) => json,
        label: 'user',
      );

      expect(result, payload);
    });

    test('parses resource object from wrapped data payload', () {
      final payload = <String, dynamic>{
        'success': true,
        'message': 'User created successfully',
        'data': {'id': 9, 'name': 'Operator'},
      };

      final result = parseLaravelResourceObject<Map<String, dynamic>>(
        payload,
        (json) => json,
        label: 'user',
      );

      expect(result, {'id': 9, 'name': 'Operator'});
    });

    test('throws when wrapped data payload is not a JSON object', () {
      final payload = <String, dynamic>{
        'success': true,
        'message': 'invalid',
        'data': <dynamic>[],
      };

      expect(
        () => parseLaravelResourceObject<Map<String, dynamic>>(
          payload,
          (json) => json,
          label: 'user',
        ),
        throwsA(
          isA<LaravelResponseFormatException>().having(
            (error) => error.message,
            'message',
            contains('expected `data` to be a JSON object'),
          ),
        ),
      );
    });
  });
}
