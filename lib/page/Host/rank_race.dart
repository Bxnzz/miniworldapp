import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:miniworldapp/model/result/attendRaceResult.dart';
import 'package:miniworldapp/model/team.dart';
import 'package:miniworldapp/service/attend.dart';
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
  late AttendService attendService;

  late Future<void> loadDataMethod;
  List<Mission> missions = [];
  List<MissionComplete> missionComs = [];
  List<MissionComplete> teams = [];
  List<AttendRace> attends = [];
  List<Map<String, List<AttendRace>>> attendShow = [];

  int idrace = 0;
  String teamImage1 = '';
  String teamName1 = '';
  String teamImage2 = '';
  String teamName2 = '';
  String teamImage3 = '';
  String teamName3 = '';
  List<Mission> reMissions = [];

  @override
  void initState() {
    super.initState();
    missionService =
        MissionService(Dio(), baseUrl: context.read<AppData>().baseurl);

    missionCompService =
        MissionCompService(Dio(), baseUrl: context.read<AppData>().baseurl);

    attendService =
        AttendService(Dio(), baseUrl: context.read<AppData>().baseurl);

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
        log('Rank: ${i + 1} ${teams[i].teamId} ${teams[i].team.teamName} ${teams[i].misId} ${teams[i].mcDatetime}');
        teamImage1 = teams[0].team.teamImage;
        teamName1 = teams[0].team.teamName;
        teamImage2 = teams[1].team.teamImage;
        teamName2 = teams[1].team.teamName;
        teamImage3 = teams[2].team.teamImage;
        teamName3 = teams[2].team.teamName;
      }
      log(teamImage1);
      log('name' + teamName1);
      debugPrint(teams.toString());

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
      backgroundColor: Color.fromARGB(255, 224, 193, 246),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('ลำดับการแข่งขัน'),
      ),
      body: FutureBuilder(
          future: loadDataMethod,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return SingleChildScrollView(
                child: SizedBox(
                  height: Get.height,
                  child: Stack(
                    children: [
                      SizedBox(
                        height: Get.height * 0.55 + 30, //30 for bottom
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              bottom: 150, // to shift little up
                              left: 0,
                              right: 0,
                              child: Container(
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(20),
                                    ),
                                    gradient: LinearGradient(
                                        begin: FractionalOffset(0.0, 0.0),
                                        end: FractionalOffset(1.0, 0.0),
                                        stops: [0.0, 1.0],
                                        tileMode: TileMode.clamp,
                                        colors: [
                                          Colors.purpleAccent,
                                          Color.fromARGB(255, 144, 64, 255),
                                        ])),
                                width: Get.width,
                                height: Get.height * 0.3,
                              ),
                            ),
                            Positioned(
                              top: 20,
                              left: 10,
                              right: 10,
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: 50,
                                    height: 50,
                                    child:
                                        Image.asset("assets/image/crown1.png"),
                                  ),
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(teamImage1),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  Text(teamName1,
                                      style: Get.textTheme.bodyLarge!.copyWith(
                                          color:
                                              Get.theme.colorScheme.onPrimary,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            Positioned(
                              top: Get.height * 0.08,
                              left: 10,
                              right: 10,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: Image.asset(
                                            "assets/image/crown2.png"),
                                      ),
                                      Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: NetworkImage(teamImage2),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      Text(teamName2,
                                          style: Get.textTheme.bodyLarge!
                                              .copyWith(
                                                  color: Get.theme.colorScheme
                                                      .onPrimary,
                                                  fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: Image.asset(
                                            "assets/image/crown3.png"),
                                      ),
                                      Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: NetworkImage(teamImage3),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      Text(teamName3,
                                          style: Get.textTheme.bodyLarge!
                                              .copyWith(
                                                  color: Get.theme.colorScheme
                                                      .onPrimary,
                                                  fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 250,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: ListView(
                          children: teams.map((e) {
                            return Padding(
                                padding: const EdgeInsets.only(
                                  left: 8,
                                  right: 8,
                                ),
                                child: Card(
                                  clipBehavior: Clip.hardEdge,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12.0),
                                    splashColor: Colors.blue.withAlpha(30),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          child: Opacity(
                                            opacity: 0.3,
                                            child: Image.network(
                                              e.team.teamImage,
                                              height: 60,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          child: Container(
                                            alignment: Alignment.center,
                                            // For testing different size item. You can comment this line
                                            child: ListTile(
                                              title: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  teams.indexOf(e) == 0
                                                      ? SizedBox(
                                                          width: 40,
                                                          height: 40,
                                                          child: Image.asset(
                                                              "assets/image/crown1.png"),
                                                        )
                                                      : teams.indexOf(e) == 1
                                                          ? SizedBox(
                                                              width: 40,
                                                              height: 40,
                                                              child: Image.asset(
                                                                  "assets/image/crown2.png"),
                                                            )
                                                          : teams.indexOf(e) ==
                                                                  2
                                                              ? SizedBox(
                                                                  width: 40,
                                                                  height: 40,
                                                                  child: Image
                                                                      .asset(
                                                                          "assets/image/crown3.png"),
                                                                )
                                                              : teams.indexOf(
                                                                          e) >=
                                                                      3
                                                                  ? Container(
                                                                      width: 40,
                                                                      height:
                                                                          40,
                                                                      decoration: const BoxDecoration(
                                                                          shape: BoxShape
                                                                              .circle,
                                                                          color:
                                                                              Colors.white),
                                                                      child:
                                                                          Center(
                                                                        child: Text(
                                                                            '${teams.indexOf(e) + 1}',
                                                                            style:
                                                                                Get.textTheme.bodyLarge!.copyWith(color: Get.theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                                                                      ),
                                                                    )
                                                                  : Container(),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        ExpansionTile(
                                            title: Stack(
                                              alignment: Alignment.center,
                                              children: <Widget>[
                                                // Stroked text as border.
                                                Text(
                                                  e.team.teamName,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    foreground: Paint()
                                                      ..style =
                                                          PaintingStyle.stroke
                                                      ..strokeWidth = 3
                                                      ..color = Colors.white,
                                                  ),
                                                ),
                                                // Solid text as fill.
                                                Text(
                                                  e.team.teamName,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            children: attendShow
                                                .where((atUser) =>
                                                    atUser.keys.first ==
                                                    e.teamId.toString())
                                                .map((element) {
                                              /// attendShow
                                              /// [{'130', ['kop', 'dan']}, {'129', ['bob']}
                                              /// , {'101', ['ar ap....']}]
                                              /// element.values.first => ['kop', 'dan']

                                              return ListTile(
                                                title: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: element
                                                        .values.first
                                                        .map((te) {
                                                      return Text(
                                                          te.user.userName);
                                                    }).toList()),
                                              );
                                            }).toList())
                                      ],
                                    ),
                                  ),
                                ));
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Container();
            }
          }),
    );
  }
}
