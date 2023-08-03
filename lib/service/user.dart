import 'package:dio/dio.dart';
import 'package:miniworldapp/model/DTO/registerDTO.dart';

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

  @GET("/user/")
  Future<HttpResponse<List<User>>> getUserByID(@Query("userID") int userID);

  @PUT("/user/{userID}")
  Future<HttpResponse<RaceResult>> updateUsers(
      @Body() UserDto userDto, @Path("userID") String userID);

  @PUT("/user/{userID}")
  Future<HttpResponse<RaceResult>> chengePassword(
      @Body() RegisterDto registerDto, @Path("userID") String userID);
}
