import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:miniworldapp/model/missionComp.dart' as misComp;
import 'package:miniworldapp/model/mission.dart';

import 'package:miniworldapp/service/mission.dart';
import 'package:miniworldapp/service/missionComp.dart';
import 'package:provider/provider.dart';

import '../../model/mission.dart';
import '../../service/provider/appdata.dart';

class PlayerRaceStartMis extends StatefulWidget {
  const PlayerRaceStartMis({super.key});

  @override
  State<PlayerRaceStartMis> createState() => _PlayerRaceStartMisState();
}

class _PlayerRaceStartMisState extends State<PlayerRaceStartMis> {
  late MissionCompService missionCompService;
  late MissionService missionService;
  late List<misComp.MissionComplete> missionComp;
  late List<Mission> mission;
  late int IDteam;
  late int CompmissionId;

  late Future<void> loadDataMethod;

  @override
  void initState() {
    super.initState();
    IDteam = context.read<AppData>().idTeam;
    missionCompService =
        MissionCompService(Dio(), baseUrl: context.read<AppData>().baseurl);
    missionService =
        MissionService(Dio(), baseUrl: context.read<AppData>().baseurl);
    loadDataMethod = loadData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Scaffold(
      body: FutureBuilder(
        future: loadDataMethod,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            for (int i = 0; i < mission.length; i++) {
              for (int j = 0; j < missionComp.length; j++) {
                if (missionComp[j].mcStatus == 2) {
                  log("message${missionComp[j].mcStatus}");
                }
              }
            }
            return ListView(
                children: missionComp.map((e) {
              return Card(
                child: InkWell(
                  onTap: () {},
                  child: Column(
                    children: <Widget>[Text("ชื่อภารกิจ ${e.mission.misName}")],
                  ),
                ),
              );
            }).toList());
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Future<void> loadData() async {
    try {
      var a = await missionCompService.missionCompByTeamId(teamID: IDteam);
      var m = await missionService.missionAll();

      missionComp = a.data;

      mission = m.data;
      // CompmissionId = a.data;

      log(IDteam.toString());
    } catch (err) {
      log('Error:$err');
    }
  }
}
