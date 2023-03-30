import 'package:dio/dio.dart';


import'package:retrofit/retrofit.dart';

import '../model/user.dart';



part 'user.g.dart';

@RestApi()
abstract class UserService {
  factory UserService(Dio dio, {String baseUrl}) = _UserService;

 @GET("/user/{userName}")
  Future<HttpResponse<List<User>>> getUserByName(@Path("userName") String userName);
}