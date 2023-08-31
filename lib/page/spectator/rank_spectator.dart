import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../model/mission.dart';
import '../../model/missionComp.dart';
import '../../model/result/attendRaceResult.dart';
import '../../service/attend.dart';
import '../../service/mission.dart';
import '../../service/missionComp.dart';
import '../../service/provider/appdata.dart';
import '../../widget/loadData.dart';
import '../General/share.dart';

class RankSpectator extends StatefulWidget {
  const RankSpectator({super.key});

  @override
  State<RankSpectator> createState() => _RankSpectatorState();
}

class _RankSpectatorState extends State<RankSpectator> {
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
  int idUser = 0;
  int lastMis = 0;
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
      teams = [];
      idrace = context.read<AppData>().idrace;
      idUser = context.read<AppData>().idUser;
      log('race  ' + idrace.toString());

      var a = await missionService.missionByraceID(raceID: idrace);
      missions = a.data;
      lastMis = a.data.last.misSeq;
      log(missions.length.toString());
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
      // loop เรียงลำดับ
      for (var i = 0; i < teams.length; i++) {
        log('Rank: ${i + 1} ${teams[i].teamId} ${teams[i].team.teamName} ${teams[i].misId} ${teams[i].mcDatetime} ${teams[i].mission.misSeq}');
      }

      if (teams.length >= 1) {
        teamImage1 = teams[0].team.teamImage;
        teamName1 = teams[0].team.teamName;
      }
      if (teams.length >= 2) {
        teamImage2 = teams[1].team.teamImage;
        teamName2 = teams[1].team.teamName;
      }
      if (teams.length >= 3) {
        teamImage3 = teams[2].team.teamImage;
        teamName3 = teams[2].team.teamName;
      }

      log(teamImage1);
      log('name' + teamName1);
      debugPrint(teams.toString());

      var att = await attendService.attendByRaceID(raceID: idrace);
      attendShow = [];
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

