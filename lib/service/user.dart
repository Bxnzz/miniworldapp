import 'package:dio/dio.dart';

import 'package:retrofit/retrofit.dart';

import '../model/DTO/userDTO.dart';
import '../model/result/raceResult.dart';
import '../model/user.dart';

part 'user.g.dart';

@RestApi()
abstract class UserService {
  factory UserService(Dio dio, {String baseUrl}) = _UserService;

  @GET("/user/{userName}")
  Future<HttpResponse<List<User>>> getUserByName(
      @Path("userName") String userName);

  @GET("/user")
  Future<HttpResponse<List<User>>> getUserAll();

  @PUT("/user/{userID}")
  Future<HttpResponse<RaceResult>> updateUsers(@Body() UserDto userDto,@Path("userID")String userID);
}
