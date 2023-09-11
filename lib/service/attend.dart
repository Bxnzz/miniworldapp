import 'package:miniworldapp/model/DTO/attendLatLngDTO.dart';
import 'package:miniworldapp/model/DTO/attendStatusDTO.dart';
import 'package:miniworldapp/model/result/attendRaceResult.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../model/DTO/attendDTO.dart';
import '../model/attend.dart';

part 'attend.g.dart';

@RestApi()
abstract class AttendService {
  factory AttendService(Dio dio, {String baseUrl}) = _AttendService;

  @POST("/attend")
  Future<HttpResponse<Attend>> attends(@Body() AttendDto attendDto);

  @GET("/attend")
  Future<HttpResponse<List<AttendRace>>> getAllAttend();

  @GET("/attend/")
  Future<HttpResponse<List<AttendRace>>> attendsAll();

  @GET("/attend/")
  Future<HttpResponse<List<AttendRace>>> attendByUserID(
      {@Query("userID") required int userID});

  @GET("/attend/")
  Future<HttpResponse<List<AttendRace>>> attendByRaceID(
      {@Query("raceID") required int raceID});

  @GET("/attend/")
  Future<HttpResponse<List<AttendRace>>> attendByTeamID(
      {@Query("teamID") required int teamID});

  @GET("/attend/")
  Future<HttpResponse<List<AttendRace>>> attendByDateTime(
      {@Query("DateTime") required String DateTime});

  @PUT("/attend/{AtID}")
  Future<HttpResponse<int>> attendByAtID(
      @Body() AttendStatusDto attendStatusDto, @Path("AtID") int atID);

  @PUT("/attend/{AtID}")
  Future<HttpResponse<int>> updateLatLngattendByAtID(
      @Body() AttendLatLngDto attendLatLngDto, @Path("AtID") int atID);
}
