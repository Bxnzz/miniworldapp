import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:miniworldapp/model/DTO/rewardDTO.dart';
import 'package:miniworldapp/model/attend.dart';
import 'package:miniworldapp/model/missionComp.dart';
import 'package:miniworldapp/model/result/attendRaceResult.dart';
import 'package:miniworldapp/model/team.dart';
import 'package:miniworldapp/page/General/detil_race_host.dart';
import 'package:miniworldapp/page/General/home_all.dart';
import 'package:miniworldapp/page/General/home_create.dart';
import 'package:miniworldapp/page/Host/list_approve.dart';
import 'package:miniworldapp/page/General/rank_race.dart';
import 'package:miniworldapp/page/General/showmap.dart';
import 'package:miniworldapp/service/missionComp.dart';
import 'package:miniworldapp/service/race.dart';
import 'package:miniworldapp/service/team.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:giffy_dialog/giffy_dialog.dart';

import '../../model/DTO/raceStatusDTO.dart';
import '../../model/mission.dart';
import '../../model/result/raceResult.dart';
import '../../model/reward.dart';
import '../../service/attend.dart';
import '../../service/mission.dart';
import '../../service/provider/appdata.dart';
import '../../service/reward.dart';
import '../../widget/loadData.dart';
import '../spectator/rank_spectator.dart';

class CheckMissionList extends StatefulWidget {
  const CheckMissionList({super.key});

  @override
  State<CheckMissionList> createState() => _CheckMissionListState();
}

class _CheckMissionListState extends State<CheckMissionList> {
  late RaceResult misRe;
  int idrace = 0;
  List<Mission> missions = [];
  List<MissionComplete> missionComs = [];
  List<MissionComplete> teamRewards = [];
  List<Team> teams = [];
  List<AttendRace> attends = [];
  List<Reward> rewards = [];
  Map<String, dynamic> mc = {};
  List<Mission> reMissions = [];

  final seq = <int>[];
  late Future<void> loadDataMethod;
  late RaceResult misResults;
  late AttendService attendService;
  late MissionService missionService;
  late TeamService teamService;
  late RaceService raceService;
  late MissionCompService missionCompService;
  late RewardService rewardService;
  String raceName = '';
  String type1 = '';
  String type2 = '';
  String type3 = '';
  String mType = '';
  String types = '';
  String misType = '';
  int misStatus = 0;
  int raceStatus = 0;
  int rStatus = 0;
  int misID = 0;
  int remainMC = 0;

  List<int> teamsID = [];
  List<String> playerIds = [];

  bool isLoaded = false;

  bool inReorder = false;

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // context.read<AppData>().remainMC = 0;

    idrace = context.read<AppData>().idrace;
    log('id' + idrace.toString());

    raceStatus = context.read<AppData>().raceStatus;
    log('status' + raceStatus.toString());

    missionService =
        MissionService(Dio(), baseUrl: context.read<AppData>().baseurl);

    attendService =
        AttendService(Dio(), baseUrl: context.read<AppData>().baseurl);

    missionCompService =
        MissionCompService(Dio(), baseUrl: context.read<AppData>().baseurl);

    teamService = TeamService(Dio(), baseUrl: context.read<AppData>().baseurl);

    raceService = RaceService(Dio(), baseUrl: context.read<AppData>().baseurl);

    rewardService =
        RewardService(Dio(), baseUrl: context.read<AppData>().baseurl);

