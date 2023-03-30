// To parse this JSON data, do
//
//     final teamDto = teamDtoFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<TeamDto> teamDtoFromJson(String str) => List<TeamDto>.from(json.decode(str).map((x) => TeamDto.fromJson(x)));

String teamDtoToJson(List<TeamDto> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TeamDto {
    TeamDto({
        required this.teamName,
        required this.teamImage,
        required this.raceId,
    });

    String teamName;
    String teamImage;
    int raceId;

    factory TeamDto.fromJson(Map<String, dynamic> json) => TeamDto(
        teamName: json["teamName"],
        teamImage: json["teamImage"],
        raceId: json["raceID"],
    );

    Map<String, dynamic> toJson() => {
        "teamName": teamName,
        "teamImage": teamImage,
        "raceID": raceId,
    };
}
