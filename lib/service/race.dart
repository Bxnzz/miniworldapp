import 'package:dio/dio.dart';
import 'package:miniworldapp/model/DTO/raceDTO.dart';
import 'package:miniworldapp/model/race.dart';
import 'package:retrofit/retrofit.dart';

part 'race.g.dart';

@RestApi()
abstract class RaceService {
  factory RaceService(Dio dio, {String baseUrl}) = _RaceService;

  @GET("/race/")
  Future<HttpResponse<List<Race>>> races();
  
  @GET("/race/")
  Future<HttpResponse<List<Race>>> racesByID(
    {@Query("userID") required int userID}
  );
  @GET("/race/")
  Future<HttpResponse<List<Race>>> racesByraceID(
    {@Query("raceID") required int raceID}
  );
  
  @POST("/race")
  Future<HttpResponse<Race>> insertRaces(@Body() RaceDto raceDto);
}
