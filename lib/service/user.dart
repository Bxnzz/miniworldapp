import 'package:dio/dio.dart';
import 'package:miniworldapp/model/DTO/passwordChengeDTO.dart';
import 'package:miniworldapp/model/DTO/registerDTO.dart';

import 'package:retrofit/retrofit.dart';

import '../model/DTO/userDTO.dart';
import '../model/result/raceResult.dart';
import '../model/user.dart';

part 'user.g.dart';

@RestApi()
abstract class UserService {
  factory UserService(Dio dio, {String baseUrl}) = _UserService;

  @GET("/user/")
  Future<HttpResponse<List<User>>> getUserByName(
      {@Query("userID") required String userName});

  @GET("/user/")
  Future<HttpResponse<List<User>>> getUserByEmail(
      {@Query("userMail") required String userMail});

  @GET("/user")
  Future<HttpResponse<List<User>>> getUserAll();

  @GET("/user/")
  Future<HttpResponse<List<User>>> getUserByID(
      {@Query("userID") required int userID});

  @PUT("/user/{userID}")
  Future<HttpResponse<RaceResult>> updateUsers(
      @Body() UserDto userDto, @Path("userID") String userID);

  @PUT("/user/oneID/{oneID}")
  Future<HttpResponse<RaceResult>> updateOneID(@Path("oneID") String oneID);

  @PUT("/user/{userID}")
  Future<HttpResponse<RaceResult>> chengePassword(
      @Body() PasswordChengeDto chengePassDto, @Path("userID") String userID);
}
