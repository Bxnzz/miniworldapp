import 'package:dio/dio.dart';
import 'package:miniworldapp/model/DTO/raceDTO.dart';
import 'package:miniworldapp/model/DTO/raceStatusDTO.dart';
import 'package:miniworldapp/model/race.dart';
import 'package:retrofit/retrofit.dart';

import '../model/result/raceResult.dart';

part 'race.g.dart';

@RestApi()
abstract class RaceService {
  factory RaceService(Dio dio, {String baseUrl}) = _RaceService;

  @GET("/race/")
  Future<HttpResponse<List<Race>>> races();

  @GET("/race/")
  Future<HttpResponse<List<Race>>> racesByID(
      {@Query("userID") required int userID});
  @GET("/race/")
  Future<HttpResponse<List<Race>>> racesByraceID(
      {@Query("raceID") required int raceID});

  @DELETE("/race/{raceID}")
  Future<HttpResponse<RaceResult>> deleteRace(@Path() String raceID);

  @POST("/race")
  Future<HttpResponse<Race>> insertRaces(@Body() RaceDto raceDto);

  @PUT("/race/{raceID}")
  Future<HttpResponse<RaceResult>> updateRaces(
      @Body() RaceDto raceDto, @Path("raceID") String raceID);

  @PUT("/race/{raceID}")
  Future<HttpResponse<String>> updateStatusRaces(
    @Body() RaceStatusDto raceStatusDto,
    @Path("raceID") int raceID,
  );
}
