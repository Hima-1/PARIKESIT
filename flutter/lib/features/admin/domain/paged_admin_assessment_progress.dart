import 'admin_assessment_progress.dart';

class PagedAdminAssessmentProgress {
  const PagedAdminAssessmentProgress({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  final List<AdminAssessmentProgress> items;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  bool get hasNextPage => currentPage < lastPage;
  bool get hasPreviousPage => currentPage > 1;
  bool get isEmpty => items.isEmpty;
}
