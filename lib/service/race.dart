import 'package:dio/dio.dart';
import 'package:miniworldapp/model/DTO/raceDTO.dart';
import 'package:miniworldapp/model/race.dart';
import 'package:retrofit/retrofit.dart';

part 'race.g.dart';

@RestApi()
abstract class RaceService {
  factory RaceService(Dio dio, {String baseUrl}) = _RaceService;

  @GET("/race")
  Future<HttpResponse<List<Race>>> getRaces();
  @POST("/race")
  Future<HttpResponse<Race>> Races(@Body() RaceDto RaceDto);
}