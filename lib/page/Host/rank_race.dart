import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:miniworldapp/model/team.dart';
import 'package:miniworldapp/service/mission.dart';
import 'package:miniworldapp/service/missionComp.dart';
import 'package:provider/provider.dart';

import '../../model/mission.dart';
import '../../model/missionComp.dart';
import '../../service/provider/appdata.dart';
import '../../widget/loadData.dart';

class RankRace extends StatefulWidget {
  const RankRace({super.key});

  @override
  State<RankRace> createState() => _RankRaceState();
}

class _RankRaceState extends State<RankRace> {
  late MissionCompService missionCompService;
  late MissionService missionService;

  late Future<void> loadDataMethod;
  List<Mission> missions = [];
  List<MissionComplete> missionComs = [];
  int idrace = 0;

  List<Mission> reMissions = [];

  @override
  void initState() {
    super.initState();
    missionService =
        MissionService(Dio(), baseUrl: context.read<AppData>().baseurl);

    missionCompService =
        MissionCompService(Dio(), baseUrl: context.read<AppData>().baseurl);

    // 2.2 async method
    loadDataMethod = loadData();
  }

  Future<void> loadData() async {
    startLoading(context);
    try {
      idrace = context.read<AppData>().idrace;
      var a = await missionService.missionByraceID(raceID: idrace);
      missions = a.data;
      // log(missions.length.toString());
      reMissions = missions.reversed.toList();
      log(reMissions.first.misSeq.toString());

      var mcs = await missionCompService.missionCompByraceId(raceID: idrace);
      missionComs = mcs.data;
      List<MissionComplete> teams = [];
      for (var mission in reMissions) {
        var mcs =
            missionComs.where((element) => element.misId == mission.misId);
        // mcs = teams ที่ผ่าน mission id นี้ 110, 109, 108
        for (var mc in mcs) {
          log('mcccc' + mc.teamId.toString());
          log('misid ' + mission.misId.toString());
          if (teams.where((e) => e.teamId == mc.teamId).isEmpty) {
            teams.add(mc);
          }
        }
      }
      //loop เรียงลำดับ
      for (var i = 0; i < teams.length; i++) {
        log('Rank: ${i+1} ${teams[i].teamId} ${teams[i].team.teamName} ${teams[i].misId} ${teams[i].mcDatetime}' );
      }
      debugPrint(teams.toString());

      //log(missionComs.length.toString());
      //    misStatus = mcs.data.where((element) => element.mcStatus == 1);
    } catch (err) {
      log('Error:$err');
    } finally {
      stopLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
