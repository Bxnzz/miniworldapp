// To parse this JSON data, do
//
//     final teamResult = teamResultFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

TeamResult teamResultFromJson(String str) =>
    TeamResult.fromJson(json.decode(str));

String teamResultToJson(TeamResult data) => json.encode(data.toJson());

class TeamResult {
  String code;
  String result;

  TeamResult({
    required this.code,
    required this.result,
  });

  factory TeamResult.fromJson(Map<String, dynamic> json) => TeamResult(
        code: json["code"],
        result: json["result"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "result": result,
      };
}
