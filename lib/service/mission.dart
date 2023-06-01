import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../model/DTO/missionDTO.dart';
import '../model/mission.dart';

part 'mission.g.dart';

@RestApi()
abstract class MissionService {
  factory MissionService(Dio dio, {String baseUrl}) = _MissionService;

  @GET("/mission")
  Future<HttpResponse<List<Mission>>> mission();

  @GET("/mission/")
  Future<HttpResponse<List<Mission>>> missionByraceID(
    {@Query("raceID") required int raceID}
  );

  @POST("/mission")
  Future<HttpResponse<Mission>> insertMissions(@Body() MissionDto missionDto);
}
