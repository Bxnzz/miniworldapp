// To parse this JSON data, do
//
//     final missionDto = missionDtoFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

MissionDto missionDtoFromJson(String str) => MissionDto.fromJson(json.decode(str));

String missionDtoToJson(MissionDto data) => json.encode(data.toJson());

class MissionDto {
    String misName;
    String misDiscrip;
    int misDistance;
    int misType;
    int misSeq;
    String misMediaUrl;
    double misLat;
    double misLng;
    int raceId;

    MissionDto({
        required this.misName,
        required this.misDiscrip,
        required this.misDistance,
        required this.misType,
        required this.misSeq,
        required this.misMediaUrl,
        required this.misLat,
        required this.misLng,
        required this.raceId,
    });

    factory MissionDto.fromJson(Map<String, dynamic> json) => MissionDto(
        misName: json["misName"],
        misDiscrip: json["misDiscrip"],
        misDistance: json["misDistance"],
        misType: json["misType"],
        misSeq: json["misSeq"],
        misMediaUrl: json["misMediaUrl"],
        misLat: json["misLat"]?.toDouble(),
        misLng: json["misLng"]?.toDouble(),
        raceId: json["raceID"],
    );

    Map<String, dynamic> toJson() => {
        "misName": misName,
        "misDiscrip": misDiscrip,
        "misDistance": misDistance,
        "misType": misType,
        "misSeq": misSeq,
        "misMediaUrl": misMediaUrl,
        "misLat": misLat,
        "misLng": misLng,
        "raceID": raceId,
    };
}
