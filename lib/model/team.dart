// To parse this JSON data, do
//
//     final team = teamFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

import 'package:miniworldapp/model/race.dart';

List<Team> teamFromJson(String str) => List<Team>.from(json.decode(str).map((x) => Team.fromJson(x)));

String teamToJson(List<Team> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Team {
    Team({
        required this.teamId,
        required this.teamName,
        required this.teamImage,
        required this.raceId,
        required this.race,
    });

    int teamId;
    String teamName;
    String teamImage;
    int raceId;
    Race race;

    factory Team.fromJson(Map<String, dynamic> json) => Team(
        teamId: json["TeamID"],
        teamName: json["TeamName"],
        teamImage: json["TeamImage"],
        raceId: json["RaceID"],
        race: Race.fromJson(json["Race"]),
    );

    Map<String, dynamic> toJson() => {
        "TeamID": teamId,
        "TeamName": teamName,
        "TeamImage": teamImage,
        "RaceID": raceId,
        "Race": race.toJson(),
    };
}



