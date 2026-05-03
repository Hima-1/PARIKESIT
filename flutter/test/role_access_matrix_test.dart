import 'package:flutter_test/flutter_test.dart';
import 'package:parikesit/core/auth/role_access.dart';
import 'package:parikesit/core/auth/user_role.dart';
import 'package:parikesit/core/router/route_constants.dart';

void main() {
  group('RoleAccess.canAccessRoute', () {
    test('shared authenticated routes remain accessible to all roles', () {
      for (final route in [
        RouteConstants.home,
        RouteConstants.profile,
        RouteConstants.changePassword,
        RouteConstants.editProfile,
        RouteConstants.notifications,
      ]) {
        for (final role in [UserRole.opd, UserRole.walidata, UserRole.admin]) {
          expect(RoleAccess.canAccessRoute(role, route), isTrue);
        }
      }
    });

    test('OPD can access OPD self-assessment', () {
      expect(
        RoleAccess.canAccessRoute(
          UserRole.opd,
          RouteConstants.assessmentMandiri,
        ),
        isTrue,
      );
      expect(
        RoleAccess.canAccessRoute(
          UserRole.opd,
          RouteConstants.assessmentKegiatan,
        ),
        isTrue,
      );
      expect(
        RoleAccess.canAccessRoute(UserRole.opd, '/penilaian-kegiatan/123'),
        isTrue,
      );
    });

    test('Walidata/Admin cannot access OPD self-assessment', () {
      expect(
        RoleAccess.canAccessRoute(
          UserRole.walidata,
          RouteConstants.assessmentMandiri,
        ),
        isFalse,
      );
      expect(
        RoleAccess.canAccessRoute(
          UserRole.admin,
          RouteConstants.assessmentMandiri,
        ),
        isFalse,
      );
    });

    test('Only Admin can access /admin routes', () {
      expect(
        RoleAccess.canAccessRoute(UserRole.admin, RouteConstants.adminUsers),
        isTrue,
      );
      expect(
        RoleAccess.canAccessRoute(UserRole.opd, RouteConstants.adminUsers),
        isFalse,
      );
      expect(
        RoleAccess.canAccessRoute(UserRole.walidata, RouteConstants.adminUsers),
        isFalse,
      );
    });

    test(
      'OPD can access completed assessment self-review routes but not cross-OPD review routes',
      () {
        expect(
          RoleAccess.canAccessRoute(
            UserRole.opd,
            RouteConstants.assessmentSelesai,
          ),
          isTrue,
        );
        expect(
          RoleAccess.canAccessRoute(
            UserRole.opd,
            RouteConstants.assessmentReview,
          ),
          isTrue,
        );
        expect(
          RoleAccess.canAccessRoute(UserRole.opd, '/penilaian-selesai/123'),
          isTrue,
        );
        expect(
          RoleAccess.canAccessRoute(
            UserRole.opd,
            '/penilaian-selesai/123/domain/1',
          ),
          isTrue,
        );
        expect(
          RoleAccess.canAccessRoute(
            UserRole.opd,
            '/penilaian-selesai/123/domain/1/indicator/2',
          ),
          isTrue,
        );
        expect(
          RoleAccess.canAccessRoute(
            UserRole.opd,
            '/penilaian-selesai/123/summary',
          ),
          isFalse,
        );
        expect(
          RoleAccess.canAccessRoute(
            UserRole.opd,
            '/penilaian-selesai/123/opds',
          ),
          isFalse,
        );
        expect(
          RoleAccess.canAccessRoute(
            UserRole.opd,
            '/penilaian-selesai/123/opd/9',
          ),
          isFalse,
        );
        expect(
          RoleAccess.canAccessRoute(
            UserRole.opd,
            '/penilaian-selesai/123/opd/9/domain/1',
          ),
          isFalse,
        );
        expect(
          RoleAccess.canAccessRoute(
            UserRole.opd,
            '/penilaian-selesai/123/opd/9/domain/1/indicator/2',
          ),
          isFalse,
        );
        expect(
          RoleAccess.canAccessRoute(
            UserRole.opd,
            RouteConstants.assessmentOpdSelection,
          ),
          isFalse,
        );
        expect(
          RoleAccess.canAccessRoute(
            UserRole.opd,
            RouteConstants.assessmentOpdReview,
          ),
          isFalse,
        );
      },
    );

    test(
      'Walidata/Admin can access cross-OPD review routes but not OPD self-review branches',
      () {
        for (final role in [UserRole.walidata, UserRole.admin]) {
          expect(
            RoleAccess.canAccessRoute(role, RouteConstants.assessmentSelesai),
            isTrue,
          );
          expect(
            RoleAccess.canAccessRoute(role, '/penilaian-selesai/123'),
            isTrue,
          );
          expect(
            RoleAccess.canAccessRoute(role, '/penilaian-selesai/123/domain/1'),
            isFalse,
          );
          expect(
            RoleAccess.canAccessRoute(role, '/penilaian-selesai/123/summary'),
            isTrue,
          );
          expect(
            RoleAccess.canAccessRoute(role, '/penilaian-selesai/123/opds'),
            isTrue,
          );
          expect(
            RoleAccess.canAccessRoute(role, '/penilaian-selesai/123/opd/9'),
            isTrue,
          );
          expect(
            RoleAccess.canAccessRoute(
              role,
              '/penilaian-selesai/123/opd/9/domain/1',
            ),
            isTrue,
          );
          expect(
            RoleAccess.canAccessRoute(
              role,
              '/penilaian-selesai/123/opd/9/domain/1/indicator/2',
            ),
            isTrue,
          );
        }
      },
    );

    test('unmapped routes are denied by default', () {
      for (final role in [UserRole.opd, UserRole.walidata, UserRole.admin]) {
        expect(RoleAccess.canAccessRoute(role, '/unknown-route'), isFalse);
        expect(
          RoleAccess.canAccessRoute(role, '/penilaian-selesai/123/unmapped'),
          isFalse,
        );
      }
    });

    test(
      'OPD and Walidata can access dokumentasi kegiatan but not pembinaan',
      () {
        for (final role in [UserRole.opd, UserRole.walidata]) {
          expect(
            RoleAccess.canAccessRoute(role, RouteConstants.dokumentasiKegiatan),
            isTrue,
          );
          expect(
            RoleAccess.canAccessRoute(role, '/dokumentasi-kegiatan/123'),
            isTrue,
          );
          expect(
            RoleAccess.canAccessRoute(role, RouteConstants.pembinaan),
            isFalse,
          );
          expect(
            RoleAccess.canAccessRoute(role, '/dokumentasi-pembinaan/123'),
            isFalse,
          );
        }
      },
    );

    test('Admin can access dokumentasi kegiatan and pembinaan routes', () {
      expect(
        RoleAccess.canAccessRoute(
          UserRole.admin,
          RouteConstants.dokumentasiKegiatan,
        ),
        isTrue,
      );
      expect(
        RoleAccess.canAccessRoute(UserRole.admin, '/dokumentasi-kegiatan/123'),
        isTrue,
      );
      expect(
        RoleAccess.canAccessRoute(UserRole.admin, RouteConstants.pembinaan),
        isTrue,
      );
      expect(
        RoleAccess.canAccessRoute(UserRole.admin, '/dokumentasi-pembinaan/123'),
        isTrue,
      );
    });
  });

  group('RoleAccess.canPerform', () {
    test('only Walidata can correct, only Admin can final-evaluate', () {
      expect(
        RoleAccess.canPerform(UserRole.opd, RoleAction.walidataCorrection),
        isFalse,
      );
      expect(
        RoleAccess.canPerform(UserRole.walidata, RoleAction.walidataCorrection),
        isTrue,
      );
      expect(
        RoleAccess.canPerform(UserRole.admin, RoleAction.walidataCorrection),
        isFalse,
      );

      expect(
        RoleAccess.canPerform(UserRole.opd, RoleAction.adminFinalEvaluation),
        isFalse,
      );
      expect(
        RoleAccess.canPerform(
          UserRole.walidata,
          RoleAction.adminFinalEvaluation,
        ),
        isFalse,
      );
      expect(
        RoleAccess.canPerform(UserRole.admin, RoleAction.adminFinalEvaluation),
        isTrue,
      );
    });
  });
}
