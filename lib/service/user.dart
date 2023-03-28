import 'package:dio/dio.dart';


import'package:retrofit/retrofit.dart';

import '../model/race.dart';


part 'user.g.dart';

@RestApi()
abstract class UserService {
  factory UserService(Dio dio, {String baseUrl}) = _UserService;

  @GET("/user")
  Future<HttpResponse<List<User>>> getUsers();
}