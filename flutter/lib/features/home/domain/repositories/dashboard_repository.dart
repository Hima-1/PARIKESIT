import 'package:parikesit/core/network/paginated_response.dart';

import '../dashboard_stats.dart';
import '../opd_dashboard_progress.dart';
import '../opd_performance.dart';
import '../walidata_dashboard_progress.dart';

abstract class IDashboardRepository {
  Future<DashboardStats> getDashboardStats();
  Future<List<OpdPerformance>> getOpdPerformance();
  Future<List<OpdDashboardProgress>> getOpdProgressData();
  Future<PaginatedResponse<OpdDashboardProgress>> getOpdProgressPage({
    int page = 1,
    int perPage = 10,
  });
  Future<List<WalidataDashboardProgress>> getWalidataProgressData();
}
