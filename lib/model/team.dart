// To parse this JSON data, do
//
//     final team = teamFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<Team> teamFromJson(String str) => List<Team>.from(json.decode(str).map((x) => Team.fromJson(x)));

String teamToJson(List<Team> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Team {
    Team({
        required this.massage,
    });

    String massage;

    factory Team.fromJson(Map<String, dynamic> json) => Team(
        massage: json["massage"],
    );

    Map<String, dynamic> toJson() => {
        "massage": massage,
    };
}
