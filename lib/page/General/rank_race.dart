import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:miniworldapp/model/DTO/rewardDTO.dart';
import 'package:miniworldapp/model/result/attendRaceResult.dart';
import 'package:miniworldapp/model/result/rewardResult.dart';
import 'package:miniworldapp/model/reward.dart';
import 'package:miniworldapp/model/team.dart';
import 'package:miniworldapp/page/General/share.dart';
import 'package:miniworldapp/page/Host/race_review.dart';
import 'package:miniworldapp/service/attend.dart';
import 'package:miniworldapp/service/mission.dart';
import 'package:miniworldapp/service/missionComp.dart';
import 'package:provider/provider.dart';

import '../../model/mission.dart';
import '../../model/missionComp.dart';
import '../../service/provider/appdata.dart';
import '../../service/reward.dart';
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
  late RewardService rewardService;

  late Future<void> loadDataMethod;
  List<Mission> missions = [];
  List<MissionComplete> missionComs = [];
  List<MissionComplete> teams = [];
  List<AttendRace> attends = [];
  List<RewardResult> rewards = [];
  List<Map<String, List<AttendRace>>> attendShow = [];

  int idrace = 0;
  int idUser = 0;
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

    rewardService =
        RewardService(Dio(), baseUrl: context.read<AppData>().baseurl);

    // 2.2 async method
    loadDataMethod = loadData();
  }

  Future<void> loadData() async {
    startLoading(context);
    try {
      idrace = context.read<AppData>().idrace;
      log("idrace $idrace");
      idUser = context.read<AppData>().idUser;
      var r = await rewardService.rewardByRaceID(raceID: idrace);
      rewards = r.data;

      for (var element in rewards) {
        //  log('xxxxx'+element.reType.toString() + element.team.teamName);
        if (element.reType == 1) {
          teamImage1 = element.team.teamImage;
          teamName1 = element.team.teamName;
          log('1 ' + element.team.teamName);
        }
        if (element.reType == 2) {
          teamImage2 = element.team.teamImage;
          teamName2 = element.team.teamName;
          log('2 ' + element.team.teamName);
        }
        if (element.reType == 3) {
          teamImage3 = element.team.teamImage;
          teamName3 = element.team.teamName;
          log('2 ' + element.team.teamName);
        }
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
      backgroundColor: const Color.fromARGB(255, 224, 193, 246),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('ลำดับการแข่งขัน'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 0),
            child: IconButton(
              icon: Image.asset(
                "assets/image/review.png",
              ),
              onPressed: () {
                context.read<AppData>().idrace = idrace;
                Get.to(() => raceReview());
              },
            ),
          ),
          IconButton(
              onPressed: () {
                Get.to(Share());
              },
              icon: Container(
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.amberAccent),
                  child: const Center(
                    child: FaIcon(
                      FontAwesomeIcons.shareNodes,
                      color: Colors.white,
                    ),
                  ))),
        ],
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: FaIcon(
            FontAwesomeIcons.circleChevronLeft,
            color: Colors.yellow,
            size: 35,
          ),
        ),
      ),
      body: FutureBuilder(
          future: loadDataMethod,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: <Widget>[
                  SizedBox(
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
                                  style: Get.textTheme.bodyLarge!.copyWith(
                                      color: Get.theme.colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Positioned(
                          top: Get.height * 0.08,
                          left: 10,
                          right: 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          image: NetworkImage(teamImage2),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  Text(teamName2,
                                      style: Get.textTheme.bodyLarge!.copyWith(
                                          color:
                                              Get.theme.colorScheme.onPrimary,
                                          fontWeight: FontWeight.bold)),
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
                                          image: NetworkImage(teamImage3),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  Text(teamName3,
                                      style: Get.textTheme.bodyLarge!.copyWith(
                                          color:
                                              Get.theme.colorScheme.onPrimary,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: rewards.map((e) {
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
                                          children: [
                                            rewards.indexOf(e) == 0
                                                ? SizedBox(
                                                    width: 40,
                                                    height: 40,
                                                    child: Image.asset(
                                                        "assets/image/crown1.png"),
                                                  )
                                                : rewards.indexOf(e) == 1
                                                    ? SizedBox(
                                                        width: 40,
                                                        height: 40,
                                                        child: Image.asset(
                                                            "assets/image/crown2.png"),
                                                      )
                                                    : rewards.indexOf(e) == 2
                                                        ? SizedBox(
                                                            width: 40,
                                                            height: 40,
                                                            child: Image.asset(
                                                                "assets/image/crown3.png"),
                                                          )
                                                        : rewards.indexOf(e) >=
                                                                3
                                                            ? Container(
                                                                width: 40,
                                                                height: 40,
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Get
                                                                        .theme
                                                                        .colorScheme
                                                                        .primary),
                                                                child: Center(
                                                                  child: Text(
                                                                      '${rewards.indexOf(e) + 1}',
                                                                      style: Get
                                                                          .textTheme
                                                                          .bodyLarge!
                                                                          .copyWith(
                                                                              color: Get.theme.colorScheme.onPrimary,
                                                                              fontWeight: FontWeight.bold)),
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
                                                    atts.keys.first == idUser))
                                              Text(
                                                e.team.teamName + '(ทีมคุณ)',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.deepPurple,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            else
                                              Text(
                                                e.team.teamName,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                                          Text(te
                                                                              .user
                                                                              .userName),
                                                                          CircleAvatar(
                                                                            radius:
                                                                                Get.width / 6,
                                                                            backgroundImage:
                                                                                NetworkImage(te.user.userImage),
                                                                          ),
                                                                          Text(te
                                                                              .user
                                                                              .userFullname),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    content:
                                                                        Text(
                                                                      te.user
                                                                          .userDiscription,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
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
                                                                    radius: 25,
                                                                    backgroundImage:
                                                                        NetworkImage(te
                                                                            .user
                                                                            .userImage)),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 5,
                                                                      left: 5),
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
    );
  }
}
