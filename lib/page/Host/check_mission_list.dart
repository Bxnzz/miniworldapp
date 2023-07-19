import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miniworldapp/model/attend.dart';
import 'package:miniworldapp/model/missionComp.dart';
import 'package:miniworldapp/model/result/attendRaceResult.dart';
import 'package:miniworldapp/model/team.dart';
import 'package:miniworldapp/page/Host/list_approve.dart';
import 'package:miniworldapp/service/missionComp.dart';
import 'package:miniworldapp/service/race.dart';
import 'package:miniworldapp/service/team.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

import '../../model/DTO/raceStatusDTO.dart';
import '../../model/mission.dart';
import '../../model/result/raceResult.dart';
import '../../service/attend.dart';
import '../../service/mission.dart';
import '../../service/provider/appdata.dart';
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
  List<Team> teams= [];
  List<AttendRace> attends= [];
   Map<String, dynamic> mc = {};

  final seq = <int>[];
  late Future<void> loadDataMethod;
  late RaceResult misResults;
  late AttendService attendService;
  late MissionService missionService;
  late TeamService teamService;
  late RaceService raceService;
  late MissionCompService missionCompService;
   String raceName = '';
  String type1 = '';
  String type2 = '';
  String type3 = '';
  String mType = '';
  String types = '';
 int misStatus = 0; 
 int raceStatus = 0;
 int misID = 0;
 
 List<int> teamsID = [];
 List<String> playerIds = [];

  bool isLoaded = false;


  bool inReorder = false;

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    idrace = context.read<AppData>().idrace;
    log('id' + idrace.toString());

    missionService =
        MissionService(Dio(), baseUrl: context.read<AppData>().baseurl);
    
     attendService =
        AttendService(Dio(), baseUrl: context.read<AppData>().baseurl);
    
     missionCompService =
        MissionCompService(Dio(), baseUrl: context.read<AppData>().baseurl);
    
     teamService =
    TeamService(Dio(), baseUrl: context.read<AppData>().baseurl);

     raceService =
    RaceService(Dio(), baseUrl: context.read<AppData>().baseurl);
   
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

      var t = await teamService.teambyRaceID(raceID: idrace);
      teams = t.data;
      teamsID.clear() ;
      for (var element in t.data) {
        teamsID.add(element.teamId);
      }
      log('team ' + teamsID.toString());
      
      var at = await attendService.attendByRaceID(raceID: idrace);
      attends = at.data;
      playerIds.clear() ;
      for (var element in at.data) {
        if(element.user.onesingnalId.isNotEmpty){
        playerIds.add(element.user.onesingnalId);
        }
        
      }
      log('att ' + playerIds.toString());
        var mcs = await missionCompService.missionCompAll();
       missionComs = mcs.data;
      
      // misStatus = mcs.
      
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
    mc = {'notitype':'endgame','mcid': raceStatus,'raceID':idrace,};
    var notification1 = OSCreateNotification(
        //playerID
       additionalData: mc,
        playerIds: playerIds,
        content:  raceName,
        heading: "จบการแข่งขัน",
        //  iosAttachments: {"id1",urlImage},
        // bigPicture: imUrlString,
        buttons: [
          OSActionButton(text: "ตกลง", id: "id1"),
          OSActionButton(text: "ยกเลิก", id: "id2")
        ]);
    log('player '+playerIds.toString());
    var response1 = await OneSignal.shared.postNotification(notification1);
    Get.defaultDialog(title: mc.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          'ภารกิจ',
          //  style: TextStyle(color: Colors.white),
        )),
      ),
      floatingActionButton:  FloatingActionButton.extended(
        backgroundColor: Colors.pinkAccent,
       
        onPressed: () {
          _Endgame();
        },
        label: Text('จบการแข่งขัน',style: Get.textTheme.bodyLarge!.copyWith(
                              color: Get.theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.bold),),
        
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      
      body: FutureBuilder(
          future: loadDataMethod,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView(
                padding: EdgeInsets.only(top: 10),
                children: missions.map((element) {
                  final theme = Theme.of(context);
                  final textTheme = theme.textTheme;
                  var mcStatus = missionComs.where((e) => e.mission.misId == element.misId && e.mcStatus == 1).length;
      log('mcss '+mcStatus.toString());
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                    child: element.misType != 3 ? 
                    badges.Badge(
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
                              style: textTheme.bodyText2?.copyWith(
                                        fontSize: 16,color: Colors.white
                                      ),
                            ),
                      child: element.misType != 3 
                      ? Card(
                        //  shadowColor: ,
                    
                        clipBehavior: Clip.hardEdge,
                    
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12.0),
                          splashColor: Colors.blue.withAlpha(30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                // For testing different size item. You can comment this line
                                padding: element.misName == element.misName
                                    ? const EdgeInsets.symmetric(vertical: 16.0)
                                    : EdgeInsets.zero,
                                child: ListTile(
                                    title: Text(
                                      element.misName,
                                      style: textTheme.bodyText2?.copyWith(
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
                                          style: textTheme.bodyLarge?.copyWith(
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
                                       context.read<AppData>().misID = element.misId;
                                      },
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ): Container(),
                    ) : Container(),
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
