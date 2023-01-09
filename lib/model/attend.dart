// To parse this JSON data, do
//
//     final latlngDto = latlngDtoFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<LatlngDto?>? latlngDtoFromJson(String str) => json.decode(str) == null ? [] : List<LatlngDto?>.from(json.decode(str)!.map((x) => LatlngDto.fromJson(x)));

String latlngDtoToJson(List<LatlngDto?>? data) => json.encode(data == null ? [] : List<dynamic>.from(data!.map((x) => x!.toJson())));

class LatlngDto {
    LatlngDto({
        required this.atId,
        required this.lat,
        required this.lng,
        required this.userId,
        required this.datetime,
    });

    int? atId;
    double? lat;
    double? lng;
    int? userId;
    String? datetime;

    factory LatlngDto.fromJson(Map<String, dynamic> json) => LatlngDto(
        atId: json["AtId"],
        lat: json["Lat"].toDouble(),
        lng: json["Lng"].toDouble(),
        userId: json["UserID"],
        datetime: json["Datetime"],
    );

    Map<String, dynamic> toJson() => {
        "AtId": atId,
        "Lat": lat,
        "Lng": lng,
        "UserID": userId,
        "Datetime": datetime,
    };
}
