// To parse this JSON data, do
//
//     final reviewdto = reviewdtoFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Reviewdto reviewdtoFromJson(String str) => Reviewdto.fromJson(json.decode(str));

String reviewdtoToJson(Reviewdto data) => json.encode(data.toJson());

class Reviewdto {
  String revText;
  int revPoint;
  String revDatetime;
  int userId;
  int raceId;

  Reviewdto({
    required this.revText,
    required this.revPoint,
    required this.revDatetime,
    required this.userId,
    required this.raceId,
  });

  factory Reviewdto.fromJson(Map<String, dynamic> json) => Reviewdto(
        revText: json["revText"],
        revPoint: json["revPoint"],
        revDatetime: json["revDatetime"],
        userId: json["userID"],
        raceId: json["raceID"],
      );

  Map<String, dynamic> toJson() => {
        "revText": revText,
        "revPoint": revPoint,
        "revDatetime": revDatetime,
        "userID": userId,
        "raceID": raceId,
      };
}
