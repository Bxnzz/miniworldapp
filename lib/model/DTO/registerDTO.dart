// To parse this JSON data, do
//
//     final registerDto = registerDtoFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<RegisterDto?>? registerDtoFromJson(String str) => json.decode(str) == null ? [] : List<RegisterDto?>.from(json.decode(str)!.map((x) => RegisterDto.fromJson(x)));

String registerDtoToJson(List<RegisterDto?>? data) => json.encode(data == null ? [] : List<dynamic>.from(data!.map((x) => x!.toJson())));

class RegisterDto {
    RegisterDto({
        required this.userName,
        required this.userMail,
        required this.userPassword,
        required this.userFullname,
        required this.userImage,
        required this.userDiscription,
        required this.userFacebookId,
    });

    String? userName;
    String? userMail;
    String? userPassword;
    String? userFullname;
    String? userImage;
    String? userDiscription;
    String? userFacebookId;

    factory RegisterDto.fromJson(Map<String, dynamic> json) => RegisterDto(
        userName: json["UserName"],
        userMail: json["UserMail"],
        userPassword: json["UserPassword"],
        userFullname: json["UserFullname"],
        userImage: json["UserImage"],
        userDiscription: json["UserDiscription"],
        userFacebookId: json["UserFacebookID"],
    );

    Map<String, dynamic> toJson() => {
        "UserName": userName,
        "UserMail": userMail,
        "UserPassword": userPassword,
        "UserFullname": userFullname,
        "UserImage": userImage,
        "UserDiscription": userDiscription,
        "UserFacebookID": userFacebookId,
    };
}
