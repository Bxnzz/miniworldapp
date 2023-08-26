// To parse this JSON data, do
//
//     final attendLatLngDto = attendLatLngDtoFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

AttendLatLngDto attendLatLngDtoFromJson(String str) =>
    AttendLatLngDto.fromJson(json.decode(str));

String attendLatLngDtoToJson(AttendLatLngDto data) =>
    json.encode(data.toJson());

class AttendLatLngDto {
  double lat;
  double lng;

  AttendLatLngDto({
    required this.lat,
    required this.lng,
  });

  factory AttendLatLngDto.fromJson(Map<String, dynamic> json) =>
      AttendLatLngDto(
        lat: json["Lat"].toDouble(),
        lng: json["Lng"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "Lat": lat,
        "Lng": lng,
      };
}
