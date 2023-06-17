// To parse this JSON data, do
//
//     final attendRace = attendRaceFromJson(jsonString);

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

import '../team.dart';

AttendRace attendRaceFromJson(String str) =>
    AttendRace.fromJson(json.decode(str));

String attendRaceToJson(AttendRace data) => json.encode(data.toJson());

class AttendRace {
  int atId;
  int lat;
  int lng;
  DateTime datetime;
  int userId;
  AttendRaceUser user;
  int teamId;
  Team team;
  int status;

  AttendRace({
    required this.atId,
    required this.lat,
    required this.lng,
    required this.datetime,
    required this.userId,
    required this.user,
    required this.teamId,
    required this.team,
    required this.status,
  });

  factory AttendRace.fromJson(Map<String, dynamic> json) {
    return AttendRace(
      atId: json["AtId"],
      lat: json["Lat"],
      lng: json["Lng"],
      datetime: DateTime.parse(json["Datetime"]),
      userId: json["UserID"],
      user: AttendRaceUser.fromJson(json["User"]),
      teamId: json["TeamID"],
      team: Team.fromJson(json["Team"]),
      status: json["Status"],
    );
  }

  Map<String, dynamic> toJson() => {
        "AtId": atId,
        "Lat": lat,
        "Lng": lng,
        "Datetime": datetime.toIso8601String(),
        "UserID": userId,
        "User": user.toJson(),
        "TeamID": teamId,
        "Team": team.toJson(),
        "Status": status,
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
  RaceUser user;
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
        user: RaceUser.fromJson(json["User"]),
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

class RaceUser {
  int userId;
  String userName;
  String userMail;
  String userPassword;
  String userFullname;
  String userImage;
  String userDiscription;
  String userFacebookId;

  RaceUser({
    required this.userId,
    required this.userName,
    required this.userMail,
    required this.userPassword,
    required this.userFullname,
    required this.userImage,
    required this.userDiscription,
    required this.userFacebookId,
  });

  factory RaceUser.fromJson(Map<String, dynamic> json) => RaceUser(
        userId: json["UserID"],
        userName: json["UserName"],
        userMail: json["UserMail"],
        userPassword: json["UserPassword"],
        userFullname: json["UserFullname"],
        userImage: json["UserImage"],
        userDiscription: json["UserDiscription"],
        userFacebookId: json["UserFacebookID"],
      );

  Map<String, dynamic> toJson() => {
        "UserID": userId,
        "UserName": userName,
        "UserMail": userMail,
        "UserPassword": userPassword,
        "UserFullname": userFullname,
        "UserImage": userImage,
        "UserDiscription": userDiscription,
        "UserFacebookID": userFacebookId,
      };
}

class AttendRaceUser {
  int userId;
  String userName;
  String userMail;
  String userPassword;
  String userFullname;
  String userImage;
  String userDiscription;
  String userFacebookId;

  AttendRaceUser({
    required this.userId,
    required this.userName,
    required this.userMail,
    required this.userPassword,
    required this.userFullname,
    required this.userImage,
    required this.userDiscription,
    required this.userFacebookId,
  });

  factory AttendRaceUser.fromJson(Map<String, dynamic> json) => AttendRaceUser(
        userId: json["UserID"],
        userName: json["UserName"],
        userMail: json["UserMail"],
        userPassword: json["UserPassword"],
        userFullname: json["UserFullname"],
        userImage: json["UserImage"],
        userDiscription: json["UserDiscription"],
        userFacebookId: json["UserFacebookID"],
      );

  Map<String, dynamic> toJson() => {
        "UserID": userId,
        "UserName": userName,
        "UserMail": userMail,
        "UserPassword": userPassword,
        "UserFullname": userFullname,
        "UserImage": userImage,
        "UserDiscription": userDiscription,
        "UserFacebookID": userFacebookId,
      };
}
