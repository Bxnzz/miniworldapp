import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miniworldapp/page/Host/rank_race.dart';
import 'package:provider/provider.dart';

import '../../model/race.dart';
import '../../model/result/attendRaceResult.dart';
import '../../service/attend.dart';
import '../../service/provider/appdata.dart';
import '../../service/race.dart';
import '../../widget/loadData.dart';
import '../showmap.dart';

class Spectator extends StatefulWidget {
  const Spectator({super.key});

  @override
  State<Spectator> createState() => _SpectatorState();
}

class _SpectatorState extends State<Spectator> {
  int idrace = 0;
  List<Race> races = [];
  List<AttendRace> teamAttends = [];

  late Future<void> loadDataMethod;
  late RaceService raceService;
  late AttendService attendService;

  @override
  @override
  void initState() {
    super.initState();
    // 2.1 object ของ service โดยต้องส่ง baseUrl (จาก provider) เข้าไปด้วย
    raceService = RaceService(Dio(), baseUrl: context.read<AppData>().baseurl);

    attendService =
        AttendService(Dio(), baseUrl: context.read<AppData>().baseurl);

    // 2.2 async method
    loadDataMethod = loadData();
  }

  Future<void> loadData() async {
    startLoading(context);
    try {
      idrace = context.read<AppData>().idrace;
    } catch (err) {
      log('Error:$err');
    } finally {
      stopLoading();
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
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
                Get.to(RankRace());
                context.read<AppData>().idrace = idrace;
                log('raceeeeeeee'+idrace.toString());
              },
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(children: [
          SizedBox(
              height: 300,
              child: Stack(
                children: [ShowMapPage()],
              )),
          // missionInput(),
        ]),
      ),
    );
  }
}
