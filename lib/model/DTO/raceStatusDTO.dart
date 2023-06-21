// To parse this JSON data, do
//
//     final raceStatusDto = raceStatusDtoFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

RaceStatusDto raceStatusDtoFromJson(String str) =>
    RaceStatusDto.fromJson(json.decode(str));

String raceStatusDtoToJson(RaceStatusDto data) => json.encode(data.toJson());

class RaceStatusDto {
  int raceStatus;

  RaceStatusDto({
    required this.raceStatus,
  });

  factory RaceStatusDto.fromJson(Map<String, dynamic> json) => RaceStatusDto(
        raceStatus: json["Race_status"],
      );

  Map<String, dynamic> toJson() => {
        "Race_status": raceStatus,
      };
}
