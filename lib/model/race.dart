// To parse this JSON data, do
//
//     final race = raceFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

import 'user.dart';

List<Race> raceFromJson(String str) => List<Race>.from(json.decode(str).map((x) => Race.fromJson(x)));

String raceToJson(List<Race> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Race {
    Race({
        required this.raceId,
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
        required this.user,
        required this.raceStatus,
    });

    int raceId;
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
    User user;
    int raceStatus;

    factory Race.fromJson(Map<String, dynamic> json) => Race(
        raceId: json["RaceID"],
        raceName: json["RaceName"],
        raceLocation: json["RaceLocation"],
        raceLimitteam: json["RaceLimitteam"],
        raceImage: json["RaceImage"],
        signUpTimeSt: DateTime.parse(json["SignUpTimeST"]),
        signUpTimeFn: DateTime.parse(json["SignUpTimeFN"]),
        raceTimeSt: DateTime.parse(json["RaceTimeST"]),
        raceTimeFn: DateTime.parse(json["RaceTimeFN"]),
        eventDatetime: DateTime.parse(json["EventDatetime"]),
        userId: json["UserID"],
        user: User.fromJson(json["User"]),
        raceStatus: json["Race_status"],
    );

    Map<String, dynamic> toJson() => {
        "RaceID": raceId,
        "RaceName": raceName,
        "RaceLocation": raceLocation,
        "RaceLimitteam": raceLimitteam,
        "RaceImage": raceImage,
        "SignUpTimeST": signUpTimeSt.toIso8601String(),
        "SignUpTimeFN": signUpTimeFn.toIso8601String(),
        "RaceTimeST": raceTimeSt.toIso8601String(),
        "RaceTimeFN": raceTimeFn.toIso8601String(),
        "EventDatetime": eventDatetime.toIso8601String(),
        "UserID": userId,
        "User": user.toJson(),
        "Race_status": raceStatus,
    };
}

