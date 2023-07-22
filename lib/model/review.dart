// To parse this JSON data, do
//
//     final review = reviewFromJson(jsonString);

import 'package:meta/meta.dart';
import 'package:miniworldapp/model/race.dart';
import 'dart:convert';

import 'package:miniworldapp/model/user.dart';

Review reviewFromJson(String str) => Review.fromJson(json.decode(str));

String reviewToJson(Review data) => json.encode(data.toJson());

class Review {
  int revId;
  String revText;
  int revPoint;
  DateTime revDatetime;
  int userId;
  User user;
  int raceId;
  Race race;

  Review({
    required this.revId,
    required this.revText,
    required this.revPoint,
    required this.revDatetime,
    required this.userId,
    required this.user,
    required this.raceId,
    required this.race,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        revId: json["RevID"],
        revText: json["RevText"],
        revPoint: json["RevPoint"],
        revDatetime: DateTime.parse(json["RevDatetime"]),
        userId: json["UserID"],
        user: User.fromJson(json["User"]),
        raceId: json["RaceID"],
        race: Race.fromJson(json["Race"]),
      );

  Map<String, dynamic> toJson() => {
        "RevID": revId,
        "RevText": revText,
        "RevPoint": revPoint,
        "RevDatetime": revDatetime.toIso8601String(),
        "UserID": userId,
        "User": user.toJson(),
        "RaceID": raceId,
        "Race": race.toJson(),
      };
}
