// To parse this JSON data, do
//
//     final login = loginFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<Login> loginFromJson(String str) => List<Login>.from(json.decode(str).map((x) => Login.fromJson(x)));

String loginToJson(List<Login> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Login {
    Login({
        required this.userId,
        required this.userName,
        required this.userMail,
        required this.userPassword,
        required this.userFullname,
        required this.userImage,
        required this.userDiscription,
        required this.userFacebookId,
    });

    int userId;
    String userName;
    String userMail;
    String userPassword;
    String userFullname;
    String userImage;
    String userDiscription;
    String userFacebookId;

    factory Login.fromJson(Map<String, dynamic> json) => Login(
        userId: json["UserID"],
        userName: json["UserName"],
        userMail: json["UserMail"],
        userPassword: json["UserPassword"],
        userFullname: json["UserFullname"],
        userImage: json["UserImage"],
        userDiscription: json["UserDiscription"],
        userFacebookId: json["UserFacebookID"],
    );

    Map<String, dynamic> toJson() => {
        "UserID": userId,
        "UserName": userName,
        "UserMail": userMail,
        "UserPassword": userPassword,
        "UserFullname": userFullname,
        "UserImage": userImage,
        "UserDiscription": userDiscription,
        "UserFacebookID": userFacebookId,
    };
}
