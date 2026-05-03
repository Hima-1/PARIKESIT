import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'dashboard_remote_data_source.g.dart';

@RestApi()
abstract class DashboardRemoteDataSource {
  factory DashboardRemoteDataSource(Dio dio, {String? baseUrl}) =
      _DashboardRemoteDataSource;

  @GET('/dashboard/stats')
  Future<HttpResponse<dynamic>> getDashboardStats();

  @GET('/dashboard/performa-opd')
  Future<HttpResponse<dynamic>> getOpdPerformance();
}
