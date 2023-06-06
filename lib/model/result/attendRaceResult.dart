// To parse this JSON data, do
//
//     final attendRace = attendRaceFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

import '../team.dart';
import '../user.dart';

AttendRace attendRaceFromJson(String str) =>
    AttendRace.fromJson(json.decode(str));

String attendRaceToJson(AttendRace data) => json.encode(data.toJson());

class AttendRace {
  int atId;
  int lat;
  int lng;
  DateTime datetime;
  int userId;
  User user;
  int teamId;
  Team team;

  AttendRace({
    required this.atId,
    required this.lat,
    required this.lng,
    required this.datetime,
    required this.userId,
    required this.user,
    required this.teamId,
    required this.team,
  });

  AttendRace copyWith({
    int? atId,
    int? lat,
    int? lng,
    DateTime? datetime,
    int? userId,
    User? user,
    int? teamId,
    Team? team,
  }) =>
      AttendRace(
        atId: atId ?? this.atId,
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
        datetime: datetime ?? this.datetime,
        userId: userId ?? this.userId,
        user: user ?? this.user,
        teamId: teamId ?? this.teamId,
        team: team ?? this.team,
      );

  factory AttendRace.fromJson(Map<String, dynamic> json) => AttendRace(
        atId: json["AtId"],
        lat: json["Lat"],
        lng: json["Lng"],
        datetime: DateTime.parse(json["Datetime"]),
        userId: json["UserID"],
        user: User.fromJson(json["User"]),
        teamId: json["TeamID"],
        team: Team.fromJson(json["Team"]),
      );

  Map<String, dynamic> toJson() => {
        "AtId": atId,
        "Lat": lat,
        "Lng": lng,
        "Datetime": datetime.toIso8601String(),
        "UserID": userId,
        "User": user.toJson(),
        "TeamID": teamId,
        "Team": team.toJson(),
      };
}

class Race {
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

  Race copyWith({
    int? raceId,
    String? raceName,
    String? raceLocation,
    int? raceLimitteam,
    String? raceImage,
    DateTime? signUpTimeSt,
    DateTime? signUpTimeFn,
    DateTime? raceTimeSt,
    DateTime? raceTimeFn,
    DateTime? eventDatetime,
    int? userId,
    User? user,
    int? raceStatus,
  }) =>
      Race(
        raceId: raceId ?? this.raceId,
        raceName: raceName ?? this.raceName,
        raceLocation: raceLocation ?? this.raceLocation,
        raceLimitteam: raceLimitteam ?? this.raceLimitteam,
        raceImage: raceImage ?? this.raceImage,
        signUpTimeSt: signUpTimeSt ?? this.signUpTimeSt,
        signUpTimeFn: signUpTimeFn ?? this.signUpTimeFn,
        raceTimeSt: raceTimeSt ?? this.raceTimeSt,
        raceTimeFn: raceTimeFn ?? this.raceTimeFn,
        eventDatetime: eventDatetime ?? this.eventDatetime,
        userId: userId ?? this.userId,
        user: user ?? this.user,
        raceStatus: raceStatus ?? this.raceStatus,
      );

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
