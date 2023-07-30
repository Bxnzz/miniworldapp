import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miniworldapp/service/race.dart';
import 'package:miniworldapp/service/reward.dart';
import 'package:miniworldapp/widget/loadData.dart';
import 'package:provider/provider.dart';

import '../../model/race.dart';
import '../../model/result/attendRaceResult.dart';
import '../../model/reward.dart';
import '../../service/attend.dart';
import '../../service/provider/appdata.dart';

class Share extends StatefulWidget {
  const Share({super.key});

  @override
  State<Share> createState() => _ShareState();
}

class _ShareState extends State<Share> {
  late AttendService attendService;
  late RewardService rewardService;
  late RaceService raceService;

  List<AttendRace> attends = [];
  List<Reward> rewards = [];
  List<Race> races = [];
  List<Map<String, List<AttendRace>>> attendShow = [];

 int idUser = 0;
 int idrace = 0;

  late Future<void> loadDataMethod;

  @override
  void initState() {
    super.initState();
    raceService = 
     RaceService(Dio(), baseUrl: context.read<AppData>().baseurl);

       attendService =
        AttendService(Dio(), baseUrl: context.read<AppData>().baseurl);

    rewardService =
        RewardService(Dio(), baseUrl: context.read<AppData>().baseurl);

    // 2.2 async method
    loadDataMethod = loadData();
  }
   Future<void> loadData() async {
     idrace = context.read<AppData>().idrace;
     idUser = context.read<AppData>().idUser;
      startLoading(context);
    try {
      idrace = context.read<AppData>().idrace;
      idUser = context.read<AppData>().idUser;
    
     var re = await rewardService.rewardByRaceID(raceID: idrace);
     rewards = re.data;

      var att = await attendService.attendByRaceID(raceID: idrace);
      attends = att.data;
      String tmId = '';
      List<AttendRace> temp = [];
      for (var i = 0; i < attends.length; i++) {
        if (attends[i].teamId.toString() != tmId) {
          if (temp.isNotEmpty) {
            var team = {tmId: temp};
            attendShow.add(team);
            temp = [];
          }
          tmId = attends[i].teamId.toString();
          // log(tmId.toString());
        }

        temp.add(attends[i]);
      }
      if (temp.isNotEmpty) {
        var team = {tmId: temp};
        attendShow.add(team);
      }

      // for (var at in attendShow) {
      //   log(at.keys.first.toString());
      //   var tt = at.values.first;
      //   for (var teamUser in tt) {
      //     log(teamUser.userId.toString());
      //   }
      // }
      //    misStatus = mcs.data.where((element) => element.mcStatus == 1);
    } catch (err) {
      log('Error:$err');
    } finally {
      stopLoading();
    }
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                     Colors.purpleAccent,
                    Colors.blue,
                     Colors.purpleAccent,
                  ]
              )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 100,),
              Container(
                width: 325,
                height: 470,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
          
              )
            ],
          ),
        ),
      ),
    );
  }
}
