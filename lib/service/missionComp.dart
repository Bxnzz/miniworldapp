import 'package:dio/dio.dart';
import 'package:miniworldapp/model/missionComp.dart';
import 'package:retrofit/retrofit.dart';

part 'missionComp.g.dart';

@RestApi()
abstract class MissionCompService {
  factory MissionCompService(Dio dio, {String baseUrl}) = _MissionCompService;

  @GET("/missionComp")
  Future<HttpResponse<List<MissionComplete>>> missionCompAll();

  @GET("/missionComp/")
  Future<HttpResponse<List<MissionComplete>>> missionCompByTeamId(
      {@Query("teamID") required int teamID});
}
