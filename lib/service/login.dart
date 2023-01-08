import 'package:miniworldapp/model/DTO/loginDTO.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:miniworldapp/model/login.dart';

part 'login.g.dart';

@RestApi()
abstract class LoginService {
  factory LoginService(Dio dio, {String baseUrl}) = _LoginService;
  
  @POST("/user/login")
   Future<HttpResponse<Login>> loginser(@Body() LoginDto loginDto);
}

