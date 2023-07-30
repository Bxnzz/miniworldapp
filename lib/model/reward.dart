// To parse this JSON data, do
//
//     final reward = rewardFromJson(jsonString);

import 'package:meta/meta.dart';
import 'package:miniworldapp/model/race.dart';
import 'dart:convert';

import 'package:miniworldapp/model/team.dart';

Reward rewardFromJson(String str) => Reward.fromJson(json.decode(str));

String rewardToJson(Reward data) => json.encode(data.toJson());

class Reward {
    int reId;
    int reType;
    int teamId;
    Team team;
    int raceId;
    Race race;

    Reward({
        required this.reId,
        required this.reType,
        required this.teamId,
        required this.team,
        required this.raceId,
        required this.race,
    });

    factory Reward.fromJson(Map<String, dynamic> json) => Reward(
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





