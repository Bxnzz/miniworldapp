import 'dart:async';

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
  String oneID = '';
  String Username = '';
  String userImage = '';
  String userDescrip = '';
  String userFullName = '';
  String misName = '';
  String misDetail = '';
  String misType = '';
  bool isFinished = false;
  int remainMC = 0;
  int statusRace = 0;

  int mcID = 0;
  int misID = 0;
  int idUser = 0;
  int idMis = 0;
  int sqnum = 0;
  int idTeam = 0;
  int idAt = 0;
  int status = 0;
  int lastMis = 0;
  Timer updateLocationTimer = Timer(Duration(seconds: 10), () {});
  Timer updateLocationTimerPlayer = Timer(Duration(seconds: 10), () {});
  bool showAppbar = false;
  bool isSubmit = false;
  bool firstMis = false;
  int raceStatus = 0;

  double latMiscomp = 0;
  double lngMiscomp = 0;
  String attendDateTime = '';
}
