// To parse this JSON data, do
//
//     final attendDto = attendDtoFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<AttendDto> attendDtoFromJson(String str) =>
    List<AttendDto>.from(json.decode(str).map((x) => AttendDto.fromJson(x)));

String attendDtoToJson(List<AttendDto> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AttendDto {
  AttendDto({
    required this.lat,
    required this.lng,
    required this.datetime,
    required this.userId,
    required this.teamId,
    required this.status,
  });

  double lat;
  double lng;
  String datetime;
  int userId;
  int teamId;
  int status;

  factory AttendDto.fromJson(Map<String, dynamic> json) => AttendDto(
      lat: json["Lat"]?.toDouble(),
      lng: json["Lng"]?.toDouble(),
      datetime: json["Datetime"],
      userId: json["UserID"],
      teamId: json["TeamID"],
      status: json["status"]);

  Map<String, dynamic> toJson() => {
        "Lat": lat,
        "Lng": lng,
        "Datetime": datetime,
        "UserID": userId,
        "TeamID": teamId,
        "Status": status,
      };
}
