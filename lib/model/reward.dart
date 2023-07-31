// To parse this JSON data, do
//
//     final reward = rewardFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Reward rewardFromJson(String str) => Reward.fromJson(json.decode(str));

String rewardToJson(Reward data) => json.encode(data.toJson());

class Reward {
    String massage;

    Reward({
        required this.massage,
    });

    factory Reward.fromJson(Map<String, dynamic> json) => Reward(
        massage: json["massage"],
    );

    Map<String, dynamic> toJson() => {
        "massage": massage,
    };
}
