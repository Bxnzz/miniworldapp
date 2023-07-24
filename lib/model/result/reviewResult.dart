// To parse this JSON data, do
//
//     final reviewResult = reviewResultFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<ReviewResult> attendFromJson(String str) => List<ReviewResult>.from(
    json.decode(str).map((x) => ReviewResult.fromJson(x)));

String attendToJson(List<ReviewResult> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReviewResult {
  String massage;

  ReviewResult({
    required this.massage,
  });

  factory ReviewResult.fromJson(Map<String, dynamic> json) => ReviewResult(
        massage: json["massage"],
      );

  Map<String, dynamic> toJson() => {
        "massage": massage,
      };
}
