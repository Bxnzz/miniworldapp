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


