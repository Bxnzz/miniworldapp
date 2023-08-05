// To parse this JSON data, do
//
//     final userDto = userDtoFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

UserDto userDtoFromJson(String str) => UserDto.fromJson(json.decode(str));

String userDtoToJson(UserDto data) => json.encode(data.toJson());

class UserDto {
  String userName;
  String userMail;
  String userPassword;
  String userFullname;
  String userImage;
  String userDiscription;
  String onesingnalId;

  UserDto({
    required this.userName,
    required this.userMail,
    required this.userPassword,
    required this.userFullname,
    required this.userImage,
    required this.userDiscription,
    required this.onesingnalId,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
        userName: json["UserName"],
        userMail: json["UserMail"],
        userPassword: json["UserPassword"],
        userFullname: json["UserFullname"],
        userImage: json["UserImage"],
        userDiscription: json["UserDiscription"],
        onesingnalId: json["OnesingnalID"],
      );

  Map<String, dynamic> toJson() => {
        "UserName": userName,
        "UserMail": userMail,
        "UserPassword": userPassword,
        "UserFullname": userFullname,
        "UserImage": userImage,
        "UserDiscription": userDiscription,
        "OnesingnalID": onesingnalId,
      };
}
