// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
    int userId;
    String userName;
    String userMail;
    String userPassword;
    String userFullname;
    String userImage;
    String userDiscription;
    String userFacebookId;
    String onesingnalId;

    User({
        required this.userId,
        required this.userName,
        required this.userMail,
        required this.userPassword,
        required this.userFullname,
        required this.userImage,
        required this.userDiscription,
        required this.userFacebookId,
        required this.onesingnalId,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["UserID"],
        userName: json["UserName"],
        userMail: json["UserMail"],
        userPassword: json["UserPassword"],
        userFullname: json["UserFullname"],
        userImage: json["UserImage"],
        userDiscription: json["UserDiscription"],
        userFacebookId: json["UserFacebookID"],
        onesingnalId: json["OnesingnalID"],
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
        "OnesingnalID": onesingnalId,
    };
}
