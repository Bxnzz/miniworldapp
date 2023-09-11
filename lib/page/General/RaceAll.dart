import 'dart:developer';



import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:miniworldapp/model/attend.dart';
import 'package:miniworldapp/model/result/rewardResult.dart';
import 'package:miniworldapp/page/General/detil_race.dart';
import 'package:miniworldapp/service/attend.dart';
import 'package:miniworldapp/service/reward.dart';
import 'package:provider/provider.dart';

import '../../model/race.dart';
import '../../model/result/attendRaceResult.dart';
import '../../service/provider/appdata.dart';
import '../../service/race.dart';
import '../../widget/loadData.dart';

class RaceAll extends StatefulWidget {
  const RaceAll({super.key});

  @override
  State<RaceAll> createState() => _RaceAllState();
}

class _RaceAllState extends State<RaceAll> {
  // 1. กำหนดตัวแปร
  List<Race> races = [];
  List<RewardResult> rewards= [];
  int idUser = 0;
  bool isLoaded = false;
  List<AttendRace> teamAttends = [];
  Set<int> teamMe = {};
  Set<int> teamAllRegis = {};
  Set<int> teamRe = {};
  Set<int> all = {};
  int sum1 = 0;
  int sum2 = 0;
  int sum3 = 0;
  

  late Future<void> loadDataMethod;
  late RaceService raceService;
  late AttendService attendService;
  late RewardService rewardService;

  var formatter = DateFormat.yMEd();
  // var dateInBuddhistCalendarFormat = formatter.formatInBuddhistCalendarThai(now);
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // 2.1 object ของ service โดยต้องส่ง baseUrl (จาก provider) เข้าไปด้วย
    raceService = RaceService(Dio(), baseUrl: context.read<AppData>().baseurl);
    raceService.races().then((value) {
      log(value.data.first.raceName);
    });
    idUser = context.read<AppData>().idUser;
    log(idUser.toString());
    attendService =
        AttendService(Dio(), baseUrl: context.read<AppData>().baseurl);
    rewardService =
        RewardService(Dio(), baseUrl: context.read<AppData>().baseurl);
    // 2.2 async method
    loadDataMethod = loadData();
  }

  Future refresh() async {
    setState(() {
      loadDataMethod = loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: refresh,
          child: FutureBuilder(
              future: loadDataMethod,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.done) {
                  return Column(
                    children: <Widget>[
                       Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                "assets/image/crown1.png",
                width: 50,
              ),
              Text(sum1.toString()),
               Image.asset(
                "assets/image/crown2.png",
                width: 50,
              ),
              Text(sum2.toString()),
              Image.asset(
                "assets/image/crown3.png",
                width: 50,
              ),
              Text(sum3.toString()),
            ]),
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          //padding: EdgeInsets.only(top: 10),
                          children: races
                              .where((element) =>
                                  element.raceStatus != 3 &&
                                  element.raceStatus != 2 &&
                                  element.raceStatus != 4 &&
                                  element.userId != idUser &&
                                  teamMe.contains(element.raceId) == false)
                              .map((e) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 2.5, right: 2.5, bottom: 5),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 2,
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      20.0), //<-- SEE HERE
                                ),
                                //  shadowColor: ,
                                color: Colors.white,
                                clipBehavior: Clip.hardEdge,
                      
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12.0),
                                  splashColor: Colors.blue.withAlpha(30),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DetailRace()));
                                    context.read<AppData>().idrace =
                                        e.raceId;
                                  },
                                  child: GridTile(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                      child: Image.network(e.raceImage,
                                          //  width: Get.width,
                                          //  height: Get.width*0.5625/2,
                                          fit: BoxFit.cover),
                                      footer: Container(
                                        color: Get
                                            .theme.colorScheme.onBackground
                                            .withOpacity(0.5),
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 5, 10, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(e.raceName,
                                                    style: Get.textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                            color: Get
                                                                .theme
                                                                .colorScheme
                                                                .onPrimary)),
                                                Text("# ${e.raceId}",
                                                    style: Get.textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                            color: Get
                                                                .theme
                                                                .colorScheme
                                                                .onPrimary)),
                                              ],
                                            ),
                                            Container(height: 5),
                                            // Text("ปิดรับสมัคร: " +
                                            //     formatter.formatInBuddhistCalendarThai(
                                            //         element.raceTimeFn)),
                                            Text(
                                                "สถานที่: " +
                                                    e.raceLocation,
                                                style: Get
                                                    .textTheme.bodySmall!
                                                    .copyWith(
                                                        color: Get
                                                            .theme
                                                            .colorScheme
                                                            .onPrimary
                                                            .withOpacity(
                                                                0.8))),
                                            Container(height: 5),
                                          ],
                                        ),
                                      )),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Container();
                  // const CircularProgressIndicator();
                }
              }),
        ),
      ),
    );
  }

  Future<void> loadData() async {
    startLoading(context);
    try {
      idUser = context.read<AppData>().idUser;
      log('user ' + idUser.toString());

      var a = await raceService.races();
      races = a.data;
      isLoaded = true;

      var t = await attendService.attendByUserID(userID: idUser);
      teamAttends = t.data;
      //  hostID = t.data.first
      


      for (var tm in teamAttends) {
        log(tm.team.raceId.toString());
        teamMe.add(tm.team.raceId);
        //log('teamAll'+ tm.teamId.toString());
        teamAllRegis.add(tm.teamId);
      }
      log('teamAll'+ teamAllRegis.toString());
      log('raceteams ' + teamMe.toString());
    
    var re = await rewardService.rewardAll();
    rewards = re.data;
   sum1 = 0; sum2 = 0; sum3 = 0;
    for (var element in rewards) {
    //  log('RewardTeam'+element.teamId.toString());
      teamRe.add(element.teamId);  
      var all = teamAllRegis.intersection(teamRe);
      log('all$all'); 
    
      if(all.contains(element.teamId)){
        log('Name '+element.team.teamName + ' no. '+element.reType.toString());
        log('sumAll '+all.length.toString());
        if (element.reType == 1) {
          log('sum '+all.length.toString());
          sum1 = all.length;
          log('sum1 '+sum1.toString());
        }
        if(element.reType == 2) {
          log('sum2 '+all.length.toString());
           sum2 = all.length;
        }
         if(element.reType == 3) {
          log('sum3 '+all.length.toString());
           sum3 = all.length;
        }else{

        }
      }
   }
   

    

    } catch (err) {
      isLoaded = false;
      log('Error:$err');
    } finally {
      stopLoading();
    }
  }
}
