import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../model/DTO/missionDTO.dart';
import '../model/mission.dart';

part 'mission.g.dart';

@RestApi()
abstract class MissionService {
  factory MissionService(Dio dio, {String baseUrl}) = _MissionService;

  @GET("/mission")
  Future<HttpResponse<List<Mission>>> missionAll();

  @POST("/mission")
  Future<HttpResponse<Mission>> missions(@Body() MissionDto missionDto);
}
