import 'package:flutter_test/flutter_test.dart';
import 'package:parikesit/core/auth/role_access.dart';
import 'package:parikesit/core/auth/user_role.dart';
import 'package:parikesit/core/router/route_constants.dart';

void main() {
  test('unknown role is not treated as OPD for OPD-only route', () {
    expect(parseUserRole(null), UserRole.unknown);
    expect(parseUserRole('???'), UserRole.unknown);

    final allowed = RoleAccess.canAccessRoute(
      UserRole.unknown,
      RouteConstants.assessmentMandiri,
    );
    expect(allowed, isFalse);
  });
}
