import 'package:flutter_test/flutter_test.dart';
import 'package:parikesit/core/router/route_constants.dart';
import 'package:parikesit/features/notifications/data/notification_navigation.dart';

void main() {
  test('summary notifications open the self assessment list', () {
    expect(
      resolveNotificationTargetRoute(const {
        'type': incompleteFormSummaryType,
        'target_route': '/penilaian-kegiatan',
      }),
      RouteConstants.assessmentMandiri,
    );
  });

  test(
    'reminder notifications require a valid formulir id for detail route',
    () {
      expect(
        resolveNotificationTargetRoute(const {
          'type': incompleteFormReminderType,
          'target_route': '/penilaian-kegiatan?formulirId=7',
        }),
        '/penilaian-kegiatan?formulirId=7',
      );

      expect(
        resolveNotificationTargetRoute(const {
          'type': incompleteFormReminderType,
          'target_route': '/penilaian-kegiatan',
        }),
        RouteConstants.assessmentMandiri,
      );
    },
  );

  test('reminder route can be derived from legacy payload ids', () {
    expect(
      resolveNotificationTargetRoute(const {
        'type': incompleteFormReminderType,
        'formulir_id': '8',
      }),
      '/penilaian-kegiatan?formulirId=8',
    );

    expect(
      resolveNotificationTargetRoute(const {
        'type': incompleteFormReminderType,
        'formulir_id': '0',
        'activity_id': '9',
      }),
      '/penilaian-kegiatan?formulirId=9',
    );
  });
}
