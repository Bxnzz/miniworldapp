// To parse this JSON data, do
//
//     final attend = attendFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<Attend> attendFromJson(String str) => List<Attend>.from(json.decode(str).map((x) => Attend.fromJson(x)));

String attendToJson(List<Attend> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Attend {
    Attend({
        required this.massage,
    });

    String massage;

    factory LatlngDto.fromJson(Map<String, dynamic> json) => LatlngDto(
        atId: json["AtId"],
        lat: json["Lat"].toDouble(),
        lng: json["Lng"].toDouble(),
        userId: json["UserID"],
        datetime: json["Datetime"],
    );

    Map<String, dynamic> toJson() => {
        "massage": massage,
    };
}
