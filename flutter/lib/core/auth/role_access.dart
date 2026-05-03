import '../router/route_constants.dart';
import 'user_role.dart';

enum RoleAction { walidataCorrection, adminFinalEvaluation }

class RoleAccess {
  const RoleAccess._();

  static final RegExp _assessmentReviewPath = RegExp(
    r'^/penilaian-selesai/[^/]+$',
  );
  static final RegExp _assessmentSelfDomainPath = RegExp(
    r'^/penilaian-selesai/[^/]+/domain/[^/]+$',
  );
  static final RegExp _assessmentSelfIndicatorPath = RegExp(
    r'^/penilaian-selesai/[^/]+/domain/[^/]+/indicator/[^/]+$',
  );
  static final RegExp _assessmentSummaryPath = RegExp(
    r'^/penilaian-selesai/[^/]+/summary$',
  );
  static final RegExp _assessmentOpdSelectionPath = RegExp(
    r'^/penilaian-selesai/[^/]+/opds$',
  );
  static final RegExp _assessmentOpdReviewPath = RegExp(
    r'^/penilaian-selesai/[^/]+/opd/[^/]+$',
  );
  static final RegExp _assessmentDomainCorrectionPath = RegExp(
    r'^/penilaian-selesai/[^/]+/opd/[^/]+/domain/[^/]+$',
  );
  static final RegExp _assessmentIndicatorComparisonPath = RegExp(
    r'^/penilaian-selesai/[^/]+/opd/[^/]+/domain/[^/]+/indicator/[^/]+$',
  );

  static bool canAccessRoute(UserRole role, String matchedLocation) {
    if (role == UserRole.unknown) return false;

    // Authenticated shell routes are generally available.
    if (matchedLocation == RouteConstants.home ||
        matchedLocation == RouteConstants.profile ||
        matchedLocation == RouteConstants.changePassword ||
        matchedLocation == RouteConstants.editProfile ||
        matchedLocation == RouteConstants.notifications) {
      return true;
    }

    if (matchedLocation == RouteConstants.dokumentasiKegiatan ||
        matchedLocation.startsWith('/dokumentasi-kegiatan/')) {
      return role == UserRole.opd ||
          role == UserRole.walidata ||
          role == UserRole.admin;
    }

    if (matchedLocation == RouteConstants.pembinaan ||
        matchedLocation.startsWith('/dokumentasi-pembinaan/')) {
      return role == UserRole.admin;
    }

    // Admin area
    if (matchedLocation.startsWith('/admin')) {
      return role == UserRole.admin;
    }

    // OPD-only self assessment
    if (matchedLocation == RouteConstants.assessmentMandiri) {
      return role == UserRole.opd;
    }

    // Assessment finished/review flow.
    if (matchedLocation == RouteConstants.assessmentSelesai) {
      return role == UserRole.opd ||
          role == UserRole.walidata ||
          role == UserRole.admin;
    }

    // OPD may open their own completed assessment detail screen directly from
    // the history list, but they must not access cross-OPD review flows.
    if (matchedLocation == RouteConstants.assessmentReview ||
        _assessmentReviewPath.hasMatch(matchedLocation)) {
      return role == UserRole.opd ||
          role == UserRole.walidata ||
          role == UserRole.admin;
    }

    if (matchedLocation == RouteConstants.assessmentSelfDomain ||
        _assessmentSelfDomainPath.hasMatch(matchedLocation) ||
        matchedLocation == RouteConstants.assessmentSelfIndicator ||
        _assessmentSelfIndicatorPath.hasMatch(matchedLocation)) {
      return role == UserRole.opd;
    }

    if (matchedLocation == RouteConstants.assessmentSummary ||
        _assessmentSummaryPath.hasMatch(matchedLocation)) {
      return role == UserRole.walidata || role == UserRole.admin;
    }

    if (matchedLocation == RouteConstants.assessmentOpdSelection ||
        _assessmentOpdSelectionPath.hasMatch(matchedLocation)) {
      return role == UserRole.walidata || role == UserRole.admin;
    }

    if (matchedLocation == RouteConstants.assessmentOpdReview ||
        _assessmentOpdReviewPath.hasMatch(matchedLocation)) {
      return role == UserRole.walidata || role == UserRole.admin;
    }

    if (matchedLocation == RouteConstants.assessmentDomainCorrection ||
        _assessmentDomainCorrectionPath.hasMatch(matchedLocation) ||
        matchedLocation == RouteConstants.assessmentIndicatorComparison) {
      return role == UserRole.walidata || role == UserRole.admin;
    }

    if (_assessmentIndicatorComparisonPath.hasMatch(matchedLocation)) {
      return role == UserRole.walidata || role == UserRole.admin;
    }

    // Assessment kegiatan: OPD creates and fills.
    if (matchedLocation.startsWith('/penilaian-kegiatan')) {
      return role == UserRole.opd;
    }

    return false;
  }

  static bool canPerform(UserRole role, RoleAction action) {
    return switch (action) {
      RoleAction.walidataCorrection => role == UserRole.walidata,
      RoleAction.adminFinalEvaluation => role == UserRole.admin,
    };
  }
}
