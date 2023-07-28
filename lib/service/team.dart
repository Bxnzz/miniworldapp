import 'package:dio/dio.dart';

import 'package:retrofit/retrofit.dart';

import '../model/DTO/teamDTO.dart';
import '../model/result/teamResult.dart';
import '../model/team.dart';

part 'team.g.dart';

@RestApi()
abstract class TeamService {
  factory TeamService(Dio dio, {String baseUrl}) = _TeamService;

  @POST("/team")
  Future<HttpResponse<Team>> teams(@Body() TeamDto TeamDto);

  @GET("/team/")
  Future<HttpResponse<List<Team>>> teambyRaceID(
      {@Query("raceID") required int raceID});

  @DELETE("/team/{teamID}")
  Future<HttpResponse<TeamResult>> DelbyTeamID(@Path() String teamID);
}
