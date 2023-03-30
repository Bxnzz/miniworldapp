// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<User> userFromJson(String str) => List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
    User({
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

    factory User.fromJson(Map<String, dynamic> json) => User(
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
