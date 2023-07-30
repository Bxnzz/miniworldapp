// To parse this JSON data, do
//
//     final rewardDto = rewardDtoFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

RewardDto rewardDtoFromJson(String str) => RewardDto.fromJson(json.decode(str));

String rewardDtoToJson(RewardDto data) => json.encode(data.toJson());

class RewardDto {
    int reType;
    int teamId;
    int raceId;

    RewardDto({
        required this.reType,
        required this.teamId,
        required this.raceId,
    });

    factory RewardDto.fromJson(Map<String, dynamic> json) => RewardDto(
        reType: json["reType"],
        teamId: json["teamId"],
        raceId: json["raceId"],
    );

    Map<String, dynamic> toJson() => {
        "reType": reType,
        "teamId": teamId,
        "raceId": raceId,
    };
}
