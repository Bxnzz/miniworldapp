import 'package:flutter/material.dart';
import 'package:miniworldapp/model/team.dart';
import 'package:miniworldapp/model/user.dart';

import '../../model/race.dart';

class AppData with ChangeNotifier {
  //Api baseurl
  String baseurl = "http://202.28.34.197:9131";
  late List<User> users = [];
  late List<Race> races;
  late List<Team> teams;
  Map<String, dynamic> userFacebook = {};
  int idrace = 0;
  String Username = '';
  int idUser = 0;
  int idTeam = 0;
}
