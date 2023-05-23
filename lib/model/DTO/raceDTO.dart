// To parse this JSON data, do
//
//     final raceDto = raceDtoFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

RaceDto raceDtoFromJson(String str) => RaceDto.fromJson(json.decode(str));

String raceDtoToJson(RaceDto data) => json.encode(data.toJson());

class RaceDto {
    String raceName;
    String raceLocation;
    int raceLimitteam;
    String raceImage;
    DateTime signUpTimeSt;
    DateTime signUpTimeFn;
    DateTime raceTimeSt;
    DateTime raceTimeFn;
    DateTime eventDatetime;
    int userId;
    int raceStatus;

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

    factory RaceDto.fromJson(Map<String, dynamic> json) => RaceDto(
        raceName: json["raceName"],
        raceLocation: json["raceLocation"],
        raceLimitteam: json["raceLimitteam"],
        raceImage: json["raceImage"],
        signUpTimeSt: DateTime.parse(json["signUpTimeST"]),
        signUpTimeFn: DateTime.parse(json["signUpTimeFN"]),
        raceTimeSt: DateTime.parse(json["raceTimeST"]),
        raceTimeFn: DateTime.parse(json["raceTimeFN"]),
        eventDatetime: DateTime.parse(json["eventDatetime"]),
        userId: json["userID"],
        raceStatus: json["race_status"],
    );

    Map<String, dynamic> toJson() => {
        "raceName": raceName,
        "raceLocation": raceLocation,
        "raceLimitteam": raceLimitteam,
        "raceImage": raceImage,
        "signUpTimeST": signUpTimeSt.toIso8601String(),
        "signUpTimeFN": signUpTimeFn.toIso8601String(),
        "raceTimeST": raceTimeSt.toIso8601String(),
        "raceTimeFN": raceTimeFn.toIso8601String(),
        "eventDatetime": eventDatetime.toIso8601String(),
        "userID": userId,
        "race_status": raceStatus,
    };
}
