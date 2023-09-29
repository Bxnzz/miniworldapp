import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miniworldapp/page/General/rank_race.dart';
import 'package:miniworldapp/page/spectator/rank_spectator.dart';
import 'package:miniworldapp/page/spectator/realtimeChat.dart';
import 'package:miniworldapp/service/user.dart';
import 'package:provider/provider.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:image_size_getter/image_size_getter.dart';
import 'package:image_size_getter_http_input/image_size_getter_http_input.dart';

import '../../model/race.dart';
import '../../model/result/attendRaceResult.dart';
import '../../model/user.dart';
import '../../service/attend.dart';
import '../../service/provider/appdata.dart';
import '../../service/race.dart';
import '../../widget/loadData.dart';
import '../showmap.dart';
import 'package:uuid/uuid.dart';

class Spectator extends StatefulWidget {
  const Spectator({super.key});

  @override
  State<Spectator> createState() => _SpectatorState();
}

class _SpectatorState extends State<Spectator> {
  int idrace = 0;
  int iduser = 0;
  String nameRace = '';
  String userName = '';
  List<Race> races = [];
  List<User> users = [];
  List<AttendRace> teamAttends = [];
//  bool showAppbar = false;
  late Future<void> loadDataMethod;
  late RaceService raceService;
  late AttendService attendService;
  late UserService userService;

  @override
  @override
  void initState() {
    super.initState();
    // 2.1 object ของ service โดยต้องส่ง baseUrl (จาก provider) เข้าไปด้วย
    raceService = RaceService(Dio(), baseUrl: context.read<AppData>().baseurl);

    attendService =
        AttendService(Dio(), baseUrl: context.read<AppData>().baseurl);

    userService = UserService(Dio(), baseUrl: context.read<AppData>().baseurl);
    //context.read<AppData>().showAppbar = showAppbar;
    // 2.2 async method
    loadDataMethod = loadData();
  }

  Future<void> loadData() async {
    startLoading(context);
    try {
      idrace = context.read<AppData>().idrace;
      iduser = context.read<AppData>().idrace;

      var r = await raceService.racesByraceID(raceID: idrace);
      races = r.data;
      nameRace = r.data.first.raceName;

      var u = await userService.getUserByID(userID: iduser);
      users = u.data;
      userName = u.data.first.userName;
    } catch (err) {
      log('Error:$err');
    } finally {
      stopLoading();
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
       extendBodyBehindAppBar: true,
      appBar: AppBar(
  
        title: Text('โหมดผู้ชม'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              icon: Image.asset(
                "assets/image/rank.png",
              ),
              onPressed: () {
                Get.to(RankSpectator());
                context.read<AppData>().idrace = idrace;
                log('raceeeeeeee' + idrace.toString());
              },
            ),
          )
        ],
      ),
      body: FutureBuilder(
          future: loadDataMethod,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return SafeArea(
                child: Column(children: [
                  SizedBox(
                      height: Get.height / 3,
                      child: Stack(
                        children: [
                          ShowMapPage(showAppbar: false),
                        ],
                      )),
                  Expanded(
                      child: RealtimeChat(
                    raceID: idrace,
                    raceName: nameRace,
                    userID: 0,
                  )),
                ]),
              );
            } else {
              return Container();
            }
          }),
    );
  }
}
