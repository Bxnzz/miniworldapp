import 'package:dio/dio.dart';
import 'package:miniworldapp/model/DTO/missionCompDTO.dart';
import 'package:miniworldapp/model/DTO/missionDTO.dart';
import 'package:miniworldapp/model/missionComp.dart';
import 'package:retrofit/retrofit.dart';

import '../model/Status/missionCompStatus.dart';
import '../model/result/raceResult.dart';

part 'missionComp.g.dart';

@RestApi()
abstract class MissionCompService {
  factory MissionCompService(Dio dio, {String baseUrl}) = _MissionCompService;

  @GET("/missionComp")
  Future<HttpResponse<List<MissionComplete>>> missionCompAll();

  @GET("/missionComp/")
  Future<HttpResponse<List<MissionComplete>>> missionCompByTeamId(
      {@Query("teamID") required int teamID});

  @GET("/missionComp/")
  Future<HttpResponse<List<MissionComplete>>> missionCompBymcId(
      {@Query("mcID") required int mcID});

  @POST("/missionComp")
  Future<HttpResponse<MissionComplete>> insertMissionComps(@Body() MissionCompDto missionCompDto);

  @PUT("/missionComp/{mcID}")
  Future<HttpResponse<RaceResult>> updateStatusMisCom(
  @Body() MissionCompStatus missionComStatus, @Path("mcID") String mcID);
}

