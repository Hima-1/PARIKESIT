import 'dart:io';

import 'package:dio/dio.dart';
import 'package:parikesit/features/assessment/domain/assessment_models.dart';
import 'package:retrofit/retrofit.dart';

import '../../../core/api/api_response.dart';
import '../domain/bukti_dukung.dart';
import '../domain/penilaian.dart';

part 'penilaian_client.g.dart';

@RestApi()
abstract class PenilaianClient {
  factory PenilaianClient(Dio dio, {String baseUrl}) = _PenilaianClient;

  @GET('/formulirs')
  Future<ApiResponse<List<AssessmentFormModel>>> getActivities();

  @GET('/formulir/{id}')
  Future<ApiResponse<AssessmentFormModel>> getFormulir(@Path('id') int id);

  @POST('/formulirs')
  Future<ApiResponse<dynamic>> addActivity(
    @Body() Map<String, dynamic> activity,
  );

  @POST('/formulir-domains')
  Future<ApiResponse<dynamic>> addDomain(@Body() Map<String, dynamic> data);

  @POST('/penilaians')
  Future<ApiResponse<Penilaian>> submitPenilaian(
    @Body() Map<String, dynamic> data,
  );

  @POST('/penilaians/{id}/correction')
  Future<ApiResponse<Penilaian>> submitWalidataCorrection(
    @Path('id') int assessmentId,
    @Body() Map<String, dynamic> data,
  );

  @POST('/bukti-dukungs')
  @MultiPart()
  Future<ApiResponse<BuktiDukung>> uploadBuktiDukung(
    @Part(name: 'penilaian_id') int penilaianId,
    @Part(name: 'file') File file,
  );
}
