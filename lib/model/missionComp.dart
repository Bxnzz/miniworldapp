// To parse this JSON data, do
//
//     final missionComplete = missionCompleteFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<MissionComplete> missionCompleteFromJson(String str) =>
    List<MissionComplete>.from(
        json.decode(str).map((x) => MissionComplete.fromJson(x)));

String missionCompleteToJson(List<MissionComplete> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MissionComplete {
  int mcId;
  String mcText;
  String mcVideo;
  String mcPhoto;
  DateTime mcDatetime;
  double mcLat;
  double mcLng;
  int mcStatus;
  String mcMasseage;
  int misId;
  Mission mission;
  int teamId;
  Team team;

  MissionComplete({
    required this.mcId,
    required this.mcText,
    required this.mcVideo,
    required this.mcPhoto,
    required this.mcDatetime,
    required this.mcLat,
    required this.mcLng,
    required this.mcStatus,
    required this.mcMasseage,
    required this.misId,
    required this.mission,
    required this.teamId,
    required this.team,
  });

  factory MissionComplete.fromJson(Map<String, dynamic> json) =>
      MissionComplete(
        mcId: json["McID"],
        mcText: json["McText"],
        mcVideo: json["McVideo"],
        mcPhoto: json["McPhoto"],
        mcDatetime: DateTime.parse(json["McDatetime"]),
        mcLat: json["McLat"].toDouble(),
        mcLng: json["McLng"].toDouble(),
        mcStatus: json["McStatus"],
        mcMasseage: json["McMasseage"],
        misId: json["MisID"],
        mission: Mission.fromJson(json["Mission"]),
        teamId: json["TeamID"],
        team: Team.fromJson(json["Team"]),
      );

  Map<String, dynamic> toJson() => {
        "McID": mcId,
        "McText": mcText,
        "McVideo": mcVideo,
        "McPhoto": mcPhoto,
        "McDatetime": mcDatetime.toIso8601String(),
        "McLat": mcLat,
        "McLng": mcLng,
        "McStatus": mcStatus,
        "McMasseage": mcMasseage,
        "MisID": misId,
        "Mission": mission.toJson(),
        "TeamID": teamId,
        "Team": team.toJson(),
      };
}

class Mission {
  int misId;
  String misName;
  String misDiscrip;
  int misDistance;
  int misType;
  int misSeq;
  String misMediaUrl;
  double misLat;
  double misLng;
  int raceId;
  Race race;

  Mission({
    required this.misId,
    required this.misName,
    required this.misDiscrip,
    required this.misDistance,
    required this.misType,
    required this.misSeq,
    required this.misMediaUrl,
    required this.misLat,
    required this.misLng,
    required this.raceId,
    required this.race,
  });

  factory Mission.fromJson(Map<String, dynamic> json) => Mission(
        misId: json["MisID"],
        misName: json["MisName"],
        misDiscrip: json["MisDiscrip"],
        misDistance: json["MisDistance"],
        misType: json["MisType"],
        misSeq: json["MisSeq"],
        misMediaUrl: json["MisMediaUrl"],
        misLat: json["MisLat"].toDouble(),
        misLng: json["MisLng"].toDouble(),
        raceId: json["RaceID"],
        race: Race.fromJson(json["Race"]),
      );

  Map<String, dynamic> toJson() => {
        "MisID": misId,
        "MisName": misName,
        "MisDiscrip": misDiscrip,
        "MisDistance": misDistance,
        "MisType": misType,
        "MisSeq": misSeq,
        "MisMediaUrl": misMediaUrl,
        "MisLat": misLat,
        "MisLng": misLng,
        "RaceID": raceId,
        "Race": race.toJson(),
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

class User {
  int userId;
  String userName;
  String userMail;
  String userPassword;
  String userFullname;
  String userImage;
  String userDiscription;
  String userFacebookId;
  String onesingnalId;

  User({
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

  factory User.fromJson(Map<String, dynamic> json) => User(
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

class Team {
  int teamId;
  String teamName;
  String teamImage;
  int raceId;
  Race race;

  Team({
    required this.teamId,
    required this.teamName,
    required this.teamImage,
    required this.raceId,
    required this.race,
  });

  factory Team.fromJson(Map<String, dynamic> json) => Team(
        teamId: json["TeamID"],
        teamName: json["TeamName"],
        teamImage: json["TeamImage"],
        raceId: json["RaceID"],
        race: Race.fromJson(json["Race"]),
      );

  Map<String, dynamic> toJson() => {
        "TeamID": teamId,
        "TeamName": teamName,
        "TeamImage": teamImage,
        "RaceID": raceId,
        "Race": race.toJson(),
      };
}
// To parse this JSON data, do
//
//     final missionComplete = missionCompleteFromJson(jsonString);

import 'package:meta/meta.dart';
import 'package:miniworldapp/model/mission.dart';
import 'dart:convert';

import 'package:miniworldapp/model/team.dart';

List<MissionComplete> missionCompleteFromJson(String str) =>
    List<MissionComplete>.from(
        json.decode(str).map((x) => MissionComplete.fromJson(x)));

String missionCompleteToJson(List<MissionComplete> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MissionComplete {
  int mcId;
  String mcText;
  String mcVideo;
  String mcPhoto;
  DateTime mcDatetime;
  double mcLat;
  double mcLng;
  int mcStatus;
  String mcMasseage;
  int misId;
  Mission mission;
  int teamId;
  Team team;

  MissionComplete({
    required this.mcId,
    required this.mcText,
    required this.mcVideo,
    required this.mcPhoto,
    required this.mcDatetime,
    required this.mcLat,
    required this.mcLng,
    required this.mcStatus,
    required this.mcMasseage,
    required this.misId,
    required this.mission,
    required this.teamId,
    required this.team,
  });

  factory MissionComplete.fromJson(Map<String, dynamic> json) =>
      MissionComplete(
        mcId: json["McID"],
        mcText: json["McText"],
        mcVideo: json["McVideo"],
        mcPhoto: json["McPhoto"],
        mcDatetime: DateTime.parse(json["McDatetime"]),
        mcLat: json["McLat"].toDouble(),
        mcLng: json["McLng"].toDouble(),
        mcStatus: json["McStatus"],
        mcMasseage: json["McMasseage"],
        misId: json["MisID"],
        mission: Mission.fromJson(json["Mission"]),
        teamId: json["TeamID"],
        team: Team.fromJson(json["Team"]),
      );

  Map<String, dynamic> toJson() => {
        "McID": mcId,
        "McText": mcText,
        "McVideo": mcVideo,
        "McPhoto": mcPhoto,
        "McDatetime": mcDatetime.toIso8601String(),
        "McLat": mcLat,
        "McLng": mcLng,
        "McStatus": mcStatus,
        "McMasseage": mcMasseage,
        "MisID": misId,
        "Mission": mission.toJson(),
        "TeamID": teamId,
        "Team": team.toJson(),
      };
}


