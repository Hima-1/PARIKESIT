import 'package:flutter_test/flutter_test.dart';
import 'package:parikesit/core/router/route_constants.dart';

void main() {
  group('RouteConstants review path builders', () {
    test('buildAssessmentDomainPath keeps opdId for cross-OPD review', () {
      expect(
        RouteConstants.buildAssessmentDomainPath(
          activityId: '12',
          domainId: '10',
          opdId: '77',
          isSelfReview: false,
        ),
        '/penilaian-selesai/12/opd/77/domain/10',
      );
    });

    test('buildAssessmentIndicatorPath keeps opdId for cross-OPD review', () {
      expect(
        RouteConstants.buildAssessmentIndicatorPath(
          activityId: '12',
          domainId: '10',
          indicatorId: '382',
          opdId: '77',
          isSelfReview: false,
        ),
        '/penilaian-selesai/12/opd/77/domain/10/indicator/382',
      );
    });

    test('cross-OPD builders reject missing opdId', () {
      expect(
        () => RouteConstants.buildAssessmentIndicatorPath(
          activityId: '12',
          domainId: '10',
          indicatorId: '382',
          isSelfReview: false,
        ),
        throwsArgumentError,
      );
    });
  });
}
