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

  @GET("/attend/")
  Future<HttpResponse<List<AttendRace>>> attendByUserID(
      {@Query("userID") required int userID});
}
