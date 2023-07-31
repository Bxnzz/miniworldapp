// To parse this JSON data, do
//
//     final rewardResult = rewardResultFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

import '../race.dart';
import '../team.dart';

RewardResult rewardResultFromJson(String str) => RewardResult.fromJson(json.decode(str));

String rewardResultToJson(RewardResult data) => json.encode(data.toJson());

class RewardResult {
    int reId;
    int reType;
    int teamId;
    Team team;
    int raceId;
    Race race;

    RewardResult({
        required this.reId,
        required this.reType,
        required this.teamId,
        required this.team,
        required this.raceId,
        required this.race,
    });

    factory RewardResult.fromJson(Map<String, dynamic> json) => RewardResult(
        reId: json["ReID"],
        reType: json["ReType"],
        teamId: json["TeamID"],
        team: Team.fromJson(json["Team"]),
        raceId: json["RaceID"],
        race: Race.fromJson(json["Race"]),
    );

    Map<String, dynamic> toJson() => {
        "ReID": reId,
        "ReType": reType,
        "TeamID": teamId,
        "Team": team.toJson(),
        "RaceID": raceId,
        "Race": race.toJson(),
    };
}


