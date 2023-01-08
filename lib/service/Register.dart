import 'package:miniworldapp/model/DTO/loginDTO.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:miniworldapp/model/login.dart';


@RestApi()
abstract class RegisterService {
// factory RegisterService(Dio dio, {String baseUrl}) = _RegisterService;
  
  @POST("/user/register")
   Future<HttpResponse<Login>> register(@Body() LoginDto loginDto);
}

