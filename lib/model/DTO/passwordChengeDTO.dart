// To parse this JSON data, do
//
//     final passwordChengeDto = passwordChengeDtoFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

PasswordChengeDto passwordChengeDtoFromJson(String str) =>
    PasswordChengeDto.fromJson(json.decode(str));

String passwordChengeDtoToJson(PasswordChengeDto data) =>
    json.encode(data.toJson());

class PasswordChengeDto {
  String userPassword;

  PasswordChengeDto({
    required this.userPassword,
  });

  factory PasswordChengeDto.fromJson(Map<String, dynamic> json) =>
      PasswordChengeDto(
        userPassword: json["userPassword"],
      );

  Map<String, dynamic> toJson() => {
        "userPassword": userPassword,
      };
}
