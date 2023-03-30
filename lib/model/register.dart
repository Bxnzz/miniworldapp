// To parse this JSON data, do
//
//     final register = registerFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<Register?>? registerFromJson(String str) => json.decode(str) == null
    ? []
    : List<Register?>.from(json.decode(str)!.map((x) => Register.fromJson(x)));

String registerToJson(List<Register?>? data) => json.encode(
    data == null ? [] : List<dynamic>.from(data.map((x) => x!.toJson())));

class Register {
  Register({
    required this.massage,
  });

  String? massage;

  factory Register.fromJson(Map<String, dynamic> json) => Register(
        massage: json["massage"],
      );

  Map<String, dynamic> toJson() => {
        "massage": massage,
      };
}
