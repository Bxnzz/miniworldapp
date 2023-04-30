import 'package:dio/dio.dart';


import'package:retrofit/retrofit.dart';

import '../model/DTO/teamDTO.dart';
import '../model/team.dart';







part 'team.g.dart';

@RestApi()
abstract class TeamService {
  factory TeamService(Dio dio, {String baseUrl}) = _TeamService;
  
  @POST("/team")
  Future<HttpResponse<Team>> Teams(@Body() TeamDto TeamDto);
  }