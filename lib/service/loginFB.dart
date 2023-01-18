import 'package:miniworldapp/model/DTO/loginDTO.dart';
import 'package:miniworldapp/model/login.dart';
import 'package:miniworldapp/model/register.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:miniworldapp/model/DTO/loginFBDTO.dart';

part 'loginFB.g.dart';

@RestApi()
abstract class loginFBService {
  factory loginFBService(Dio dio, {String baseUrl}) = _loginFBService;

  @POST("/user/loginfacebook")
   Future<HttpResponse<Login>> fblogin(@Body() LoginFbdto loginFBDto);
}
