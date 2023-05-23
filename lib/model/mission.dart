// To parse this JSON data, do
//
//     final mission = missionFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

import 'package:miniworldapp/model/race.dart';

List<Mission> missionFromJson(String str) => List<Mission>.from(json.decode(str).map((x) => Mission.fromJson(x)));

String missionToJson(List<Mission> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

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
        misLat: json["MisLat"]?.toDouble(),
        misLng: json["MisLng"]?.toDouble(),
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

