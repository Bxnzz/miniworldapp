// To parse this JSON data, do
//
//     final missionCompDto = missionCompDtoFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

MissionCompDto missionCompDtoFromJson(String str) => MissionCompDto.fromJson(json.decode(str));

String missionCompDtoToJson(MissionCompDto data) => json.encode(data.toJson());

class MissionCompDto {
    String mcText;
    String mcVideo;
    String mcPhoto;
    DateTime mcDatetime;
    double mcLat;
    double mcLng;
    int mcStatus;
    String mcMasseage;
    int misId;
    int teamId;

    MissionCompDto({
        required this.mcText,
        required this.mcVideo,
        required this.mcPhoto,
        required this.mcDatetime,
        required this.mcLat,
        required this.mcLng,
        required this.mcStatus,
        required this.mcMasseage,
        required this.misId,
        required this.teamId,
    });

    factory MissionCompDto.fromJson(Map<String, dynamic> json) => MissionCompDto(
        mcText: json["McText"],
        mcVideo: json["McVideo"],
        mcPhoto: json["McPhoto"],
        mcDatetime: DateTime.parse(json["McDatetime"]),
        mcLat: json["McLat"]?.toDouble(),
        mcLng: json["McLng"]?.toDouble(),
        mcStatus: json["McStatus"],
        mcMasseage: json["McMasseage"],
        misId: json["MisID"],
        teamId: json["TeamID"],
    );

    Map<String, dynamic> toJson() => {
        "McText": mcText,
        "McVideo": mcVideo,
        "McPhoto": mcPhoto,
        "McDatetime": mcDatetime.toIso8601String(),
        "McLat": mcLat,
        "McLng": mcLng,
        "McStatus": mcStatus,
        "McMasseage": mcMasseage,
        "MisID": misId,
        "TeamID": teamId,
    };
}
