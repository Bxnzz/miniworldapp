import 'package:miniworldapp/model/DTO/loginDTO.dart';
import 'package:miniworldapp/model/register.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:miniworldapp/model/DTO/registerDTO.dart';

part 'Register.g.dart';

@RestApi()
abstract class RegisterService {
 factory RegisterService(Dio dio, {String baseUrl}) = _RegisterService;

  @POST("/user/register")
   Future<HttpResponse<Register>> registers(@Body() RegisterDto registerDto);
  
}

