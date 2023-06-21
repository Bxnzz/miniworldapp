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
  double lat;
  double lng;
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

class AttendRaceUser {
  int userId;
  String userName;
  String userMail;
  String userPassword;
  String userFullname;
  String userImage;
  String userDiscription;
  String userFacebookId;
  String onesingnalId;

  AttendRaceUser({
    required this.userId,
    required this.userName,
    required this.userMail,
    required this.userPassword,
    required this.userFullname,
    required this.userImage,
    required this.userDiscription,
    required this.userFacebookId,
    required this.onesingnalId,
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
        onesingnalId: json["OnesingnalID"],
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
        "OnesingnalID": onesingnalId,
      };
}
