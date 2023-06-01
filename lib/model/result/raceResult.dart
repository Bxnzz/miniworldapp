// To parse this JSON data, do
//
//     final raceResult = raceResultFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

RaceResult raceResultFromJson(String str) => RaceResult.fromJson(json.decode(str));

String raceResultToJson(RaceResult data) => json.encode(data.toJson());

class RaceResult {
    String code;
    String result;

    RaceResult({
        required this.code,
        required this.result,
    });

    factory RaceResult.fromJson(Map<String, dynamic> json) => RaceResult(
        code: json["code"],
        result: json["result"],
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "result": result,
    };
}
