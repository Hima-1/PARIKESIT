class RouteConstants {
  // Public
  static const String landing = '/';
  static const String authBootstrap = '/auth-bootstrap';

  // Auth
  static const String login = '/login';
  static const String profile = '/profile';
  static const String changePassword = '/profile/change-password';
  static const String editProfile = '/profile/edit';

  // Core
  static const String home = '/home';
  static const String notifications = '/notifications';
  static const String pembinaan = '/dokumentasi-pembinaan';
  static const String dokumentasiKegiatan = '/dokumentasi-kegiatan';
  static const String dokumentasiKegiatanDetail = '/dokumentasi-kegiatan/:id';
  static const String dokumentasiPembinaanDetail = '/dokumentasi-pembinaan/:id';

  // Admin Dokumentasi
  static const String adminDokumentasi = '/admin/dokumentasi';
  static const String adminDokumentasiDetail = '/admin/dokumentasi/:id';

  // Admin
  static const String adminDashboard = '/admin';
  static const String adminUsers = '/admin/users';

  // Assessment
  static const String assessmentKegiatan = '/penilaian-kegiatan';
  static const String assessmentTambah = '/penilaian-kegiatan/tambah';
  static const String assessmentDetail = '/penilaian-kegiatan/:id';
  static const String assessmentEdit = '/penilaian-kegiatan/:id/edit';
  static const String assessmentTambahDomain =
      '/penilaian-kegiatan/:id/tambah-domain';

  static const String assessmentMandiri = '/penilaian-mandiri';
  static const String assessmentSelesai = '/penilaian-selesai';
  static const String assessmentSummary =
      '/penilaian-selesai/:activityId/summary';
  static const String publicAssessmentOpdSelection =
      '/publik/penilaian-selesai/:activityId/opds';
  static const String publicAssessmentOpdReview =
      '/publik/penilaian-selesai/:activityId/opd/:opdId';
  static const String publicAssessmentDomainReview =
      '/publik/penilaian-selesai/:activityId/opd/:opdId/domain/:domainId';
  static const String publicAssessmentIndicatorReview =
      '/publik/penilaian-selesai/:activityId/opd/:opdId/domain/:domainId/indicator/:indicatorId';
  static const String assessmentReview = '/penilaian-selesai/:activityId';
  static const String assessmentSelfDomain =
      '/penilaian-selesai/:activityId/domain/:domainId';
  static const String assessmentSelfIndicator =
      '/penilaian-selesai/:activityId/domain/:domainId/indicator/:indicatorId';
  static const String assessmentOpdSelection =
      '/penilaian-selesai/:activityId/opds';
  static const String assessmentOpdReview =
      '/penilaian-selesai/:activityId/opd/:opdId';
  static const String assessmentDomainCorrection =
      '/penilaian-selesai/:activityId/opd/:opdId/domain/:domainId';
  static const String assessmentIndicatorComparison =
      '/penilaian-selesai/:activityId/opd/:opdId/domain/:domainId/indicator/:indicatorId';

  static String buildAssessmentDomainPath({
    required String activityId,
    required String domainId,
    String? opdId,
    required bool isSelfReview,
  }) {
    final String template = isSelfReview
        ? assessmentSelfDomain
        : assessmentDomainCorrection;

    final String path = template
        .replaceFirst(':activityId', activityId)
        .replaceFirst(':domainId', domainId);

    if (isSelfReview) {
      return path;
    }

    if (opdId == null || opdId.isEmpty) {
      throw ArgumentError.value(
        opdId,
        'opdId',
        'opdId is required for cross-OPD review routes.',
      );
    }

    return path.replaceFirst(':opdId', opdId);
  }

  static String buildAssessmentIndicatorPath({
    required String activityId,
    required String domainId,
    required String indicatorId,
    String? opdId,
    required bool isSelfReview,
  }) {
    final String template = isSelfReview
        ? assessmentSelfIndicator
        : assessmentIndicatorComparison;

    final String path = template
        .replaceFirst(':activityId', activityId)
        .replaceFirst(':domainId', domainId)
        .replaceFirst(':indicatorId', indicatorId);

    if (isSelfReview) {
      return path;
    }

    if (opdId == null || opdId.isEmpty) {
      throw ArgumentError.value(
        opdId,
        'opdId',
        'opdId is required for cross-OPD review routes.',
      );
    }

    return path.replaceFirst(':opdId', opdId);
  }

  static String buildPublicAssessmentDomainPath({
    required String activityId,
    required String opdId,
    required String domainId,
  }) {
    return publicAssessmentDomainReview
        .replaceFirst(':activityId', activityId)
        .replaceFirst(':opdId', opdId)
        .replaceFirst(':domainId', domainId);
  }

  static String buildPublicAssessmentIndicatorPath({
    required String activityId,
    required String opdId,
    required String domainId,
    required String indicatorId,
  }) {
    return publicAssessmentIndicatorReview
        .replaceFirst(':activityId', activityId)
        .replaceFirst(':opdId', opdId)
        .replaceFirst(':domainId', domainId)
        .replaceFirst(':indicatorId', indicatorId);
  }
}
