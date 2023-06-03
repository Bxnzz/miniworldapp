import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../model/DTO/missionDTO.dart';
import '../model/mission.dart';
import '../model/result/raceResult.dart';

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

  @DELETE("/mission/{misID}")
  Future<HttpResponse<RaceResult>> deleteMissons(@Path()String misID);

  @PUT("/mission/{misID}")
  Future<HttpResponse<RaceResult>> updateRaces(@Body() MissionDto missionDto,@Path("misID")String misID);
}
