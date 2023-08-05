import 'dart:developer';

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
import 'package:miniworldapp/page/Host/rank_race.dart';
import 'package:miniworldapp/page/showmap.dart';
import 'package:miniworldapp/service/missionComp.dart';
import 'package:miniworldapp/service/race.dart';
import 'package:miniworldapp/service/team.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

import '../../model/DTO/raceStatusDTO.dart';
import '../../model/mission.dart';
import '../../model/result/raceResult.dart';
import '../../model/reward.dart';
import '../../service/attend.dart';
import '../../service/mission.dart';
import '../../service/provider/appdata.dart';
import '../../service/reward.dart';
import '../../widget/loadData.dart';

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
    log('id' + raceStatus.toString());

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
      var mcs = await missionCompService.missionCompByraceId(raceID: idrace);
      missionComs = mcs.data;
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

  void _Endgame() async {
    raceStatus = 3;
    RaceStatusDto racedto = RaceStatusDto(raceStatus: raceStatus);
    var racestatus = await raceService.updateStatusRaces(racedto, idrace);
    mc = {
      'notitype': 'endgame',
      'mcid': raceStatus,
      'raceID': idrace,
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
    Get.defaultDialog(title: 'จบการแข่งขันแล้ว')
        .then((value) => Get.to(HomeAll()));
  }

  void _processGame() async {
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
    Get.defaultDialog(title: 'ประมวลผลการแข่งขันแล้ว');

    Get.to(
      RankRace(),
    );
    context.read<AppData>().idrace = idrace;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Image.asset(
                "assets/image/target.png"
              ),
              onPressed: () {
                Get.to(ShowMapPage());
                context.read<AppData>().idrace = idrace;
              },
             
            ),
          )
        ],
        // Overide the default Back button
        automaticallyImplyLeading: false,
        leadingWidth: 100,
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

        // other stuff
        title: const Text('ภารกิจ'),
      ),
      floatingActionButton: context.read<AppData>().raceStatus != 3
          ? FloatingActionButton.extended(
              backgroundColor: Colors.pinkAccent,
              onPressed: () {
                _Endgame();
              },
              label: Text(
                'จบการแข่งขัน',
                style: Get.textTheme.bodyLarge!.copyWith(
                    color: Get.theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold),
              ),
            )
          : context.read<AppData>().raceStatus == 3 && remainMC == 0
              ? FloatingActionButton.extended(
                  backgroundColor: Colors.lightGreen,
                  onPressed: () {
                    // log();
                    if (remainMC != 0) {
                      Get.defaultDialog(
                          title: 'กรุณาตรวจสอบภารกิจให้เสร็จสิ้น');
                    } else {
                      //loop เรียงลำดับ

                      _processGame();
                      context.read<AppData>().idrace = idrace;
                    }
                  },
                  label: Text(
                    'ประมวลผลการแข่งขัน',
                    style: Get.textTheme.bodyLarge!.copyWith(
                        color: Get.theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold),
                  ),
                )
              : Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: FutureBuilder(
          future: loadDataMethod,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              remainMC = 0;
              return ListView(
                padding: EdgeInsets.only(top: 10),
                children: missions.map((element) {
                  final theme = Theme.of(context);
                  final textTheme = theme.textTheme;
                  var mcStatus = missionComs
                      .where((e) =>
                          e.mission.misId == element.misId && e.mcStatus == 1)
                      .length;

                  remainMC += mcStatus;

                  log('remain ' + remainMC.toString());
                  //  log('mcss ' + mcStatus.toString());
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                    child: element.misType != 3
                        ? badges.Badge(
                            position:
                                badges.BadgePosition.topEnd(top: -5, end: 5),
                            badgeAnimation: badges.BadgeAnimation.slide(
                                // disappearanceFadeAnimationDuration: Duration(milliseconds: 200),
                                // curve: Curves.easeInCubic,
                                ),
                            //  showBadge: _showCartBadge,
                            badgeStyle: badges.BadgeStyle(
                              badgeColor: Colors.red,
                            ),
                            badgeContent: Text(
                              mcStatus.toString(),
                              style: textTheme.bodyText2
                                  ?.copyWith(fontSize: 16, color: Colors.white),
                            ),
                            child: element.misType != 3
                                ? Card(
                                    //  shadowColor: ,

                                    clipBehavior: Clip.hardEdge,

                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(12.0),
                                      splashColor: Colors.blue.withAlpha(30),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            alignment: Alignment.center,
                                            // For testing different size item. You can comment this line
                                            padding: element.misName ==
                                                    element.misName
                                                ? const EdgeInsets.symmetric(
                                                    vertical: 16.0)
                                                : EdgeInsets.zero,
                                            child: ListTile(
                                                title: Text(
                                                  element.misName,
                                                  style: textTheme.bodyText2
                                                      ?.copyWith(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                leading: SizedBox(
                                                  width: 36,
                                                  height: 36,
                                                  child: Center(
                                                    child: Text(
                                                      //int sortn = mis.misSeq,
                                                      '${missions.indexOf(element) + 1}',
                                                      style: textTheme.bodyLarge
                                                          ?.copyWith(
                                                        color: Colors.purple,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                trailing: FilledButton(
                                                  child: Text('ตรวจสอบภารกิจ'),
                                                  onPressed: () {
                                                    Get.to(ListApprove());
                                                    context
                                                        .read<AppData>()
                                                        .misID = element.misId;
                                                  },
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(),
                          )
                        : Container(),
                  );
                }).toList(),
              );
            } else {
              return Container();
            }
          }),
    );
  }
}
