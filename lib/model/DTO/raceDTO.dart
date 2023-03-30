// To parse this JSON data, do
//
//     final raceDto = raceDtoFromJson(jsonString);

import 'dart:convert';

RaceDto raceDtoFromJson(String str) => RaceDto.fromJson(json.decode(str));

String raceDtoToJson(RaceDto data) => json.encode(data.toJson());

class RaceDto {
  RaceDto({
    required this.raceName,
    required this.raceLocation,
    required this.raceLimitteam,
    required this.raceImage,
    required this.signUpTimeSt,
    required this.signUpTimeFn,
    required this.raceTimeSt,
    required this.raceTimeFn,
    required this.eventDatetime,
    required this.userId,
    required this.raceStatus,
  });

  String raceName;
  String raceLocation;
  int raceLimitteam;
  String raceImage;
  DateTime signUpTimeSt;
  DateTime signUpTimeFn;
  String raceTimeSt;
  String raceTimeFn;
  DateTime eventDatetime;
  int userId;
  int raceStatus;

  factory RaceDto.fromJson(Map<String, dynamic> json) => RaceDto(
        raceName: json["raceName"],
        raceLocation: json["raceLocation"],
        raceLimitteam: json["raceLimitteam"],
        raceImage: json["raceImage"],
        signUpTimeSt: DateTime.parse(json["signUpTimeST"]),
        signUpTimeFn: DateTime.parse(json["signUpTimeFN"]),
        raceTimeSt: json["raceTimeST"],
        raceTimeFn: json["raceTimeFN"],
        eventDatetime: DateTime.parse(json["eventDatetime"]),
        userId: json["userID"],
        raceStatus: json["race_status"],
      );

  Map<String, dynamic> toJson() => {
        "raceName": raceName,
        "raceLocation": raceLocation,
        "raceLimitteam": raceLimitteam,
        "raceImage": raceImage,
        "signUpTimeST":
            "${signUpTimeSt.year.toString().padLeft(4, '0')}-${signUpTimeSt.month.toString().padLeft(2, '0')}-${signUpTimeSt.day.toString().padLeft(2, '0')}",
        "signUpTimeFN":
            "${signUpTimeFn.year.toString().padLeft(4, '0')}-${signUpTimeFn.month.toString().padLeft(2, '0')}-${signUpTimeFn.day.toString().padLeft(2, '0')}",
        "raceTimeST": raceTimeSt,
        "raceTimeFN": raceTimeFn,
        "eventDatetime":
            "${eventDatetime.year.toString().padLeft(4, '0')}-${eventDatetime.month.toString().padLeft(2, '0')}-${eventDatetime.day.toString().padLeft(2, '0')}",
        "userID": userId,
        "race_status": raceStatus,
      };
}
