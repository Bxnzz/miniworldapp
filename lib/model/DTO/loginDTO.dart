// To parse this JSON data, do
//
//     final loginDto = loginDtoFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<LoginDto> loginDtoFromJson(String str) => List<LoginDto>.from(json.decode(str).map((x) => LoginDto.fromJson(x)));

String loginDtoToJson(List<LoginDto> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LoginDto {
    LoginDto({
        required this.email,
        required this.password,
    });

    String email;
    String password;

    factory LoginDto.fromJson(Map<String, dynamic> json) => LoginDto(
        email: json["email"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
    };
}
