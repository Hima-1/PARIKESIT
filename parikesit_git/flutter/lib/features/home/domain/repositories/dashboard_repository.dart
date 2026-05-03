import '../dashboard_stats.dart';
import '../opd_dashboard_progress.dart';
import '../opd_performance.dart';
import '../walidata_dashboard_progress.dart';

abstract class IDashboardRepository {
  Future<DashboardStats> getDashboardStats();
  Future<List<OpdPerformance>> getOpdPerformance();
  Future<List<OpdDashboardProgress>> getOpdProgressData();
  Future<List<WalidataDashboardProgress>> getWalidataProgressData();
}
