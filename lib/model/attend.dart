// To parse this JSON data, do
//
//     final attend = attendFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<Attend> attendFromJson(String str) => List<Attend>.from(json.decode(str).map((x) => Attend.fromJson(x)));

String attendToJson(List<Attend> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Attend {
    Attend({
        required this.atId,
        required this.lat,
        required this.lng,
        required this.datetime,
        required this.userId,
        required this.user,
        required this.teamId,
        required this.team,
    });

    int atId;
    double lat;
    double lng;
    DateTime datetime;
    int userId;
    AttendUser user;
    int teamId;
    Team team;

    factory Attend.fromJson(Map<String, dynamic> json) => Attend(
        atId: json["AtId"],
        lat: json["Lat"]?.toDouble(),
        lng: json["Lng"]?.toDouble(),
        datetime: DateTime.parse(json["Datetime"]),
        userId: json["UserID"],
        user: AttendUser.fromJson(json["User"]),
        teamId: json["TeamID"],
        team: Team.fromJson(json["Team"]),
    );

    Map<String, dynamic> toJson() => {
        "AtId": atId,
        "Lat": lat,
        "Lng": lng,
        "Datetime": datetime.toIso8601String(),
        "UserID": userId,
        "User": user.toJson(),
        "TeamID": teamId,
        "Team": team.toJson(),
    };
}

class Team {
    Team({
        required this.teamId,
        required this.teamName,
        required this.teamImage,
        required this.raceId,
        required this.race,
    });

    int teamId;
    String teamName;
    String teamImage;
    int raceId;
    Race race;

    factory Team.fromJson(Map<String, dynamic> json) => Team(
        teamId: json["TeamID"],
        teamName: json["TeamName"],
        teamImage: json["TeamImage"],
        raceId: json["RaceID"],
        race: Race.fromJson(json["Race"]),
    );

    Map<String, dynamic> toJson() => {
        "TeamID": teamId,
        "TeamName": teamName,
        "TeamImage": teamImage,
        "RaceID": raceId,
        "Race": race.toJson(),
    };
}

class Race {
    Race({
        required this.raceId,
        required this.raceName,
        required this.raceLocation,
        required this.raceLimitteam,
        required this.raceImage,
        required this.signUpTimeSt,
        required this.signUpTimeFn,
        required this.raceTimeSt,
        required this.raceTimeFn,
        required this.eventDatetime,
        required this.userId,
        required this.user,
        required this.raceStatus,
    });

    int raceId;
    String raceName;
    String raceLocation;
    int raceLimitteam;
    String raceImage;
    DateTime signUpTimeSt;
    DateTime signUpTimeFn;
    DateTime raceTimeSt;
    DateTime raceTimeFn;
    DateTime eventDatetime;
    int userId;
    RaceUser user;
    int raceStatus;

    factory Race.fromJson(Map<String, dynamic> json) => Race(
        raceId: json["RaceID"],
        raceName: json["RaceName"],
        raceLocation: json["RaceLocation"],
        raceLimitteam: json["RaceLimitteam"],
        raceImage: json["RaceImage"],
        signUpTimeSt: DateTime.parse(json["SignUpTimeST"]),
        signUpTimeFn: DateTime.parse(json["SignUpTimeFN"]),
        raceTimeSt: DateTime.parse(json["RaceTimeST"]),
        raceTimeFn: DateTime.parse(json["RaceTimeFN"]),
        eventDatetime: DateTime.parse(json["EventDatetime"]),
        userId: json["UserID"],
        user: RaceUser.fromJson(json["User"]),
        raceStatus: json["Race_status"],
    );

    Map<String, dynamic> toJson() => {
        "RaceID": raceId,
        "RaceName": raceName,
        "RaceLocation": raceLocation,
        "RaceLimitteam": raceLimitteam,
        "RaceImage": raceImage,
        "SignUpTimeST": signUpTimeSt.toIso8601String(),
        "SignUpTimeFN": signUpTimeFn.toIso8601String(),
        "RaceTimeST": raceTimeSt.toIso8601String(),
        "RaceTimeFN": raceTimeFn.toIso8601String(),
        "EventDatetime": eventDatetime.toIso8601String(),
        "UserID": userId,
        "User": user.toJson(),
        "Race_status": raceStatus,
    };
}

class RaceUser {
    RaceUser({
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

    factory RaceUser.fromJson(Map<String, dynamic> json) => RaceUser(
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

class AttendUser {
    AttendUser({
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

    factory AttendUser.fromJson(Map<String, dynamic> json) => AttendUser(
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
