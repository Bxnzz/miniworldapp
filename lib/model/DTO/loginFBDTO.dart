

import 'package:meta/meta.dart';
import 'dart:convert';

List<LoginFbdto?>? loginFbdtoFromJson(String str) => json.decode(str) == null ? [] : List<LoginFbdto?>.from(json.decode(str)!.map((x) => LoginFbdto.fromJson(x)));

String loginFbdtoToJson(List<LoginFbdto?>? data) => json.encode(data == null ? [] : List<dynamic>.from(data!.map((x) => x!.toJson())));

class LoginFbdto {
    LoginFbdto({
        required this.facebookid,
    });

    String? facebookid;

    factory LoginFbdto.fromJson(Map<String, dynamic> json) => LoginFbdto(
        facebookid: json["facebookid"],
    );

    Map<String, dynamic> toJson() => {
        "facebookid": facebookid,
    };
}
