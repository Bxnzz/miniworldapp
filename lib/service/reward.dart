import 'package:dio/dio.dart';
import 'package:miniworldapp/model/DTO/rewardDTO.dart';
import 'package:miniworldapp/model/reward.dart';

import 'package:retrofit/dio.dart';
import 'package:retrofit/http.dart';

part 'reward.g.dart';



@RestApi()
abstract class RewardService {
  factory RewardService(Dio dio, {String baseUrl}) = _RewardService;

  @POST("/reward")
  Future<HttpResponse<Reward>> reward(@Body() RewardDto rewardDto);

  @GET("/reward/")
  Future<HttpResponse<List<Reward>>> rewardByRaceID(
      {@Query("raceID") required int raceID});

    @GET("/reward/")
  Future<HttpResponse<List<Reward>>> rewardByTeamID(
      {@Query("teamID") required int teamID});
}