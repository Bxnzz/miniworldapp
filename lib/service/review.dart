import 'package:dio/dio.dart';
import 'package:miniworldapp/model/DTO/reviewDTO.dart';
import 'package:miniworldapp/model/result/reviewResult.dart';
import 'package:miniworldapp/model/review.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/http.dart';

part 'review.g.dart';

@RestApi()
abstract class ReviewService {
  factory ReviewService(Dio dio, {String baseUrl}) = _ReviewService;

  @POST("/review")
  Future<HttpResponse<ReviewResult>> reviews(@Body() Reviewdto reviewdto);

  @GET("/review/")
  Future<HttpResponse<List<Review>>> reviewByRaceID(
      {@Query("raceID") required int raceID});
}
