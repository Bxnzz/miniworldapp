// To parse this JSON data, do
//
//     final attendStatusDto = attendStatusDtoFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

AttendStatusDto attendStatusDtoFromJson(String str) =>
    AttendStatusDto.fromJson(json.decode(str));

String attendStatusDtoToJson(AttendStatusDto data) =>
    json.encode(data.toJson());

class AttendStatusDto {
  int status;

  AttendStatusDto({
    required this.status,
  });

  AttendStatusDto copyWith({
    int? status,
  }) =>
      AttendStatusDto(
        status: status ?? this.status,
      );

  factory AttendStatusDto.fromJson(Map<String, dynamic> json) =>
      AttendStatusDto(
        status: json["Status"],
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
      };
}
