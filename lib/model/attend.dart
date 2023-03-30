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

    factory Attend.fromJson(Map<String, dynamic> json) => Attend(
        massage: json["massage"],
    );

    Map<String, dynamic> toJson() => {
        "massage": massage,
    };
}