  Future refresh() async {
    setState(() {
      loadDataMethod = loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 224, 193, 246),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('ความคืบหน้าภารกิจ'),
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: FutureBuilder(
            future: loadDataMethod,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Column(
                  children: <Widget>[
                    teamImage1 != ''
                        ? SizedBox(
                            height: 260, //30 for bottom
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 0,
                                  // bottom: 150, // to shift little up
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
                                    height: 250,
                                  ),
                                ),
                                Positioned(
                                  top: 20,
                                  left: 10,
                                  right: 10,
                                  child: Column(
                                    children: [
                                      teamImage1 != ''
                                          ? SizedBox(
                                              width: 50,
                                              height: 50,
                                              child: Image.asset(
                                                  "assets/image/crown1.png"),
                                            )
                                          : Container(),
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
                                          style: Get.textTheme.bodyLarge!
                                              .copyWith(
                                                  color: Get.theme.colorScheme
                                                      .onPrimary,
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
                                          teamImage2 != ''
                                              ? SizedBox(
                                                  width: 50,
                                                  height: 50,
                                                  child: Image.asset(
                                                      "assets/image/crown2.png"),
                                                )
                                              : Container(),
                                          Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image:
                                                      NetworkImage(teamImage2),
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          Text(teamName2,
                                              style: Get.textTheme.bodyLarge!
                                                  .copyWith(
                                                      color: Get
                                                          .theme
                                                          .colorScheme
                                                          .onPrimary,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          teamImage3 != ''
                                              ? SizedBox(
                                                  width: 50,
                                                  height: 50,
                                                  child: Image.asset(
                                                      "assets/image/crown3.png"),
                                                )
                                              : Container(),
                                          Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image:
                                                      NetworkImage(teamImage3),
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          Text(teamName3,
                                              style: Get.textTheme.bodyLarge!
                                                  .copyWith(
                                                      color: Get
                                                          .theme
                                                          .colorScheme
                                                          .onPrimary,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox(
                            height: 260, //30 for bottom
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 0,
                                  // bottom: 150, // to shift little up
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
                                    height: 250,
                                  ),
                                ),
                                Positioned(
                                  top: 100,
                                  left: 0,
                                  right: 0,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                          child: Text(
                                              'ยังไม่มีทีมที่ผ่านภารกิจ',
                                              style: Get
                                                  .textTheme.headlineSmall!
                                                  .copyWith(
                                                      color: Get
                                                          .theme
                                                          .colorScheme
                                                          .onPrimary,
                                                      fontWeight:
                                                          FontWeight.bold))),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                    // Card(
                    //   clipBehavior: Clip.hardEdge,
                    //   child: InkWell(
                    //     borderRadius: BorderRadius.circular(12.0),
                    //     splashColor: Colors.blue.withAlpha(30),
                    //     onTap: () {},
                    //    child: ExpansionTile(title: Text('ภารกิจทั้งหมด')),
                    //   ),
                    // ),
                    Expanded(
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
                                      // Positioned(
                                      //   child: Opacity(
                                      //     opacity: 0.3,
                                      //     child: Image.network(
                                      //       e.team.teamImage,
                                      //       height: 60,
                                      //       width: double.infinity,
                                      //       fit: BoxFit.cover,
                                      //     ),
                                      //   ),
                                      // ),
                                      Container(
                                        alignment: Alignment.center,
                                        // For testing different size item. You can comment this line
                                        child: ListTile(
                                          title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              teams.indexOf(e) == 0
                                                  ? SizedBox(
                                                      width: 55,
                                                      height: 55,
                                                      child: Image.asset(
                                                          "assets/image/crown1.png"),
                                                    )
                                                  : teams.indexOf(e) == 1
                                                      ? SizedBox(
                                                          width: 55,
                                                          height: 55,
                                                          child: Image.asset(
                                                              "assets/image/crown2.png"),
                                                        )
                                                      : teams.indexOf(e) == 2
                                                          ? SizedBox(
                                                              width: 55,
                                                              height: 55,
                                                              child: Image.asset(
                                                                  "assets/image/crown3.png"),
                                                            )
                                                          : teams.indexOf(e) >=
                                                                  3
                                                              ? Container(
                                                                  width: 55,
                                                                  height: 55,
                                                                  decoration: BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      color: Get
                                                                          .theme
                                                                          .colorScheme
                                                                          .primary),
                                                                  child: Center(
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                            '${teams.indexOf(e) + 1}',
                                                                            style:
                                                                                Get.textTheme.bodyLarge!.copyWith(color: Get.theme.colorScheme.onPrimary, fontWeight: FontWeight.bold)),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )
                                                              : Container(),
                                            ],
                                          ),
                                        ),
                                      ),
                                      ExpansionTile(
                                          title: Stack(
                                            alignment: Alignment.center,
                                            children: <Widget>[
                                              // Stroked text as border.
                                              if (attendShow.where((att) =>
                                                      att.keys.first ==
                                                      e.teamId) ==
                                                  attendShow.where((atts) =>
                                                      atts.keys.first ==
                                                      idUser))
                                                Text(
                                                  e.team.teamName + '(ทีมคุณ)',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.deepPurple,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              else
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(
                                                      e.team.teamName,
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 55),
                                                      child: Expanded(
                                                        child:
                                                            LinearPercentIndicator(
                                                          barRadius:
                                                              const Radius
                                                                  .circular(50),
                                                          width: 200,
                                                          animation: true,
                                                          lineHeight: 20.0,
                                                          animationDuration:
                                                              2500,
                                                          percent:
                                                              e.mission.misSeq /
                                                                  lastMis,
                                                          center: Text(e.mission
                                                                  .misSeq
                                                                  .toString() +
                                                              '/' +
                                                              lastMis
                                                                  .toString()),
                                                          linearStrokeCap:
                                                              LinearStrokeCap
                                                                  .roundAll,
                                                          progressColor:
                                                              Colors.amber,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
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
                                                      MainAxisAlignment.start,
                                                  children: element.values.first
                                                      .map((te) {
                                                    return InkWell(
                                                      onTap: () {
                                                        showDialog<void>(
                                                            context: context,
                                                            builder:
                                                                (context) =>
                                                                    AlertDialog(
                                                                      title:
                                                                          SizedBox(
                                                                        width: Get
                                                                            .width,
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Text(te.user.userName),
                                                                            CircleAvatar(
                                                                              radius: Get.width / 6,
                                                                              backgroundImage: NetworkImage(te.user.userImage),
                                                                            ),
                                                                            Text(te.user.userFullname),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      content:
                                                                          Text(
                                                                        te.user
                                                                            .userDiscription,
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                    ));
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Divider(),
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 5),
                                                                child:
                                                                    GestureDetector(
                                                                  child: CircleAvatar(
                                                                      radius:
                                                                          25,
                                                                      backgroundImage: NetworkImage(te
                                                                          .user
                                                                          .userImage)),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 5,
                                                                        left:
                                                                            5),
                                                                child: Text(
                                                                  te.user
                                                                      .userName,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    );
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
                );
              } else {
                return Container();
              }
            }),
      ),
    );
  }
}