    // 2.2 async method
    loadDataMethod = loadData();
  }

  Future<void> loadData() async {
    startLoading(context);
    try {
      var a = await missionService.missionByraceID(raceID: idrace);
      missions = a.data;
      mType = a.data.first.misType.toString();
      raceName = a.data.first.race.raceName;
      rStatus = a.data.first.race.raceStatus;
      // rStatus = a.
      //log('status ' + rStatus.toString());

      var t = await teamService.teambyRaceID(raceID: idrace);
      teams = t.data;
      teamsID.clear();
      for (var element in t.data) {
        teamsID.add(element.teamId);
      }
      log('team ' + teamsID.toString());

      var at = await attendService.attendByRaceID(raceID: idrace);
      attends = at.data;
      playerIds.clear();
      for (var element in at.data) {
        if (element.user.onesingnalId.isNotEmpty) {
          playerIds.add(element.user.onesingnalId);
        }
      }
      log('att ' + playerIds.toString());
      var mcs =
          await missionCompService.missionCompByraceIdApprove(raceID: idrace);
      missionComs = mcs.data;
      // log('ms '+misID.toString());

      reMissions = missions.reversed.toList();
      log(reMissions.first.misSeq.toString());
      //    misStatus = mcs.data.where((element) => element.mcStatus == 1);
      for (var mission in reMissions) {
        var mcs =
            missionComs.where((element) => element.misId == mission.misId);
        // mcs = teams ที่ผ่าน mission id นี้ 110, 109, 108
        for (var mcc in mcs) {
          log('mcccc' + mcc.teamId.toString());
          log('misid ' + mission.misId.toString());
          if (teamRewards.where((e) => e.teamId == mcc.teamId).isEmpty) {
            teamRewards.add(mcc);
          }
        }
      }

      isLoaded = true;
    } catch (err) {
      isLoaded = false;
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

  // void _Endgame() async {
  //   startLoading(context);
  //   raceStatus = 3;
  //   //log(remainMC.to)
  //   // RaceStatusDto racedto = RaceStatusDto(raceStatus: raceStatus);
  //   // var racestatus = await raceService.updateStatusRaces(racedto, idrace);
  //   // mc = {
  //   //   'notitype': 'endgame',
  //   //   'mcid': raceStatus,
  //   //   'raceID': idrace,
  //   //   'raceName': raceName
  //   // };
  //   // var notification1 = OSCreateNotification(
  //   //     //playerID
  //   //     additionalData: mc,
  //   //     playerIds: playerIds,
  //   //     content: raceName,
  //   //     heading: "จบการแข่งขัน",
  //   //     //  iosAttachments: {"id1",urlImage},
  //   //     // bigPicture: imUrlString,
  //   //     buttons: [
  //   //       OSActionButton(text: "ตกลง", id: "id1"),
  //   //       OSActionButton(text: "ยกเลิก", id: "id2")
  //   //     ]);
  //   // log('player ' + playerIds.toString());
  //   // var response1 = await OneSignal.shared.postNotification(notification1);

  //   // Get.defaultDialog(title: 'จบการแข่งขันแล้ว')
  //   //     .then((value) => Get.to(HomeAll()));
  //   stopLoading();
  // }

  void _processGame() async {
    AwesomeDialog(
      dialogBackgroundColor: Colors.white,
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.bottomSlide,
      headerAnimationLoop: false,
      title: 'จบการแข่งขัน',
      desc: 'ต้องการที่จะจบการแข่งขัน?',
      btnOkText: "ยกเลิก",
      btnCancelText: "ตกลง",
      btnOkOnPress: () async {},
      btnCancelColor: Colors.lightGreen,
      btnOkColor: Colors.redAccent,
      btnCancelOnPress: () async {
        startLoading(context);
        raceStatus = 4;
        RaceStatusDto racedto = RaceStatusDto(raceStatus: raceStatus);
        var racestatus = await raceService.updateStatusRaces(racedto, idrace);

        for (var i = 0; i < teamRewards.length; i++) {
          log('Rank: ${i + 1} ${teamRewards[i].teamId} ${teamRewards[i].team.teamName} ${teamRewards[i].misId} ${teamRewards[i].mcDatetime}');

          RewardDto rewardDto = RewardDto(
              reType: i + 1, teamId: teamRewards[i].teamId, raceId: idrace);
          log('re' + rewardDtoToJson(rewardDto));
          // ('reward'+rewardDto.toString());
          var reward = await rewardService.reward(rewardDto);
        }

        mc = {
          'notitype': 'processgame',
          'mcid': raceStatus,
          'raceID': idrace,
          'raceName': raceName
        };
        var notification1 = OSCreateNotification(
            //playerID
            additionalData: mc,
            playerIds: playerIds,
            content: raceName,
            heading: "ประมวลผลการแข่งขัน",
            //  iosAttachments: {"id1",urlImage},
            // bigPicture: imUrlString,
            buttons: [
              OSActionButton(text: "ตกลง", id: "id1"),
              OSActionButton(text: "ยกเลิก", id: "id2")
            ]);
        log('player ' + playerIds.toString());

        var response1 = await OneSignal.shared.postNotification(notification1);

        Get.off(() => RankRace());

        context.read<AppData>().idrace = idrace;
        setState(() {
          loadDataMethod = loadData();
        });
        stopLoading();
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Get.to(() => DetailHost());
          return true;
        },
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 238, 238, 238),
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                icon: Image.asset(
                  "assets/image/rank.png",
                ),
                onPressed: () {
                  Get.to(RankSpectator());
                  context.read<AppData>().idrace = idrace;
                  log('raceeeeeeee' + idrace.toString());
                },
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: IconButton(
                  icon: Image.asset("assets/image/target.png"),
                  onPressed: () {
                    Get.to(() => ShowMapPage(
                          showAppbar: true,
                        ));
                    context.read<AppData>().idrace = idrace;
                  },
                ),
              ),
            ],
            title: Text('ตรวจสอบหลักฐาน'),
          ),
          body: FutureBuilder(
              future: loadDataMethod,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  remainMC = 0;
                  return RefreshIndicator(
                    onRefresh: refresh,
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.only(top: 10),
                            children: missions.map((element) {
                              final theme = Theme.of(context);
                              final textTheme = theme.textTheme;
                              var mcStatus = missionComs
                                  .where((e) =>
                                      e.mission.misId == element.misId &&
                                      e.mcStatus == 1)
                                  .length;
                              if (element.misType.isEqual(12)) {
                                misType = 'ข้อความ,สื่อ';
                              } else if (element.misType.isEqual(1)) {
                                misType = 'ข้อความ';
                              } else if (element.misType.isEqual(2)) {
                                misType = 'รูป,คลิป';
                              } else if (element.misType.isEqual(3)) {
                                misType = 'ไม่มีการส่ง';
                              } else {}
                              log(element.misId.toString());
                              log(missionComs.length.toString());

                              for (var e in missionComs
                                  .where((element) => element.mcStatus == 1)) {
                                if (e.mission.misId == element.misId) {
                                  log('FFFF ' + e.mission.misId.toString());
                                  remainMC += 1;
                                }
                              }

                              //log('remain ' + remainMC.toString());

                              //  log('mcss ' + mcStatus.toString());
                              return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8, right: 8, bottom: 8),
                                  child: badges.Badge(
                                    position: badges.BadgePosition.topEnd(
                                        top: -15, end: 5),
                                    badgeAnimation:
                                        badges.BadgeAnimation.slide(),
                                    // showBadge: _showCartBadge,
                                    badgeStyle: badges.BadgeStyle(
                                      badgeColor: Colors.red,
                                    ),
                                    badgeContent: Text(
                                      mcStatus.toString(),
                                      style: textTheme.bodyText2?.copyWith(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 3, left: 3),
                                      child: InkWell(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Dialog(
                                                  child: Expanded(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20)),
                                                      height: 400,
                                                      child: SingleChildScrollView(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Container(
                                                                width: 300,
                                                                height: 150,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color:
                                                                      Colors.white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                  image:
                                                                      DecorationImage(
                                                                    image: NetworkImage(
                                                                        element
                                                                            .misMediaUrl),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                              child: Text(
                                                                //int sortn = mis.misSeq,
                                                                '# ${missions.indexOf(element) + 1} ${element.misName}',
                                                                style: textTheme
                                                                    .bodyLarge
                                                                    ?.copyWith(
                                                                  color:
                                                                      Colors.purple,
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right: 20,
                                                                      left: 20),
                                                              child: Divider(),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                              child: Text(
                                                                  'รายละเอียด: ',
                                                                  style: textTheme
                                                                      .bodyLarge!),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only( left: 10),
                                                              child: Text(
                                                                element.misDiscrip,
                                                                style: textTheme
                                                                    .bodyLarge!,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right: 20,
                                                                      left: 20),
                                                              child: Divider(),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                              child: Text(
                                                                  'ประเภท: ' +
                                                                      misType,
                                                                  style: textTheme
                                                                      .bodyLarge!),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right: 20,
                                                                      left: 20),
                                                              child: Divider(),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10,
                                                                      bottom: 10),
                                                              child: Text(
                                                                  'ระยะภารกิจ: ' +
                                                                      element
                                                                          .misDistance
                                                                          .toString() +
                                                                      ' เมตร',
                                                                  style: textTheme
                                                                      .bodyLarge!),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              });
                                        },
                                        child: Material(
                                          elevation: 10,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Container(
                                              height: 120,
                                              color: Colors.white,
                                              child: Row(
                                                children: <Widget>[
                                                  SizedBox(width: 10),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10),
                                                          child: Text(
                                                            //int sortn = mis.misSeq,
                                                            '# ${missions.indexOf(element) + 1} ${element.misName}',
                                                            style: textTheme
                                                                .bodyLarge
                                                                ?.copyWith(
                                                              color:
                                                                  Colors.purple,
                                                            ),
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 8,
                                                                      bottom: 8,
                                                                      left: 10,
                                                                      right:
                                                                          10),
                                                              child: FaIcon(
                                                                  FontAwesomeIcons
                                                                      .filePen),
                                                            ),
                                                            Container(
                                                              width: 180,
                                                              child: Text(
                                                                element
                                                                    .misDiscrip,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: textTheme
                                                                    .bodyLarge!,
                                                                maxLines: 1,
                                                                // new),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8),
                                                          child: Text(
                                                              'ประเภท ' +
                                                                  misType,
                                                              style: textTheme
                                                                  .bodyLarge!
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .grey)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  element.misType != 3
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 8),
                                                          child: FilledButton(
                                                            child: Text(
                                                                'ดูหลักฐาน'),
                                                            onPressed:
                                                                () async {
                                                              var mcStatus = missionComs
                                                                  .where((e) =>
                                                                      e.mission
                                                                              .misId ==
                                                                          element
                                                                              .misId &&
                                                                      e.mcStatus ==
                                                                          1)
                                                                  .length;
                                                              log('assssss ' +
                                                                  mcStatus
                                                                      .toString());
                                                              if (mcStatus ==
                                                                  0) {
                                                                AwesomeDialog(
                                                                  context:
                                                                      context,
                                                                  dialogType:
                                                                      DialogType
                                                                          .warning,
                                                                  animType: AnimType
                                                                      .bottomSlide,
                                                                  headerAnimationLoop:
                                                                      false,
                                                                  title:
                                                                      'ไม่มีหลักฐานให้ตรวจสอบ',
                                                                  desc:
                                                                      'เนื่องจากคุณได้ตรวจไปแล้ว\n หรือยังไม่มีหลักฐานที่ส่งเข้ามา',
                                                                ).show();
                                                              }
                                                              showDialog<void>(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return Dialog
                                                                      .fullscreen(
                                                                    child:
                                                                        ListApprove(),
                                                                  );
                                                                },
                                                              ).then((value) {
                                                                setState(() {
                                                                  loadDataMethod =
                                                                      loadData();
                                                                });
                                                              });

                                                              context
                                                                      .read<
                                                                          AppData>()
                                                                      .misID =
                                                                  element.misId;
                                                            },
                                                          ),
                                                        )
                                                      : ElevatedButton(
                                                          onPressed: null,
                                                          child: Text(
                                                            'ไม่ต้องตรวจสอบ',
                                                          ),
                                                        ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ));
                            }).toList(),
                          ),
                        ),
                        rStatus == 2
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: SizedBox(
                                  height: 55,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.lightGreen),
                                    ),
                                    onPressed: () {
                                      startLoading(context);
                                      _endgame();
                                      stopLoading();
                                    },
                                    child: Text(
                                      'ประมวลผลการแข่งขัน',
                                      style: Get.textTheme.bodyLarge!.copyWith(
                                          color:
                                              Get.theme.colorScheme.onPrimary,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              )
                            : rStatus == 3
                                ? Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: SizedBox(
                                      height: 55,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.pinkAccent),
                                        ),
                                        onPressed: () {
                                          log('remain ' + remainMC.toString());

                                          if (remainMC != 0) {
                                            AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.error,
                                              animType: AnimType.bottomSlide,
                                              headerAnimationLoop: false,
                                              title:
                                                  'มีหลักฐานที่ยังไม่ตรวจสอบ',
                                              desc:
                                                  'กรุณาตรวจสอบภารกิจให้เสร็จสิ้น?',
                                              btnOkText: "ตกลง",
                                              btnOkOnPress: () async {},
                                              btnOkColor: Colors.redAccent,
                                            ).show();
                                          } else {
                                            //loop เรียงลำดับ
                                            startLoading(context);
                                            _processGame();
                                            context.read<AppData>().idrace =
                                                idrace;
                                            stopLoading();
                                          }
                                        },
                                        child: Text(
                                          'จบการแข่งขัน',
                                          style: Get.textTheme.bodyLarge!
                                              .copyWith(
                                                  color: Get.theme.colorScheme
                                                      .onPrimary,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              }),
        ));
  }

  void _endgame() async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.bottomSlide,
      headerAnimationLoop: false,
      title: 'ประมวลผลการแข่งขัน',
      desc: 'กรุณาตรวจสอบการแข่งขันให้เสร็จสิ้น\n เพื่อทำการจบการแข่งขัน',
      btnOkText: "ยกเลิก",
      btnCancelText: "ตกลง",
      btnOkOnPress: () async {},
      btnCancelColor: Colors.lightGreen,
      btnOkColor: Colors.redAccent,
      btnCancelOnPress: () async {
        startLoading(context);
        raceStatus = 3;
        log(remainMC.toString());
        RaceStatusDto racedto = RaceStatusDto(raceStatus: raceStatus);
        var racestatus = await raceService.updateStatusRaces(racedto, idrace);
        mc = {
          'notitype': 'endgame',
          'mcid': raceStatus,
          'raceID': idrace,
          'raceName': raceName
        };
        var notification1 = OSCreateNotification(
            //playerID
            additionalData: mc,
            playerIds: playerIds,
            content: raceName,
            heading: "จบการแข่งขัน",
            //  iosAttachments: {"id1",urlImage},
            // bigPicture: imUrlString,
            buttons: [
              OSActionButton(text: "ตกลง", id: "id1"),
              OSActionButton(text: "ยกเลิก", id: "id2")
            ]);
        log('player ' + playerIds.toString());

        var response1 = await OneSignal.shared.postNotification(notification1);
        setState(() {
          loadDataMethod = loadData();
        });
        stopLoading();
      },
    ).show();

    setState(() {
      loadDataMethod = loadData();
    });
  }
}
