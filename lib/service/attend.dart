import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import 'package:miniworldapp/model/attend.dart';

part 'attend.g.dart'; 
@RestApi()
abstract class AttendService {
  factory AttendService(Dio dio, {String baseUrl}) = _AttendService;

  @GET("/attend/getCoordi")
  Future<HttpResponse<List<LatlngDto>>> attend();
}

