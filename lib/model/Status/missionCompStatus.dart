// To parse this JSON data, do
//
//     final missionCompStatus = missionCompStatusFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

MissionCompStatus missionCompStatusFromJson(String str) => MissionCompStatus.fromJson(json.decode(str));

String missionCompStatusToJson(MissionCompStatus data) => json.encode(data.toJson());

class MissionCompStatus {
    int mcStatus;
    String mcMasseage;
    int misId;
    int teamId;

    MissionCompStatus({
        required this.mcStatus,
        required this.mcMasseage,
        required this.misId,
        required this.teamId,
    });

    factory MissionCompStatus.fromJson(Map<String, dynamic> json) => MissionCompStatus(
        mcStatus: json["McStatus"],
        mcMasseage: json["McMasseage"],
        misId: json["MisID"],
        teamId: json["TeamID"],
    );

    Map<String, dynamic> toJson() => {
        "McStatus": mcStatus,
        "McMasseage": mcMasseage,
        "MisID": misId,
        "TeamID": teamId,
    };
}
