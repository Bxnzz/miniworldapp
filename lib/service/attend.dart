import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:miniworldapp/model/attend.dart';

part 'attend.g.dart';

@RestApi()
abstract class DestinationService {
  factory DestinationService(Dio dio, {String baseUrl}) = _DestinationService;

}

